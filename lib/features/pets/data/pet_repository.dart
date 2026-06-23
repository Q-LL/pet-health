import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart' as db;
import '../../../core/database/database_provider.dart';
import '../../care/data/care_repository.dart' show defaultLocalPetId;
import 'pet_photo_repository.dart';
import '../domain/pet_profile.dart';

const selectedPetSettingKey = 'selected_pet_id';

final petRepositoryProvider = Provider<PetRepository>((ref) {
  return PetRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(petPhotoRepositoryProvider),
  );
});

final petsProvider = StreamProvider<List<PetProfile>>((ref) async* {
  final repository = ref.watch(petRepositoryProvider);
  await repository.ensureSelectedPetId();
  yield* repository.watchPets();
});

final selectedPetIdProvider = StreamProvider<String>((ref) async* {
  final repository = ref.watch(petRepositoryProvider);
  await repository.ensureSelectedPetId();
  yield* repository.watchSelectedPetId();
});

class PetRepository {
  PetRepository(this._database, [this._photoRepository]) : _uuid = const Uuid();

  final db.AppDatabase _database;
  final PetPhotoRepository? _photoRepository;
  final Uuid _uuid;

  Stream<List<PetProfile>> watchPets({
    String? keyword,
    String? species,
    bool includePlaceholder = true,
    int? limit,
    int offset = 0,
  }) {
    _validatePage(limit: limit, offset: offset);
    final search = keyword?.trim();
    final speciesFilter = species?.trim();
    final query = _database.select(_database.pets)
      ..where((pet) {
        Expression<bool> expression = const Constant(true);
        if (!includePlaceholder) expression &= pet.isPlaceholder.equals(false);
        if (speciesFilter != null && speciesFilter.isNotEmpty) {
          expression &= pet.species.equals(speciesFilter);
        }
        if (search != null && search.isNotEmpty) {
          expression &=
              pet.name.contains(search) |
              pet.breed.contains(search) |
              pet.allergies.contains(search) |
              pet.chronicConditions.contains(search);
        }
        return expression;
      })
      ..orderBy([
        (pet) => OrderingTerm.asc(pet.isPlaceholder),
        (pet) => OrderingTerm.asc(pet.createdAt),
      ]);
    if (limit != null) query.limit(limit, offset: offset);
    return query.watch().map(
      (rows) => rows.map(_profileFromRow).toList(growable: false),
    );
  }

  Future<List<PetProfile>> findPets({
    String? keyword,
    String? species,
    bool includePlaceholder = false,
    int? limit,
    int offset = 0,
  }) {
    return watchPets(
      keyword: keyword,
      species: species,
      includePlaceholder: includePlaceholder,
      limit: limit,
      offset: offset,
    ).first;
  }

  Stream<String> watchSelectedPetId() {
    final query = _database.select(_database.appSettings)
      ..where((setting) => setting.key.equals(selectedPetSettingKey));
    return query.watchSingle().map((setting) => setting.value);
  }

  Future<String> ensureSelectedPetId() async {
    final setting = await (_database.select(
      _database.appSettings,
    )..where((row) => row.key.equals(selectedPetSettingKey))).getSingleOrNull();
    if (setting != null) {
      final pet = await (_database.select(
        _database.pets,
      )..where((row) => row.id.equals(setting.value))).getSingleOrNull();
      if (pet != null) return pet.id;
    }

    final firstPet = await (_database.select(
      _database.pets,
    )..limit(1)).getSingleOrNull();
    final petId = firstPet?.id ?? await _createPlaceholder();
    await selectPet(petId);
    return petId;
  }

  Future<PetProfile> create(PetDraft draft) => savePet(draft);

  Future<PetProfile> update(String id, PetDraft draft) async {
    if (await getById(id) == null) throw StateError('狗狗档案不存在：$id');
    return savePet(draft, id: id);
  }

  Future<PetProfile> savePet(PetDraft draft, {String? id}) async {
    final name = draft.name.trim();
    if (name.isEmpty) throw const FormatException('狗狗名字不能为空');

    final now = DateTime.now().toUtc();
    final placeholder = id == null
        ? await (_database.select(_database.pets)
                ..where((pet) => pet.isPlaceholder.equals(true))
                ..limit(1))
              .getSingleOrNull()
        : null;
    final targetId = id ?? placeholder?.id ?? _uuid.v4();
    final existing = await (_database.select(
      _database.pets,
    )..where((pet) => pet.id.equals(targetId))).getSingleOrNull();

    final companion = db.PetsCompanion(
      id: Value(targetId),
      name: Value(name),
      species: Value(_trimmedOrNull(draft.species)),
      breed: Value(_trimmedOrNull(draft.breed)),
      sex: Value(_trimmedOrNull(draft.sex)),
      birthday: Value(draft.birthday?.toUtc()),
      neutered: Value(draft.neutered),
      allergies: Value(draft.allergies.trim()),
      chronicConditions: Value(draft.chronicConditions.trim()),
      avatarPath: Value(
        draft.avatarPath == null
            ? existing?.avatarPath
            : _trimmedOrNull(draft.avatarPath),
      ),
      isPlaceholder: const Value(false),
      createdAt: Value(existing?.createdAt.toUtc() ?? now),
      updatedAt: Value(now),
    );

    await _database.into(_database.pets).insertOnConflictUpdate(companion);
    await selectPet(targetId);
    return (await getById(targetId))!;
  }

  Future<PetProfile?> getById(String id) async {
    final row = await (_database.select(
      _database.pets,
    )..where((pet) => pet.id.equals(id))).getSingleOrNull();
    return row == null ? null : _profileFromRow(row);
  }

  Future<PetProfile?> getPet(String id) => getById(id);

  Future<void> selectPet(String id) async {
    final exists = await (_database.select(
      _database.pets,
    )..where((pet) => pet.id.equals(id))).getSingleOrNull();
    if (exists == null) throw StateError('狗狗档案不存在：$id');

    await _database
        .into(_database.appSettings)
        .insertOnConflictUpdate(
          db.AppSettingsCompanion.insert(
            key: selectedPetSettingKey,
            value: id,
            updatedAt: DateTime.now().toUtc(),
          ),
        );
  }

  Future<bool> delete(String id) => deletePet(id);

  Future<bool> deletePet(String id) async {
    if (await getById(id) == null) return false;
    await _photoRepository?.deleteAllForPet(id);
    await _database.transaction(() async {
      await (_database.delete(
        _database.pets,
      )..where((pet) => pet.id.equals(id))).go();
      final next = await (_database.select(
        _database.pets,
      )..limit(1)).getSingleOrNull();
      final nextId = next?.id ?? await _createPlaceholder();
      await selectPet(nextId);
    });
    return true;
  }

  Future<String> _createPlaceholder() async {
    final now = DateTime.now().toUtc();
    await _database
        .into(_database.pets)
        .insert(
          db.PetsCompanion.insert(
            id: defaultLocalPetId,
            name: '我的狗狗',
            isPlaceholder: const Value(true),
            createdAt: now,
            updatedAt: now,
          ),
          mode: InsertMode.insertOrIgnore,
        );
    return defaultLocalPetId;
  }

  PetProfile _profileFromRow(db.Pet row) => PetProfile(
    id: row.id,
    name: row.name,
    species: row.species,
    breed: row.breed,
    sex: row.sex,
    birthday: row.birthday?.toUtc(),
    neutered: row.neutered,
    allergies: row.allergies,
    chronicConditions: row.chronicConditions,
    avatarPath: row.avatarPath,
    isPlaceholder: row.isPlaceholder,
    createdAt: row.createdAt.toUtc(),
    updatedAt: row.updatedAt.toUtc(),
  );

  void _validatePage({int? limit, required int offset}) {
    if (limit != null && limit <= 0) {
      throw const FormatException('limit 必须大于 0');
    }
    if (offset < 0 || (offset > 0 && limit == null)) {
      throw const FormatException('offset 必须非负且只能与 limit 一起使用');
    }
  }
}

String? _trimmedOrNull(String? value) {
  final trimmed = value?.trim();
  return trimmed == null || trimmed.isEmpty ? null : trimmed;
}
