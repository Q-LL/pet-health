import 'package:flutter/foundation.dart';

/// 提醒来源类型。
const reminderSourceTypes = {
  'care_plan',
  'manual',
  'food',
  'water',
  'symptom',
  'bath',
  'oral',
  'combing',
  'styling',
  'nail',
  'ear',
  'eye',
  'paw',
  'environment',
  'visit',
  'medication',
  'vaccine',
  'deworming',
};

/// 完成提醒后的记录行为。
const reminderCompletionModes = {'none', 'ask_record', 'auto_record'};

const reminderCompletionTargets = {'health', 'care'};

/// 提醒执行日志动作。
const reminderLogActions = {
  'fired',
  'completed',
  'skipped',
  'snoozed',
  'failed',
};

/// 持久化的提醒，对应数据库 reminders 表行。
@immutable
class Reminder {
  const Reminder({
    required this.id,
    required this.petId,
    required this.sourceType,
    required this.title,
    required this.scheduledAt,
    required this.enabled,
    required this.createdAt,
    required this.updatedAt,
    this.sourceId,
    this.repeatRule,
    this.notificationId,
    this.completionMode = 'none',
    this.completionTarget = 'health',
    this.recordType,
    this.recordTitle,
    this.recordNumericValue,
    this.recordUnit,
    this.recordNote = '',
    this.recordDetails = const {},
    this.careType,
    this.carePlace = '',
    this.careNote = '',
    this.careDetails = const {},
    this.paused = false,
  });

  final String id;
  final String petId;
  final String sourceType;
  final String? sourceId;
  final String title;
  final DateTime scheduledAt;
  final String? repeatRule;
  final int? notificationId;
  final String completionMode;
  final String completionTarget;
  final String? recordType;
  final String? recordTitle;
  final double? recordNumericValue;
  final String? recordUnit;
  final String recordNote;
  final Map<String, String> recordDetails;
  final String? careType;
  final String carePlace;
  final String careNote;
  final Map<String, String> careDetails;
  final bool enabled;
  final bool paused;
  final DateTime createdAt;
  final DateTime updatedAt;
}

/// 创建或更新提醒的草稿。
@immutable
class ReminderDraft {
  const ReminderDraft({
    required this.petId,
    required this.sourceType,
    required this.title,
    required this.scheduledAt,
    this.sourceId,
    this.repeatRule,
    this.notificationId,
    this.completionMode = 'none',
    this.completionTarget = 'health',
    this.recordType,
    this.recordTitle,
    this.recordNumericValue,
    this.recordUnit,
    this.recordNote = '',
    this.recordDetails = const {},
    this.careType,
    this.carePlace = '',
    this.careNote = '',
    this.careDetails = const {},
    this.enabled = true,
    this.paused = false,
  });

  final String petId;
  final String sourceType;
  final String? sourceId;
  final String title;
  final DateTime scheduledAt;
  final String? repeatRule;
  final int? notificationId;
  final String completionMode;
  final String completionTarget;
  final String? recordType;
  final String? recordTitle;
  final double? recordNumericValue;
  final String? recordUnit;
  final String recordNote;
  final Map<String, String> recordDetails;
  final String? careType;
  final String carePlace;
  final String careNote;
  final Map<String, String> careDetails;
  final bool enabled;
  final bool paused;
}

/// 提醒执行日志，对应数据库 reminder_logs 表行。
@immutable
class ReminderLog {
  const ReminderLog({
    required this.id,
    required this.reminderId,
    required this.occurredAt,
    required this.action,
    this.result = '',
    required this.createdAt,
  });

  final String id;
  final String reminderId;
  final DateTime occurredAt;
  final String action;
  final String result;
  final DateTime createdAt;
}

/// 写入提醒日志的草稿。
@immutable
class ReminderLogDraft {
  const ReminderLogDraft({
    required this.reminderId,
    required this.action,
    this.occurredAt,
    this.result = '',
  });

  final String reminderId;
  final String action;
  final DateTime? occurredAt;
  final String result;
}

/// 重复规则解析辅助。
///
/// 规则格式：
/// - `daily` — 每天
/// - `weekly:N` — 每周 N 次（均匀分布）
/// - `weekly_days:1,3,5` — 每周指定星期，1 表示周一，7 表示周日
/// - `interval:Nd` — 每 N 天
/// - `interval:Nw` — 每 N 周
/// - `monthly` — 每月
@immutable
class ReminderRepeatRule {
  const ReminderRepeatRule._({required this.type, required this.value});

  final String type;
  final int value;

  /// 从字符串解析规则，返回 `null` 表示格式不合法。
  static ReminderRepeatRule? parse(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    if (raw == 'daily') {
      return const ReminderRepeatRule._(type: 'daily', value: 1);
    }
    if (raw == 'monthly') {
      return const ReminderRepeatRule._(type: 'monthly', value: 1);
    }
    if (raw.startsWith('weekly:')) {
      final n = int.tryParse(raw.substring(7));
      if (n != null && n > 0) {
        return ReminderRepeatRule._(type: 'weekly', value: n);
      }
    }
    if (raw.startsWith('weekly_days:')) {
      final days =
          raw
              .substring(12)
              .split(',')
              .map((part) => int.tryParse(part.trim()))
              .whereType<int>()
              .where((day) => day >= 1 && day <= 7)
              .toSet()
              .toList()
            ..sort();
      if (days.isNotEmpty) {
        return ReminderRepeatRule._(
          type: 'weekly_days',
          value: _encodeWeekdays(days),
        );
      }
    }
    if (raw.startsWith('interval:')) {
      final body = raw.substring(9);
      if (body.endsWith('d')) {
        final n = int.tryParse(body.substring(0, body.length - 1));
        if (n != null && n > 0) {
          return ReminderRepeatRule._(type: 'interval_d', value: n);
        }
      }
      if (body.endsWith('w')) {
        final n = int.tryParse(body.substring(0, body.length - 1));
        if (n != null && n > 0) {
          return ReminderRepeatRule._(type: 'interval_w', value: n);
        }
      }
    }
    return null;
  }

  /// 将规则格式化为存储字符串。
  String format() {
    return switch (type) {
      'daily' => 'daily',
      'monthly' => 'monthly',
      'weekly' => 'weekly:$value',
      'weekly_days' => 'weekly_days:${_decodeWeekdays(value).join(',')}',
      'interval_d' => 'interval:${value}d',
      'interval_w' => 'interval:${value}w',
      _ => 'daily',
    };
  }

  /// 计算从 [from] 起的下一次触发时间。
  DateTime nextOccurrence(DateTime from) {
    return switch (type) {
      'daily' => from.add(const Duration(days: 1)),
      'monthly' => DateTime(
        from.year,
        from.month + 1,
        from.day,
        from.hour,
        from.minute,
      ),
      'weekly' => from.add(Duration(days: (7 / value).ceil())),
      'weekly_days' => _nextWeeklyDay(from, _decodeWeekdays(value)),
      'interval_d' => from.add(Duration(days: value)),
      'interval_w' => from.add(Duration(days: value * 7)),
      _ => from.add(const Duration(days: 1)),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderRepeatRule &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          value == other.value;

  @override
  int get hashCode => Object.hash(type, value);
}

int _encodeWeekdays(List<int> days) {
  return days.fold<int>(0, (mask, day) => mask | (1 << day));
}

List<int> _decodeWeekdays(int value) {
  return [
    for (var day = 1; day <= 7; day++)
      if ((value & (1 << day)) != 0) day,
  ];
}

DateTime _nextWeeklyDay(DateTime from, List<int> days) {
  for (var offset = 1; offset <= 7; offset++) {
    final candidate = from.add(Duration(days: offset));
    if (days.contains(candidate.weekday)) {
      return candidate;
    }
  }
  return from.add(const Duration(days: 7));
}
