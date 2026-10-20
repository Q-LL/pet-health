import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/codes/coded_enum.dart';
import '../../../core/db/database_provider.dart';
import '../../../core/db/pet_health_database.dart';
import '../../entries/domain/entry_codes.dart';
import '../domain/plan.dart';
import '../domain/plan_codes.dart';
import '../domain/plan_schedule.dart';
import 'plan_columns.dart';

final plansRepositoryProvider = Provider<PlansRepository>((ref) {
  return PlansRepository(
    ref.watch(petHealthDatabaseProvider),
    clock: ref.watch(clockProvider),
  );
});

/// 计划的读写，以及按记录算出每个计划此刻的状态。
class PlansRepository {
  PlansRepository(this._db, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final PetHealthDatabase _db;
  final DateTime Function() _clock;
  static const _uuid = Uuid();

  Future<Plan?> getById(String id) async {
    final row = await (_db.select(
      _db.plans,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return row == null ? null : _toPlan(row);
  }

  Future<Plan> create(PlanDraft draft) async {
    _validate(draft);
    final id = _uuid.v4();
    final now = _clock().toUtc();
    await _db
        .into(_db.plans)
        .insert(
          _companion(draft).copyWith(
            id: Value(id),
            petId: Value(draft.petId),
            source: const Value(PlanSource.user),
            createdAt: Value(now),
          ),
        );
    return (await getById(id))!;
  }

  /// 修改计划。改过的自动计划视为用户自己的，重新套用犬种默认值时不会被替换。
  Future<Plan> update(String id, PlanDraft draft) async {
    final existing = await getById(id);
    if (existing == null) throw ArgumentError.value(id, 'id', 'No such plan');
    if (existing.petId != draft.petId) {
      throw ArgumentError('A plan cannot move to another pet');
    }
    _validate(draft);
    await (_db.update(_db.plans)..where((t) => t.id.equals(id))).write(
      _companion(draft).copyWith(
        source: const Value(PlanSource.user),
        // 排期变了，之前的稍后提醒不再有意义。
        snoozedUntil: const Value(null),
      ),
    );
    return (await getById(id))!;
  }

  Future<bool> delete(String id) async {
    final deleted = await (_db.delete(
      _db.plans,
    )..where((t) => t.id.equals(id))).go();
    return deleted > 0;
  }

  Future<void> setPaused(String id, {required bool paused}) =>
      _write(id, PlansCompanion(paused: Value(paused)));

  /// 稍后提醒：到 [until] 之前不再提醒。做过一次后自动作废。
  Future<void> snooze(String id, DateTime until) {
    if (!until.isAfter(_clock())) {
      throw ArgumentError.value(until, 'until', 'Must be in the future');
    }
    return _write(id, PlansCompanion(snoozedUntil: Value(until.toUtc())));
  }

  /// 一只狗全部计划此刻的状态，排序见 [statusesFor]。
  ///
  /// 计划或记录变化时重新计算。时间流逝本身不会触发更新（比如过了零点），
  /// 页面需要在回到前台或跨天时重新订阅。
  Stream<List<PlanStatus>> watchStatuses(String petId) {
    final changes = _db.tableUpdates(
      TableUpdateQuery.onAllTables([_db.plans, _db.entries]),
    );
    late final StreamController<List<PlanStatus>> controller;
    StreamSubscription<void>? subscription;
    var pending = Future<void>.value();

    void refresh() {
      pending = pending.then((_) async {
        final statuses = await statusesFor(petId);
        if (!controller.isClosed) controller.add(statuses);
      });
    }

    controller = StreamController<List<PlanStatus>>(
      onListen: () {
        refresh();
        subscription = changes.listen((_) => refresh());
      },
      onCancel: () => subscription?.cancel(),
    );
    return controller.stream;
  }

  /// 一只狗全部计划此刻的状态。
  ///
  /// 排序：该做了 → 稍后提醒 → 即将到来（按日期）→ 未开始 → 已完成；
  /// 暂停的计划排在最后。
  Future<List<PlanStatus>> statusesFor(String petId) async {
    final now = _clock();
    final rows = await (_db.select(
      _db.plans,
    )..where((t) => t.petId.equals(petId))).get();
    if (rows.isEmpty) return const [];

    final lastByType = await _lastDoneByTypeAndKind(petId, now);
    final lastByPlan = await _lastDoneByPlan(petId, now);

    final statuses = [
      for (final row in rows)
        _status(
          _toPlan(row),
          now: now,
          lastDoneAt: row.schedule == PlanScheduleKind.once
              ? lastByPlan[row.id]
              : _latest(lastByType, row.entryType, row.entryKind),
        ),
    ];
    statuses.sort(_compare);
    return statuses;
  }

  static PlanStatus _status(
    Plan plan, {
    required DateTime now,
    DateTime? lastDoneAt,
  }) => PlanStatus(
    plan: plan,
    lastDoneAt: lastDoneAt,
    due: evaluatePlan(
      plan.schedule,
      now: now,
      lastDoneAt: lastDoneAt,
      snoozedUntil: plan.snoozedUntil,
    ),
  );

  static const _stateOrder = [
    PlanState.due,
    PlanState.snoozed,
    PlanState.upcoming,
    PlanState.notStarted,
    PlanState.completed,
  ];

  static int _compare(PlanStatus a, PlanStatus b) {
    if (a.plan.paused != b.plan.paused) return a.plan.paused ? 1 : -1;
    final byState = _stateOrder
        .indexOf(a.due.state)
        .compareTo(_stateOrder.indexOf(b.due.state));
    if (byState != 0) return byState;
    final aDay = a.due.dueDay;
    final bDay = b.due.dueDay;
    if (aDay != null && bDay != null && aDay != bDay) {
      return aDay.compareTo(bDay);
    }
    return a.plan.createdAt.compareTo(b.plan.createdAt);
  }

  /// 每种类型（和细分项）最近一次的时间，只算不晚于 [now] 的记录。
  ///
  /// 细分项来自 details 里的 `kind`（其他护理、检查），或驱虫的 `coverage`
  /// 列表中的每一项：一次复方驱虫同时算作它覆盖的每一类。
  Future<Map<(EntryType, String?), DateTime>> _lastDoneByTypeAndKind(
    String petId,
    DateTime now,
  ) async {
    final rows = await _db
        .customSelect(
          "SELECT type, json_extract(details, '\$.kind') AS kind, "
          'MAX(occurred_at) AS last FROM entries '
          'WHERE pet_id = ?1 AND occurred_at <= ?2 GROUP BY type, kind '
          'UNION ALL '
          'SELECT e.type, c.value AS kind, MAX(e.occurred_at) AS last '
          "FROM entries e, json_each(e.details, '\$.coverage') c "
          'WHERE e.pet_id = ?1 AND e.occurred_at <= ?2 GROUP BY e.type, c.value',
          variables: [
            Variable.withString(petId),
            Variable.withDateTime(now.toUtc()),
          ],
          readsFrom: {_db.entries},
        )
        .get();
    final latest = <(EntryType, String?), DateTime>{};
    for (final row in rows) {
      final type = decodeCode(EntryType.values, row.read<String>('type'));
      if (type == null) continue;
      final key = (type, row.readNullable<String>('kind'));
      final at = row.read<DateTime>('last').toLocal();
      if (latest[key]?.isAfter(at) != true) latest[key] = at;
    }
    return latest;
  }

  /// 一次性事项只算关联到它的记录。
  Future<Map<String, DateTime>> _lastDoneByPlan(
    String petId,
    DateTime now,
  ) async {
    final rows = await _db
        .customSelect(
          'SELECT plan_id, MAX(occurred_at) AS last FROM entries '
          'WHERE pet_id = ? AND plan_id IS NOT NULL AND occurred_at <= ? '
          'GROUP BY plan_id',
          variables: [
            Variable.withString(petId),
            Variable.withDateTime(now.toUtc()),
          ],
          readsFrom: {_db.entries},
        )
        .get();
    return {
      for (final row in rows)
        row.read<String>('plan_id'): row.read<DateTime>('last').toLocal(),
    };
  }

  /// 计划没有指定 kind 时，同类型的所有记录都算。
  static DateTime? _latest(
    Map<(EntryType, String?), DateTime> lastByTypeAndKind,
    EntryType type,
    String? kind,
  ) {
    DateTime? latest;
    for (final MapEntry(key: (entryType, entryKind), value: at)
        in lastByTypeAndKind.entries) {
      if (entryType != type || (kind != null && entryKind != kind)) continue;
      if (latest == null || at.isAfter(latest)) latest = at;
    }
    return latest;
  }

  Future<void> _write(String id, PlansCompanion changes) async {
    final updated = await (_db.update(_db.plans)..where((t) => t.id.equals(id)))
        .write(changes.copyWith(updatedAt: Value(_clock().toUtc())));
    if (updated == 0) throw ArgumentError.value(id, 'id', 'No such plan');
  }

  PlansCompanion _companion(PlanDraft draft) =>
      scheduleColumns(draft.schedule).copyWith(
        entryType: Value(draft.entryType),
        entryKind: Value(draft.entryKind),
        title: Value(_trimmedOrNull(draft.title)),
        notifyMinute: Value(draft.notifyMinute),
        paused: Value(draft.paused),
        updatedAt: Value(_clock().toUtc()),
      );

  static void _validate(PlanDraft draft) {
    switch (draft.schedule) {
      case EveryNDays(:final days) when days < 1 || days > 366:
        throw ArgumentError.value(days, 'days', 'Must be 1 to 366');
      case EveryNMonths(:final months) when months < 1 || months > 24:
        throw ArgumentError.value(months, 'months', 'Must be 1 to 24');
      case OnWeekdays(:final mask) when mask < 1 || mask > Weekdays.all:
        throw ArgumentError.value(mask, 'weekdays', 'Select at least one day');
      default:
    }
    final minute = draft.notifyMinute;
    if (minute != null && (minute < 0 || minute >= 24 * 60)) {
      throw ArgumentError.value(minute, 'notifyMinute', 'Must be 0 to 1439');
    }
    if (draft.entryType == EntryType.custom &&
        _trimmedOrNull(draft.title) == null) {
      throw ArgumentError('A custom plan needs a title');
    }
    final kind = draft.entryKind;
    if (kind != null) {
      final List<CodedEnum> kinds = switch (draft.entryType) {
        EntryType.otherCare => OtherCareKind.values,
        EntryType.parasitePrevention => ParasiteCoverage.values,
        EntryType.vetTest => VetTestKind.values,
        _ => const [],
      };
      if (decodeCode(kinds, kind) == null) {
        throw ArgumentError.value(kind, 'entryKind', 'Not a kind of this type');
      }
    }
  }

  static String? _trimmedOrNull(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }

  static Plan _toPlan(PlanRow row) => Plan(
    id: row.id,
    petId: row.petId,
    entryType: row.entryType,
    entryKind: row.entryKind,
    title: row.title,
    schedule: scheduleFromRow(row),
    notifyMinute: row.notifyMinute,
    snoozedUntil: row.snoozedUntil?.toLocal(),
    notificationId: row.notificationId,
    source: row.source,
    paused: row.paused,
    createdAt: row.createdAt.toLocal(),
    updatedAt: row.updatedAt.toLocal(),
  );
}
