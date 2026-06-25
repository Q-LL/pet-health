import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart' as db;
import '../../../core/database/database_provider.dart';
import '../../care/domain/care_activity_spec.dart';
import '../../care/domain/care_models.dart';
import '../../records/domain/health_record.dart';
import '../../records/domain/health_record_spec.dart';
import '../domain/reminder_filter.dart';
import '../domain/reminder_models.dart';

final reminderRepositoryProvider = Provider<ReminderRepository>((ref) {
  return ReminderRepository(ref.watch(appDatabaseProvider));
});

/// 按筛选条件实时返回提醒列表。
final filteredRemindersProvider = StreamProvider.autoDispose
    .family<List<Reminder>, ReminderFilter>((ref, filter) {
      return ref
          .watch(reminderRepositoryProvider)
          .watchForPet(
            filter.petId,
            sourceType: filter.sourceType,
            enabled: filter.enabled,
            from: filter.from,
            to: filter.to,
            limit: filter.limit,
            offset: filter.offset,
          );
    });

/// 实时返回今日提醒（当天 00:00 ~ 次日 00:00 的启用提醒）。
final todayRemindersProvider = StreamProvider.autoDispose
    .family<List<Reminder>, String>((ref, petId) {
      return ref.watch(reminderRepositoryProvider).watchTodayReminders(petId);
    });

class ReminderRepository {
  ReminderRepository(this._database) : _uuid = const Uuid();

  final db.AppDatabase _database;
  final Uuid _uuid;

  // ---------------------------------------------------------------------------
  // 读取
  // ---------------------------------------------------------------------------

  Stream<List<Reminder>> watchForPet(
    String petId, {
    String? sourceType,
    bool? enabled,
    DateTime? from,
    DateTime? to,
    int? limit,
    int offset = 0,
  }) {
    _validateQuery(
      sourceType: sourceType,
      from: from,
      to: to,
      limit: limit,
      offset: offset,
    );
    final query = _database.select(_database.reminders)
      ..where((reminder) {
        var expression = reminder.petId.equals(petId);
        if (sourceType != null) {
          expression &= reminder.sourceType.equals(sourceType);
        }
        if (enabled != null) expression &= reminder.enabled.equals(enabled);
        if (from != null) {
          expression &= reminder.scheduledAt.isBiggerOrEqualValue(from.toUtc());
        }
        if (to != null) {
          expression &= reminder.scheduledAt.isSmallerThanValue(to.toUtc());
        }
        return expression;
      })
      ..orderBy([
        (r) => OrderingTerm.asc(r.scheduledAt),
        (r) => OrderingTerm.desc(r.updatedAt),
      ]);
    if (limit != null) query.limit(limit, offset: offset);
    return query.watch().map(
      (rows) => rows.map(_reminderFromRow).toList(growable: false),
    );
  }

  Future<List<Reminder>> findForPet(
    String petId, {
    String? sourceType,
    bool? enabled,
    DateTime? from,
    DateTime? to,
    int? limit,
    int offset = 0,
  }) {
    return watchForPet(
      petId,
      sourceType: sourceType,
      enabled: enabled,
      from: from,
      to: to,
      limit: limit,
      offset: offset,
    ).first;
  }

  Future<Reminder?> getById(String id) async {
    final row = await (_database.select(
      _database.reminders,
    )..where((reminder) => reminder.id.equals(id))).getSingleOrNull();
    return row == null ? null : _reminderFromRow(row);
  }

  Future<int> count(String petId, {String? sourceType, bool? enabled}) {
    _validateQuery(sourceType: sourceType, limit: null, offset: 0);
    final query = _database.selectOnly(_database.reminders)
      ..addColumns([_database.reminders.id.count()])
      ..where(_database.reminders.petId.equals(petId));
    if (sourceType != null) {
      query.where(_database.reminders.sourceType.equals(sourceType));
    }
    if (enabled != null) {
      query.where(_database.reminders.enabled.equals(enabled));
    }
    return query
        .map((row) => row.read(_database.reminders.id.count()) ?? 0)
        .getSingle();
  }

  /// 实时返回今日提醒：当天 `[00:00, 次日 00:00)` 的启用且未暂停提醒。
  Stream<List<Reminder>> watchTodayReminders(String petId) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final tomorrowStart = todayStart.add(const Duration(days: 1));
    return watchForPet(
      petId,
      enabled: true,
      from: todayStart.toUtc(),
      to: tomorrowStart.toUtc(),
    ).map((reminders) => reminders.where((r) => !r.paused).toList());
  }

  // ---------------------------------------------------------------------------
  // 写入
  // ---------------------------------------------------------------------------

  Future<Reminder> create(ReminderDraft draft) async {
    _validateDraft(draft);
    final now = DateTime.now().toUtc();
    final id = _uuid.v4();
    await _database
        .into(_database.reminders)
        .insert(
          db.RemindersCompanion.insert(
            id: id,
            petId: draft.petId,
            sourceType: draft.sourceType,
            sourceId: Value(draft.sourceId),
            title: draft.title,
            scheduledAt: draft.scheduledAt.toUtc(),
            repeatRule: Value(draft.repeatRule),
            notificationId: Value(draft.notificationId),
            completionMode: Value(draft.completionMode),
            completionTarget: Value(draft.completionTarget),
            recordType: Value(_trimmedOrNull(draft.recordType)),
            recordTitle: Value(_trimmedOrNull(draft.recordTitle)),
            recordNumericValue: Value(draft.recordNumericValue),
            recordUnit: Value(_trimmedOrNull(draft.recordUnit)),
            recordNote: Value(draft.recordNote.trim()),
            recordDetailsJson: Value(_encodeDetails(draft.recordDetails)),
            careType: Value(_trimmedOrNull(draft.careType)),
            carePlace: Value(draft.carePlace.trim()),
            careNote: Value(draft.careNote.trim()),
            careDetailsJson: Value(_encodeDetails(draft.careDetails)),
            enabled: Value(draft.enabled),
            paused: Value(draft.paused),
            createdAt: now,
            updatedAt: now,
          ),
        );
    return (await getById(id))!;
  }

  Future<Reminder> update(String id, ReminderDraft draft) async {
    if (await getById(id) == null) {
      throw StateError('提醒不存在：$id');
    }
    _validateDraft(draft);
    final now = DateTime.now().toUtc();
    await (_database.update(
      _database.reminders,
    )..where((reminder) => reminder.id.equals(id))).write(
      db.RemindersCompanion(
        sourceType: Value(draft.sourceType),
        sourceId: Value(draft.sourceId),
        title: Value(draft.title),
        scheduledAt: Value(draft.scheduledAt.toUtc()),
        repeatRule: Value(draft.repeatRule),
        notificationId: Value(draft.notificationId),
        completionMode: Value(draft.completionMode),
        completionTarget: Value(draft.completionTarget),
        recordType: Value(_trimmedOrNull(draft.recordType)),
        recordTitle: Value(_trimmedOrNull(draft.recordTitle)),
        recordNumericValue: Value(draft.recordNumericValue),
        recordUnit: Value(_trimmedOrNull(draft.recordUnit)),
        recordNote: Value(draft.recordNote.trim()),
        recordDetailsJson: Value(_encodeDetails(draft.recordDetails)),
        careType: Value(_trimmedOrNull(draft.careType)),
        carePlace: Value(draft.carePlace.trim()),
        careNote: Value(draft.careNote.trim()),
        careDetailsJson: Value(_encodeDetails(draft.careDetails)),
        enabled: Value(draft.enabled),
        paused: Value(draft.paused),
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
      _database.reminders,
    )..where((reminder) => reminder.id.equals(id))).go();
    return deleted > 0;
  }

  // ---------------------------------------------------------------------------
  // 日志
  // ---------------------------------------------------------------------------

  Future<ReminderLog> logAction(
    String reminderId,
    String action, {
    String result = '',
  }) async {
    if (!reminderLogActions.contains(action)) {
      throw FormatException('不支持的提醒日志动作：$action');
    }
    final reminder = await getById(reminderId);
    if (reminder == null) throw StateError('提醒不存在：$reminderId');

    final now = DateTime.now().toUtc();
    final id = _uuid.v4();
    await _database
        .into(_database.reminderLogs)
        .insert(
          db.ReminderLogsCompanion.insert(
            id: id,
            reminderId: reminderId,
            occurredAt: now,
            action: action,
            result: Value(result),
            createdAt: now,
          ),
        );
    return (await _getLogById(id))!;
  }

  Stream<List<ReminderLog>> watchLogs(String reminderId, {int? limit}) {
    final query = _database.select(_database.reminderLogs)
      ..where((log) => log.reminderId.equals(reminderId))
      ..orderBy([(log) => OrderingTerm.desc(log.occurredAt)]);
    if (limit != null) query.limit(limit);
    return query.watch().map(
      (rows) => rows.map(_logFromRow).toList(growable: false),
    );
  }

  Future<List<ReminderLog>> findLogs(String reminderId, {int? limit}) {
    return watchLogs(reminderId, limit: limit).first;
  }

  // ---------------------------------------------------------------------------
  // 私有辅助
  // ---------------------------------------------------------------------------

  Future<bool> _setBool(String id, {bool? enabled, bool? paused}) async {
    final existing = await getById(id);
    if (existing == null) return false;
    await (_database.update(
      _database.reminders,
    )..where((reminder) => reminder.id.equals(id))).write(
      db.RemindersCompanion(
        enabled: enabled != null ? Value(enabled) : const Value.absent(),
        paused: paused != null ? Value(paused) : const Value.absent(),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
    return true;
  }

  Future<ReminderLog?> _getLogById(String id) async {
    final row = await (_database.select(
      _database.reminderLogs,
    )..where((log) => log.id.equals(id))).getSingleOrNull();
    return row == null ? null : _logFromRow(row);
  }

  void _validateDraft(ReminderDraft draft) {
    if (!reminderSourceTypes.contains(draft.sourceType)) {
      throw FormatException('不支持的提醒来源类型：${draft.sourceType}');
    }
    if (draft.title.isEmpty) {
      throw const FormatException('提醒标题不能为空');
    }
    if (draft.repeatRule != null &&
        ReminderRepeatRule.parse(draft.repeatRule) == null) {
      throw FormatException('不支持的重复规则：${draft.repeatRule}');
    }
    if (!reminderCompletionModes.contains(draft.completionMode)) {
      throw FormatException('不支持的提醒完成方式：${draft.completionMode}');
    }
    if (!reminderCompletionTargets.contains(draft.completionTarget)) {
      throw FormatException('不支持的提醒绑定目标：${draft.completionTarget}');
    }
    if (draft.completionMode != 'none') {
      if (draft.completionTarget == 'health') {
        _validateHealthTemplate(draft);
      } else {
        _validateCareTemplate(draft);
      }
    }
    for (final entry in draft.recordDetails.entries) {
      if (entry.key.trim().isEmpty) {
        throw const FormatException('提醒记录模板字段名不能为空');
      }
    }
  }

  void _validateQuery({
    String? sourceType,
    DateTime? from,
    DateTime? to,
    int? limit,
    required int offset,
  }) {
    if (sourceType != null && !reminderSourceTypes.contains(sourceType)) {
      throw FormatException('不支持的提醒来源类型：$sourceType');
    }
    if (from != null && to != null && !from.isBefore(to)) {
      throw const FormatException('查询开始时间必须早于结束时间');
    }
    if (limit != null && limit <= 0) {
      throw const FormatException('limit 必须大于 0');
    }
    if (offset < 0 || (offset > 0 && limit == null)) {
      throw const FormatException('offset 必须非负且只能与 limit 一起使用');
    }
  }

  Reminder _reminderFromRow(db.Reminder row) {
    return Reminder(
      id: row.id,
      petId: row.petId,
      sourceType: row.sourceType,
      sourceId: row.sourceId,
      title: row.title,
      scheduledAt: row.scheduledAt.toUtc(),
      repeatRule: row.repeatRule,
      notificationId: row.notificationId,
      completionMode: row.completionMode,
      completionTarget: row.completionTarget,
      recordType: row.recordType,
      recordTitle: row.recordTitle,
      recordNumericValue: row.recordNumericValue,
      recordUnit: row.recordUnit,
      recordNote: row.recordNote,
      recordDetails: _decodeDetails(row.recordDetailsJson),
      careType: row.careType,
      carePlace: row.carePlace,
      careNote: row.careNote,
      careDetails: _decodeDetails(row.careDetailsJson),
      enabled: row.enabled,
      paused: row.paused,
      createdAt: row.createdAt.toUtc(),
      updatedAt: row.updatedAt.toUtc(),
    );
  }

  ReminderLog _logFromRow(db.ReminderLog row) {
    return ReminderLog(
      id: row.id,
      reminderId: row.reminderId,
      occurredAt: row.occurredAt.toUtc(),
      action: row.action,
      result: row.result,
      createdAt: row.createdAt.toUtc(),
    );
  }
}

void _validateHealthTemplate(ReminderDraft draft) {
  final recordType = draft.recordType?.trim();
  if (recordType == null || recordType.isEmpty) {
    throw const FormatException('绑定健康记录的提醒必须选择记录类型');
  }
  if (!healthRecordTypes.contains(recordType)) {
    throw FormatException('不支持的绑定健康记录类型：$recordType');
  }
  final spec = healthRecordSpecFor(recordType);
  if (draft.completionMode == 'auto_record' &&
      spec.hasNumericValue &&
      draft.recordNumericValue == null) {
    throw FormatException('自动生成${spec.label}记录必须预填写${spec.numericLabel}');
  }
  if (draft.completionMode == 'auto_record') {
    for (final field in spec.fields.where((field) => field.required)) {
      final value = draft.recordDetails[field.key]?.trim();
      if (value == null || value.isEmpty) {
        throw FormatException('自动生成${spec.label}记录必须预填写${field.label}');
      }
    }
  }
}

void _validateCareTemplate(ReminderDraft draft) {
  final careType = draft.careType?.trim();
  if (careType == null || careType.isEmpty) {
    throw const FormatException('绑定护理记录的提醒必须选择护理类型');
  }
  if (!careActivityTypes.contains(careType) || careType == 'walk') {
    throw FormatException('不支持的绑定护理记录类型：$careType');
  }
  if (draft.completionMode == 'auto_record') {
    final spec = careActivitySpecFor(careType);
    for (final field in spec.fields.where((field) => field.required)) {
      final value = draft.careDetails[field.key]?.trim();
      if (value == null || value.isEmpty) {
        throw FormatException('自动生成${spec.label}记录必须预填写${field.label}');
      }
    }
  }
}

String? _trimmedOrNull(String? value) {
  final trimmed = value?.trim();
  return trimmed == null || trimmed.isEmpty ? null : trimmed;
}

String _encodeDetails(Map<String, String> details) {
  final cleaned = <String, String>{};
  for (final entry in details.entries) {
    final key = entry.key.trim();
    final value = entry.value.trim();
    if (key.isNotEmpty && value.isNotEmpty) cleaned[key] = value;
  }
  return jsonEncode(cleaned);
}

Map<String, String> _decodeDetails(String raw) {
  if (raw.trim().isEmpty) return const {};
  try {
    final decoded = jsonDecode(raw);
    if (decoded is! Map) return const {};
    return decoded.map(
      (key, value) => MapEntry(key.toString(), value.toString()),
    );
  } on FormatException {
    return const {};
  }
}
