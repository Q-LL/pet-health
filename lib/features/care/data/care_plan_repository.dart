import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart' as db;
import '../../../core/database/database_provider.dart';
import '../domain/care_plan_models.dart';

final carePlanRepositoryProvider = Provider<CarePlanRepository>((ref) {
  return CarePlanRepository(ref.watch(appDatabaseProvider));
});

/// 按筛选条件实时返回护理计划列表。
final carePlansForPetProvider = StreamProvider.autoDispose
    .family<List<CarePlan>, String>((ref, petId) {
      return ref.watch(carePlanRepositoryProvider).watchForPet(petId);
    });

/// 按 candidateId 查找单个已启用的护理计划。
final enabledCarePlanProvider = FutureProvider.autoDispose
    .family<CarePlan?, (String petId, String candidateId)>((ref, key) {
      return ref
          .watch(carePlanRepositoryProvider)
          .findByCandidate(key.$1, key.$2);
    });

class CarePlanRepository {
  CarePlanRepository(this._database) : _uuid = const Uuid();

  final db.AppDatabase _database;
  final Uuid _uuid;

  // ---------------------------------------------------------------------------
  // 读取
  // ---------------------------------------------------------------------------

  Stream<List<CarePlan>> watchForPet(String petId, {bool? enabled}) {
    final query = _database.select(_database.carePlans)
      ..where((plan) {
        var expression = plan.petId.equals(petId);
        if (enabled != null) expression &= plan.enabled.equals(enabled);
        return expression;
      })
      ..orderBy([
        (plan) => OrderingTerm.desc(plan.enabled),
        (plan) => OrderingTerm.desc(plan.createdAt),
      ]);
    return query.watch().map(
      (rows) => rows.map(_planFromRow).toList(growable: false),
    );
  }

  Future<List<CarePlan>> findForPet(String petId, {bool? enabled}) {
    return watchForPet(petId, enabled: enabled).first;
  }

  Future<CarePlan?> getById(String id) async {
    final row = await (_database.select(
      _database.carePlans,
    )..where((plan) => plan.id.equals(id))).getSingleOrNull();
    return row == null ? null : _planFromRow(row);
  }

  Future<CarePlan?> findByCandidate(String petId, String candidateId) async {
    final row = await _findRowByCandidate(
      petId,
      candidateId,
      enabledOnly: true,
    );
    return row == null ? null : _planFromRow(row);
  }

  Future<db.CarePlan?> _findRowByCandidate(
    String petId,
    String candidateId, {
    bool enabledOnly = false,
  }) async {
    final row =
        await (_database.select(_database.carePlans)
              ..where((plan) {
                var expression =
                    plan.petId.equals(petId) &
                    plan.candidateId.equals(candidateId);
                if (enabledOnly) {
                  expression &= plan.enabled.equals(true);
                }
                return expression;
              })
              ..limit(1))
            .getSingleOrNull();
    return row;
  }

  // ---------------------------------------------------------------------------
  // 写入
  // ---------------------------------------------------------------------------

  Future<CarePlan> create(CarePlanDraft draft) async {
    _validateDraft(draft);
    final existing = await _findRowByCandidate(draft.petId, draft.candidateId);
    if (existing != null) {
      return update(existing.id, draft);
    }

    final now = DateTime.now().toUtc();
    final id = _uuid.v4();
    await _database
        .into(_database.carePlans)
        .insert(
          db.CarePlansCompanion.insert(
            id: id,
            petId: draft.petId,
            candidateId: draft.candidateId,
            careType: draft.careType,
            title: draft.title,
            scheduleRule: draft.scheduleRule,
            nextDueAt: Value(draft.nextDueAt?.toUtc()),
            enabled: Value(draft.enabled),
            paused: Value(draft.paused),
            reasonSnapshot: Value(draft.reasonSnapshot),
            ruleId: Value(draft.ruleId),
            ruleVersion: Value(draft.ruleVersion),
            createdAt: now,
            updatedAt: now,
          ),
        );
    return (await getById(id))!;
  }

  Future<CarePlan> update(String id, CarePlanDraft draft) async {
    final existing = await getById(id);
    if (existing == null) {
      throw StateError('护理计划不存在：$id');
    }
    _validateDraft(draft);
    final now = DateTime.now().toUtc();
    await (_database.update(
      _database.carePlans,
    )..where((plan) => plan.id.equals(id))).write(
      db.CarePlansCompanion(
        candidateId: Value(draft.candidateId),
        careType: Value(draft.careType),
        title: Value(draft.title),
        scheduleRule: Value(draft.scheduleRule),
        nextDueAt: Value(draft.nextDueAt?.toUtc()),
        enabled: Value(draft.enabled),
        paused: Value(draft.paused),
        reasonSnapshot: Value(draft.reasonSnapshot),
        ruleId: Value(draft.ruleId),
        ruleVersion: Value(draft.ruleVersion),
        updatedAt: Value(now),
      ),
    );
    return (await getById(id))!;
  }

  Future<bool> enable(String id) async {
    return _setBool(id, enabled: true, paused: false);
  }

  Future<bool> pause(String id) async {
    return _setBool(id, paused: true);
  }

  Future<bool> resume(String id) async {
    return _setBool(id, paused: false);
  }

  Future<bool> disable(String id) async {
    return _setBool(id, enabled: false, paused: false);
  }

  Future<bool> delete(String id) async {
    final deleted = await (_database.delete(
      _database.carePlans,
    )..where((plan) => plan.id.equals(id))).go();
    return deleted > 0;
  }

  /// 忽略某个候选：写入一条 `enabled=false` 的记录（用于记忆"不再建议"）。
  ///
  /// 如果该 petId+candidateId 已有记录，将其关闭；否则新建一条占位记录。
  Future<CarePlan> dismiss(String petId, String candidateId) async {
    final existingRow = await _findRowByCandidate(petId, candidateId);
    final existing = existingRow == null ? null : _planFromRow(existingRow);
    if (existing != null) {
      await disable(existing.id);
      final disabled = await getById(existing.id);
      if (disabled != null && disabled.reasonSnapshot == 'dismissed') {
        return disabled;
      }
      await (_database.update(
        _database.carePlans,
      )..where((plan) => plan.id.equals(existing.id))).write(
        db.CarePlansCompanion(
          reasonSnapshot: const Value('dismissed'),
          updatedAt: Value(DateTime.now().toUtc()),
        ),
      );
      return (await getById(existing.id))!;
    }

    // 创建占位 dismiss 记录
    final now = DateTime.now().toUtc();
    final id = _uuid.v4();
    await _database
        .into(_database.carePlans)
        .insert(
          db.CarePlansCompanion.insert(
            id: id,
            petId: petId,
            candidateId: candidateId,
            careType: '',
            title: '',
            scheduleRule: '',
            enabled: const Value(false),
            reasonSnapshot: const Value('dismissed'),
            createdAt: now,
            updatedAt: now,
          ),
        );
    return (await getById(id))!;
  }

  // ---------------------------------------------------------------------------
  // 日志
  // ---------------------------------------------------------------------------

  Future<CarePlanLog> logCompletion(String planId, {String note = ''}) {
    return _writeLog(planId, 'completed', note: note);
  }

  Future<CarePlanLog> logSkip(String planId, {String note = ''}) {
    return _writeLog(planId, 'skipped', note: note);
  }

  Future<CarePlanLog> _writeLog(
    String planId,
    String action, {
    String note = '',
  }) async {
    final plan = await getById(planId);
    if (plan == null) throw StateError('护理计划不存在：$planId');

    final now = DateTime.now().toUtc();
    final id = _uuid.v4();
    await _database
        .into(_database.carePlanLogs)
        .insert(
          db.CarePlanLogsCompanion.insert(
            id: id,
            planId: planId,
            petId: plan.petId,
            occurredAt: now,
            action: action,
            note: Value(note),
            createdAt: now,
          ),
        );
    return (await _getLogById(id))!;
  }

  Stream<List<CarePlanLog>> watchLogs(String planId, {int? limit}) {
    final query = _database.select(_database.carePlanLogs)
      ..where((log) => log.planId.equals(planId))
      ..orderBy([(log) => OrderingTerm.desc(log.occurredAt)]);
    if (limit != null) query.limit(limit);
    return query.watch().map(
      (rows) => rows.map(_logFromRow).toList(growable: false),
    );
  }

  Future<List<CarePlanLog>> findLogs(String planId, {int? limit}) {
    return watchLogs(planId, limit: limit).first;
  }

  // ---------------------------------------------------------------------------
  // 到期计算
  // ---------------------------------------------------------------------------

  /// 根据最近一次完成日志重新计算下次到期时间。
  Future<void> recalculateNextDue(String planId) async {
    final plan = await getById(planId);
    if (plan == null) throw StateError('护理计划不存在：$planId');

    final lastLog =
        await (_database.select(_database.carePlanLogs)
              ..where(
                (log) =>
                    log.planId.equals(planId) & log.action.equals('completed'),
              )
              ..orderBy([(log) => OrderingTerm.desc(log.occurredAt)])
              ..limit(1))
            .getSingleOrNull();

    if (lastLog == null) return;

    final rule = _parseScheduleRule(plan.scheduleRule);
    if (rule == null) return;

    final nextDue = rule.nextOccurrence(lastLog.occurredAt);
    await (_database.update(
      _database.carePlans,
    )..where((plan) => plan.id.equals(planId))).write(
      db.CarePlansCompanion(
        nextDueAt: Value(nextDue),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 私有辅助
  // ---------------------------------------------------------------------------

  Future<bool> _setBool(String id, {bool? enabled, bool? paused}) async {
    final existing = await getById(id);
    if (existing == null) return false;
    await (_database.update(
      _database.carePlans,
    )..where((plan) => plan.id.equals(id))).write(
      db.CarePlansCompanion(
        enabled: enabled != null ? Value(enabled) : const Value.absent(),
        paused: paused != null ? Value(paused) : const Value.absent(),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
    return true;
  }

  Future<CarePlanLog?> _getLogById(String id) async {
    final row = await (_database.select(
      _database.carePlanLogs,
    )..where((log) => log.id.equals(id))).getSingleOrNull();
    return row == null ? null : _logFromRow(row);
  }

  void _validateDraft(CarePlanDraft draft) {
    if (draft.petId.trim().isEmpty) {
      throw const FormatException('狗狗 ID 不能为空');
    }
    if (draft.candidateId.trim().isEmpty) {
      throw const FormatException('护理计划候选 ID 不能为空');
    }
    if (draft.title.trim().isEmpty) {
      throw const FormatException('护理计划标题不能为空');
    }
    if (draft.scheduleRule.trim().isEmpty) {
      throw const FormatException('护理计划调度规则不能为空');
    }
  }

  CarePlan _planFromRow(db.CarePlan row) {
    return CarePlan(
      id: row.id,
      petId: row.petId,
      candidateId: row.candidateId,
      careType: row.careType,
      title: row.title,
      scheduleRule: row.scheduleRule,
      nextDueAt: row.nextDueAt?.toUtc(),
      enabled: row.enabled,
      paused: row.paused,
      reasonSnapshot: row.reasonSnapshot,
      ruleId: row.ruleId,
      ruleVersion: row.ruleVersion,
      createdAt: row.createdAt.toUtc(),
      updatedAt: row.updatedAt.toUtc(),
    );
  }

  CarePlanLog _logFromRow(db.CarePlanLog row) {
    return CarePlanLog(
      id: row.id,
      planId: row.planId,
      petId: row.petId,
      occurredAt: row.occurredAt.toUtc(),
      action: row.action,
      note: row.note,
      createdAt: row.createdAt.toUtc(),
    );
  }

  _ScheduleRule? _parseScheduleRule(String rule) {
    final normalized = rule.trim();
    if (normalized == '每天') return const _ScheduleRule(intervalDays: 1);

    final intervalMatch = RegExp(r'^每\s*(\d+)\s*(周|天)').firstMatch(normalized);
    if (intervalMatch != null) {
      final n = int.tryParse(intervalMatch.group(1)!) ?? 1;
      final unit = intervalMatch.group(2);
      return _ScheduleRule(intervalDays: unit == '周' ? n * 7 : n);
    }

    final weeklyTimesMatch = RegExp(r'^每周\s*(\d+)\s*次$').firstMatch(normalized);
    if (weeklyTimesMatch != null) {
      final times = int.tryParse(weeklyTimesMatch.group(1)!) ?? 1;
      if (times <= 0) return null;
      return _ScheduleRule(intervalDays: (7 / times).ceil());
    }

    if (normalized == '每周一次' ||
        normalized == '每周 1 次' ||
        normalized == '每周观察') {
      return const _ScheduleRule(intervalDays: 7);
    }
    return null;
  }
}

/// 内部调度规则辅助，用于到期计算。
class _ScheduleRule {
  const _ScheduleRule({required this.intervalDays});
  final int intervalDays;

  DateTime nextOccurrence(DateTime from) {
    return from.add(Duration(days: intervalDays));
  }
}
