import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/db/database_provider.dart';
import '../../../core/db/pet_health_database.dart' hide PetPresets;
import '../../../core/units/units.dart';
import '../../entries/domain/entry_codes.dart';
import '../../plans/data/plan_columns.dart';
import '../../plans/domain/plan_codes.dart';
import '../../settings/data/preferences_repository.dart';
import '../domain/breed_catalog.dart';
import '../domain/pet.dart';
import '../domain/pet_codes.dart';

final petsRepositoryProvider = Provider<PetsRepository>((ref) {
  return PetsRepository(
    ref.watch(petHealthDatabaseProvider),
    clock: ref.watch(clockProvider),
  );
});

final allPetsProvider = StreamProvider<List<Pet>>((ref) {
  return ref.watch(petsRepositoryProvider).watchAll();
});

/// 档案与习惯预设的读写。
///
/// 照片和时光的文件清理不在这里：删除狗狗前由照片 / 时光服务先清理文件，
/// 数据库行随外键级联删除。
class PetsRepository {
  PetsRepository(this._db, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final PetHealthDatabase _db;
  final DateTime Function() _clock;
  static const _uuid = Uuid();

  /// 默认的一键记录。
  static const defaultQuickTypes = [
    EntryType.meal,
    EntryType.water,
    EntryType.potty,
    EntryType.brushing,
  ];

  /// 按创建时间排列。
  Stream<List<Pet>> watchAll() => _allQuery().watch().map(_toPets);

  Future<List<Pet>> getAll() => _allQuery().get().then(_toPets);

  Future<Pet?> getById(String id) async {
    final row = await (_db.select(
      _db.pets,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return row == null ? null : _toPet(row);
  }

  /// 新建档案，同时写入默认预设和按犬种分组生成的计划；
  /// 还没有选中的狗狗时自动选中它。
  Future<Pet> create(PetDraft draft) async {
    _validate(draft);
    final id = _uuid.v4();
    final now = _clock();
    final group = draft.breedGroup ?? breedGroupFor(draft.breedCode);
    await _db.transaction(() async {
      await _db
          .into(_db.pets)
          .insert(_petCompanion(draft, id, group: group, createdAt: now));
      await _db
          .into(_db.petPresets)
          .insert(
            PetPresetsCompanion.insert(
              petId: id,
              quickTypes: const Value(defaultQuickTypes),
            ),
          );
      await _insertDefaultPlans(id, group, now);
      final selected = await _selectedPetId();
      if (selected == null || await getById(selected) == null) {
        await putPreference(_db, PreferenceKeys.selectedPetId, id, now: now);
      }
    });
    return (await getById(id))!;
  }

  /// 修改档案。犬种分组变了也不会自动替换计划，由页面询问后调用
  /// [applyBreedDefaults]。
  Future<Pet> update(String id, PetDraft draft) async {
    final existing = await getById(id);
    if (existing == null) throw ArgumentError.value(id, 'id', 'No such pet');
    _validate(draft);
    final group = draft.breedGroup ?? breedGroupFor(draft.breedCode);
    await (_db.update(_db.pets)..where((t) => t.id.equals(id))).write(
      _petCompanion(draft, id, group: group, createdAt: existing.createdAt),
    );
    return (await getById(id))!;
  }

  /// 按当前犬种分组重新生成默认计划。用户自己建的或改过的计划不受影响。
  Future<void> applyBreedDefaults(String petId) => _db.transaction(() async {
    final pet = await getById(petId);
    if (pet == null) throw ArgumentError.value(petId, 'petId', 'No such pet');
    await (_db.delete(_db.plans)..where(
          (t) =>
              t.petId.equals(petId) &
              t.source.equals(PlanSource.breedDefault.code),
        ))
        .go();
    await _insertDefaultPlans(petId, pet.breedGroup, _clock());
  });

  /// 删除档案及其全部数据；删的是当前狗狗时，改选最早建的另一只。
  Future<bool> delete(String id) => _db.transaction(() async {
    final deleted = await (_db.delete(
      _db.pets,
    )..where((t) => t.id.equals(id))).go();
    if (deleted == 0) return false;
    if (await _selectedPetId() == id) {
      final next = await (_allQuery()..limit(1)).getSingleOrNull();
      await putPreference(
        _db,
        PreferenceKeys.selectedPetId,
        next?.id,
        now: _clock(),
      );
    }
    return true;
  });

  Stream<PetPresets?> watchPresets(String petId) =>
      (_db.select(_db.petPresets)..where((t) => t.petId.equals(petId)))
          .watchSingleOrNull()
          .map((row) => row == null ? null : _toPresets(row));

  Future<PetPresets> savePresets(String petId, PetPresetsDraft draft) async {
    _validatePresets(draft);
    await _db
        .into(_db.petPresets)
        .insertOnConflictUpdate(
          PetPresetsCompanion.insert(
            petId: petId,
            mealAmount: Value(draft.mealAmount),
            mealUnit: Value(draft.mealUnit),
            mealsPerDay: Value(draft.mealsPerDay),
            bowlMl: Value(draft.bowlMl),
            quickTypes: Value(draft.quickTypes),
          ),
        );
    return (await watchPresets(petId).first)!;
  }

  SimpleSelectStatement<$PetsTable, PetRow> _allQuery() => _db.select(_db.pets)
    ..orderBy([
      (t) => OrderingTerm.asc(t.createdAt),
      (t) => OrderingTerm.asc(t.id),
    ]);

  Future<String?> _selectedPetId() async {
    final row =
        await (_db.select(_db.appSettings)
              ..where((t) => t.key.equals(PreferenceKeys.selectedPetId)))
            .getSingleOrNull();
    return row?.value;
  }

  Future<void> _insertDefaultPlans(
    String petId,
    BreedGroup group,
    DateTime now,
  ) async {
    for (final plan in defaultPlansFor(group)) {
      await _db
          .into(_db.plans)
          .insert(
            scheduleColumns(plan.schedule).copyWith(
              id: Value(_uuid.v4()),
              petId: Value(petId),
              entryType: Value(plan.entryType),
              entryKind: Value(plan.entryKind),
              source: const Value(PlanSource.breedDefault),
              createdAt: Value(now.toUtc()),
              updatedAt: Value(now.toUtc()),
            ),
          );
    }
  }

  PetsCompanion _petCompanion(
    PetDraft draft,
    String id, {
    required BreedGroup group,
    required DateTime createdAt,
  }) {
    final birthDate = draft.birthDate;
    return PetsCompanion.insert(
      id: id,
      name: draft.name.trim(),
      sex: Value(draft.sex),
      neutered: Value(draft.neutered),
      birthDate: Value(
        birthDate == null
            ? null
            : DateTime(
                birthDate.year,
                birthDate.month,
                // 只知道年月时存当月 1 日。
                draft.birthPrecision == BirthPrecision.month
                    ? 1
                    : birthDate.day,
              ),
      ),
      birthPrecision: Value(draft.birthPrecision),
      homeDate: Value(draft.homeDate),
      breedCode: Value(_trimmedOrNull(draft.breedCode)),
      breedName: Value(_trimmedOrNull(draft.breedName)),
      breedGroup: Value(group),
      createdAt: createdAt.toUtc(),
      updatedAt: _clock().toUtc(),
    );
  }

  void _validate(PetDraft draft) {
    if (draft.name.trim().isEmpty) {
      throw ArgumentError('A pet needs a name');
    }
    final today = _day(_clock());
    for (final (name, date) in [
      ('birthDate', draft.birthDate),
      ('homeDate', draft.homeDate),
    ]) {
      if (date != null && _day(date).isAfter(today)) {
        throw ArgumentError.value(date, name, 'Cannot be in the future');
      }
    }
  }

  static void _validatePresets(PetPresetsDraft draft) {
    for (final (name, value) in [
      ('mealAmount', draft.mealAmount),
      ('bowlMl', draft.bowlMl),
    ]) {
      if (value != null && (!value.isFinite || value <= 0)) {
        throw ArgumentError.value(value, name, 'Must be positive');
      }
    }
    final meals = draft.mealsPerDay;
    if (meals != null && (meals < 1 || meals > 10)) {
      throw ArgumentError.value(meals, 'mealsPerDay', 'Must be 1 to 10');
    }
    final unit = draft.mealUnit;
    if (unit != null && !PortionUnit.food.contains(unit)) {
      throw ArgumentError.value(unit, 'mealUnit', 'Not a food unit');
    }
    final types = draft.quickTypes;
    if (types.toSet().length != types.length ||
        types.contains(EntryType.custom)) {
      throw ArgumentError.value(types, 'quickTypes', 'Invalid quick types');
    }
  }

  static DateTime _day(DateTime time) =>
      DateTime(time.year, time.month, time.day);

  static String? _trimmedOrNull(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }

  static List<Pet> _toPets(List<PetRow> rows) =>
      rows.map(_toPet).toList(growable: false);

  static Pet _toPet(PetRow row) => Pet(
    id: row.id,
    name: row.name,
    sex: row.sex,
    neutered: row.neutered,
    birthDate: row.birthDate,
    birthPrecision: row.birthPrecision,
    homeDate: row.homeDate,
    breedCode: row.breedCode,
    breedName: row.breedName,
    breedGroup: row.breedGroup,
    createdAt: row.createdAt.toLocal(),
    updatedAt: row.updatedAt.toLocal(),
  );

  static PetPresets _toPresets(PetPresetRow row) => PetPresets(
    petId: row.petId,
    mealAmount: row.mealAmount,
    mealUnit: row.mealUnit,
    mealsPerDay: row.mealsPerDay,
    bowlMl: row.bowlMl,
    quickTypes: row.quickTypes,
  );
}
