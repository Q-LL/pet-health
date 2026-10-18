import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/db/database_provider.dart';
import '../../../core/db/pet_health_database.dart';
import '../../../core/units/units.dart';
import '../domain/entry.dart';
import '../domain/entry_codes.dart';
import '../domain/entry_details.dart';

final entriesRepositoryProvider = Provider<EntriesRepository>((ref) {
  return EntriesRepository(
    ref.watch(petHealthDatabaseProvider),
    clock: ref.watch(clockProvider),
  );
});

/// 记录的读写。时间参数和返回值都是本地时间，存储时转为 UTC。
///
/// 参数不合法属于调用方的错误（页面应先拦住），抛 [ArgumentError]；
/// 页面需要单独处理的情况使用专门的异常，比如 [ActiveWalkExists]。
class EntriesRepository {
  EntriesRepository(this._db, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final PetHealthDatabase _db;
  final DateTime Function() _clock;
  static const _uuid = Uuid();

  /// 按时间倒序返回一只狗的记录；[from] 包含、[to] 不包含。
  Stream<List<Entry>> watchForPet(
    String petId, {
    Set<EntryType>? types,
    DateTime? from,
    DateTime? to,
    int? limit,
  }) => _query(
    petId,
    types: types,
    from: from,
    to: to,
    limit: limit,
  ).watch().map(_toEntries);

  Future<List<Entry>> findForPet(
    String petId, {
    Set<EntryType>? types,
    DateTime? from,
    DateTime? to,
    int? limit,
  }) => _query(
    petId,
    types: types,
    from: from,
    to: to,
    limit: limit,
  ).get().then(_toEntries);

  Future<Entry?> getById(String id) async {
    final row = await (_db.select(
      _db.entries,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return row == null ? null : _toEntry(row);
  }

  Stream<Entry?> watchActiveWalk(String petId) => _activeWalkQuery(
    petId,
  ).watchSingleOrNull().map((row) => row == null ? null : _toEntry(row));

  Future<Entry> create(EntryDraft draft) async {
    _validate(draft);
    final id = _uuid.v4();
    final now = _clock().toUtc();
    await _db.transaction(() async {
      await _db.into(_db.entries).insert(_companion(draft, id, createdAt: now));
      await _clearSnoozes(draft.petId, draft.type, draft.planId);
    });
    return (await getById(id))!;
  }

  /// 修改记录内容；狗狗和记录类型不能修改，正在进行的遛狗请用 [finishWalk]。
  Future<Entry> update(String id, EntryDraft draft) async {
    final existing = await (_db.select(
      _db.entries,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (existing == null) throw ArgumentError.value(id, 'id', 'No such entry');
    if (existing.petId != draft.petId || existing.type != draft.type) {
      throw ArgumentError('An entry cannot move to another pet or type');
    }
    if (existing.type == EntryType.walk && existing.endedAt == null) {
      throw ArgumentError('Finish the active walk before editing it');
    }
    _validate(draft);
    await (_db.update(_db.entries)..where((t) => t.id.equals(id))).write(
      _companion(draft, id, createdAt: existing.createdAt.toUtc()),
    );
    return (await getById(id))!;
  }

  Future<bool> delete(String id) async {
    final deleted = await (_db.delete(
      _db.entries,
    )..where((t) => t.id.equals(id))).go();
    return deleted > 0;
  }

  /// 开始遛狗，立即入库；已经在遛时抛 [ActiveWalkExists]。
  Future<Entry> startWalk(String petId, {DateTime? at}) async {
    final startedAt = (at ?? _clock()).toUtc();
    final id = _uuid.v4();
    await _db.transaction(() async {
      if (await _activeWalkQuery(petId).getSingleOrNull() != null) {
        throw ActiveWalkExists(petId);
      }
      await _db
          .into(_db.entries)
          .insert(
            EntriesCompanion.insert(
              id: id,
              petId: petId,
              type: EntryType.walk,
              occurredAt: startedAt,
              startedAt: Value(startedAt),
              createdAt: startedAt,
              updatedAt: startedAt,
            ),
          );
    });
    return (await getById(id))!;
  }

  /// 结束正在进行的遛狗。没有在遛时返回 `null`，重复结束不会产生新记录。
  Future<Entry?> finishWalk(
    String petId, {
    DateTime? at,
    double? distanceM,
  }) async {
    _checkAmount(distanceM, 'distanceM');
    final endedAt = (at ?? _clock()).toUtc();
    final id = await _db.transaction(() async {
      final active = await _activeWalkQuery(petId).getSingleOrNull();
      if (active == null) return null;
      final startedAt = active.startedAt!.toUtc();
      // 结束时间早于开始时间（比如手动改过时钟）时按零时长处理。
      final end = endedAt.isBefore(startedAt) ? startedAt : endedAt;
      await (_db.update(
        _db.entries,
      )..where((t) => t.id.equals(active.id))).write(
        EntriesCompanion(
          endedAt: Value(end),
          durationSec: Value(end.difference(startedAt).inSeconds),
          distanceM: Value(distanceM),
          updatedAt: Value(_clock().toUtc()),
        ),
      );
      await _clearSnoozes(petId, EntryType.walk, null);
      return active.id;
    });
    return id == null ? null : getById(id);
  }

  SimpleSelectStatement<$EntriesTable, EntryRow> _query(
    String petId, {
    Set<EntryType>? types,
    DateTime? from,
    DateTime? to,
    int? limit,
  }) {
    if (from != null && to != null && !from.isBefore(to)) {
      throw ArgumentError('from must be before to');
    }
    if (limit != null && limit <= 0) {
      throw ArgumentError.value(limit, 'limit', 'Must be positive');
    }
    final query = _db.select(_db.entries)
      ..where((t) {
        var condition = t.petId.equals(petId);
        if (types != null) {
          condition &= t.type.isIn([for (final type in types) type.code]);
        }
        if (from != null) {
          condition &= t.occurredAt.isBiggerOrEqualValue(from.toUtc());
        }
        if (to != null) {
          condition &= t.occurredAt.isSmallerThanValue(to.toUtc());
        }
        return condition;
      })
      ..orderBy([
        (t) => OrderingTerm.desc(t.occurredAt),
        (t) => OrderingTerm.desc(t.createdAt),
      ]);
    if (limit != null) query.limit(limit);
    return query;
  }

  SimpleSelectStatement<$EntriesTable, EntryRow> _activeWalkQuery(
    String petId,
  ) => _db.select(_db.entries)
    ..where(
      (t) =>
          t.petId.equals(petId) &
          t.type.equals(EntryType.walk.code) &
          t.endedAt.isNull(),
    );

  /// 做过一次之后，同类型计划的"稍后提醒"就作废了，下一次按新的时间提醒。
  Future<void> _clearSnoozes(
    String petId,
    EntryType type,
    String? planId,
  ) async {
    await (_db.update(_db.plans)..where(
          (t) =>
              t.petId.equals(petId) &
              t.snoozedUntil.isNotNull() &
              (t.entryType.equals(type.code) |
                  (planId == null
                      ? const Constant(false)
                      : t.id.equals(planId))),
        ))
        .write(const PlansCompanion(snoozedUntil: Value(null)));
  }

  EntriesCompanion _companion(
    EntryDraft draft,
    String id, {
    required DateTime createdAt,
  }) {
    final startedAt = draft.startedAt?.toUtc();
    final endedAt = draft.endedAt?.toUtc();
    return EntriesCompanion.insert(
      id: id,
      petId: draft.petId,
      type: draft.type,
      // 遛狗以开始时间作为发生时间。
      occurredAt: (startedAt ?? draft.occurredAt).toUtc(),
      planId: Value(draft.planId),
      amount: Value(draft.amount),
      unit: Value(draft.unit),
      startedAt: Value(startedAt),
      endedAt: Value(endedAt),
      durationSec: Value(
        startedAt == null || endedAt == null
            ? null
            : endedAt.difference(startedAt).inSeconds,
      ),
      distanceM: Value(draft.distanceM),
      details: Value((draft.details ?? _emptyDetails(draft.type)).toJson()),
      label: Value(_trimmedOrNull(draft.label)),
      note: Value(draft.note.trim()),
      createdAt: createdAt,
      updatedAt: _clock().toUtc(),
    );
  }

  void _validate(EntryDraft draft) {
    final type = draft.type;
    final details = draft.details;
    if (details != null && !details.isFor(type)) {
      throw ArgumentError(
        '${details.runtimeType} does not belong to ${type.code}',
      );
    }

    _checkAmount(draft.amount, 'amount');
    if (type == EntryType.weight && (draft.amount ?? 0) <= 0) {
      throw ArgumentError('A weight entry needs a positive amount in kg');
    }

    final allowedUnits = switch (type) {
      EntryType.meal => PortionUnit.food,
      EntryType.medication => PortionUnit.medication,
      _ => const <PortionUnit>[],
    };
    final unit = draft.unit;
    if (unit != null && !allowedUnits.contains(unit)) {
      throw ArgumentError('${unit.code} is not a unit for ${type.code}');
    }
    if (allowedUnits.isNotEmpty && (draft.amount == null) != (unit == null)) {
      throw ArgumentError('${type.code} needs both an amount and a unit');
    }

    if (type == EntryType.custom && _trimmedOrNull(draft.label) == null) {
      throw ArgumentError('A custom entry needs a label');
    }

    if (type == EntryType.walk) {
      final startedAt = draft.startedAt;
      final endedAt = draft.endedAt;
      if (startedAt == null || endedAt == null) {
        throw ArgumentError('Use startWalk for a walk that is still going');
      }
      if (endedAt.isBefore(startedAt)) {
        throw ArgumentError('A walk cannot end before it starts');
      }
      _checkAmount(draft.distanceM, 'distanceM');
    } else if (draft.startedAt != null ||
        draft.endedAt != null ||
        draft.distanceM != null) {
      throw ArgumentError('Only walks have start, end and distance');
    }
  }

  static void _checkAmount(double? value, String name) {
    if (value != null && (!value.isFinite || value < 0)) {
      throw ArgumentError.value(value, name, 'Must be a non-negative number');
    }
  }

  static EntryDetails _emptyDetails(EntryType type) =>
      EntryDetails.fromJson(type, const {});

  static String? _trimmedOrNull(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }

  static List<Entry> _toEntries(List<EntryRow> rows) =>
      rows.map(_toEntry).toList(growable: false);

  static Entry _toEntry(EntryRow row) => Entry(
    id: row.id,
    petId: row.petId,
    type: row.type,
    occurredAt: row.occurredAt.toLocal(),
    planId: row.planId,
    amount: row.amount,
    unit: row.unit,
    startedAt: row.startedAt?.toLocal(),
    endedAt: row.endedAt?.toLocal(),
    durationSec: row.durationSec,
    distanceM: row.distanceM,
    details: EntryDetails.fromJson(row.type, row.details),
    label: row.label,
    note: row.note,
    createdAt: row.createdAt.toLocal(),
    updatedAt: row.updatedAt.toLocal(),
  );
}
