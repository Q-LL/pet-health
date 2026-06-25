import 'package:flutter/foundation.dart';

enum CareSuggestionSource { profile, history, event, general }

// ---------------------------------------------------------------------------
// 结构化调度规则
// ---------------------------------------------------------------------------

/// 调度规则密封类，替代脆弱的中文正则解析。
sealed class ScheduleRule {
  const ScheduleRule();

  /// 等效间隔天数，事件驱动返回 null。
  int? get intervalDays;

  /// 从 [from] 计算下次到期时间，事件驱动返回 null。
  DateTime? nextOccurrence(DateTime from);

  /// 是否为事件驱动（不自动计算到期日）。
  bool get isEventDriven => this is EventDrivenRule;
}

/// 每天执行一次。
class DailyRule extends ScheduleRule {
  const DailyRule();

  @override
  int get intervalDays => 1;

  @override
  DateTime nextOccurrence(DateTime from) => from.add(const Duration(days: 1));

  @override
  String toString() => '每天';
}

/// 每隔 N 天执行一次。
class IntervalDayRule extends ScheduleRule {
  const IntervalDayRule(this.days);
  final int days;

  @override
  int get intervalDays => days;

  @override
  DateTime nextOccurrence(DateTime from) => from.add(Duration(days: days));

  @override
  String toString() => '每 $days 天';
}

/// 每周执行 N 次（等间隔分布）。
class WeeklyTimesRule extends ScheduleRule {
  const WeeklyTimesRule(this.times);
  final int times;

  @override
  int get intervalDays => times <= 0 ? 7 : (7 / times).ceil();

  @override
  DateTime nextOccurrence(DateTime from) =>
      from.add(Duration(days: intervalDays));

  @override
  String toString() => '每周 $times 次';
}

/// 每周指定日执行。
class WeeklyDayRule extends ScheduleRule {
  const WeeklyDayRule(this.weekdays);

  /// 1-7，周一到周日。
  final List<int> weekdays;

  @override
  int? get intervalDays {
    if (weekdays.isEmpty) return null;
    if (weekdays.length == 1) return 7;
    // 取相邻日期间隔的最小值作为参考
    final sorted = [...weekdays]..sort();
    var minGap = 7;
    for (var i = 0; i < sorted.length; i++) {
      final gap = i == sorted.length - 1
          ? (sorted[0] + 7 - sorted[i])
          : (sorted[i + 1] - sorted[i]);
      if (gap < minGap) minGap = gap;
    }
    return minGap;
  }

  @override
  DateTime nextOccurrence(DateTime from) {
    if (weekdays.isEmpty) return from.add(const Duration(days: 7));
    final sorted = [...weekdays]..sort();
    for (var offset = 1; offset <= 7; offset++) {
      final next = from.add(Duration(days: offset));
      if (sorted.contains(next.weekday)) return next;
    }
    return from.add(const Duration(days: 7));
  }

  @override
  String toString() {
    const labels = {1: '一', 2: '二', 3: '三', 4: '四', 5: '五', 6: '六', 7: '日'};
    return '每周${sorted.map((d) => labels[d] ?? '?').join('、')}';
  }

  List<int> get sorted => [...weekdays]..sort();
}

/// 自定义周期（天数）。
class CustomCycleRule extends ScheduleRule {
  const CustomCycleRule(this.days);
  final int days;

  @override
  int get intervalDays => days;

  @override
  DateTime nextOccurrence(DateTime from) => from.add(Duration(days: days));

  @override
  String toString() => '每 $days 天';
}

/// 事件触发型（如"每次遛狗后"），不计算到期日。
class EventDrivenRule extends ScheduleRule {
  const EventDrivenRule(this.trigger);
  final String trigger;

  @override
  int? get intervalDays => null;

  @override
  DateTime? nextOccurrence(DateTime from) => null;

  @override
  String toString() => '事件触发：$trigger';
}

// ---------------------------------------------------------------------------
// 调度规则编解码
// ---------------------------------------------------------------------------

/// 将 [ScheduleRule] 编解码为结构化字符串，格式 `type:value`。
class ScheduleRuleCodec {
  const ScheduleRuleCodec();

  /// 编码为持久化字符串。
  String encode(ScheduleRule rule) => switch (rule) {
    DailyRule() => 'daily',
    IntervalDayRule(:final days) => 'interval:${days}d',
    WeeklyTimesRule(:final times) => 'weekly_times:$times',
    WeeklyDayRule(:final weekdays) =>
      'weekly_days:${([...weekdays]..sort()).join(',')}',
    CustomCycleRule(:final days) => 'custom:$days',
    EventDrivenRule(:final trigger) => 'event:$trigger',
  };

  /// 从持久化字符串解码，返回 null 表示无法识别。
  ScheduleRule? decode(String raw) {
    final normalized = raw.trim();
    if (normalized.isEmpty) return null;

    // 无冒号的简单格式
    if (normalized == 'daily') return const DailyRule();

    final colonIdx = normalized.indexOf(':');
    if (colonIdx < 0) return null;

    final type = normalized.substring(0, colonIdx);
    final value = normalized.substring(colonIdx + 1);

    return switch (type) {
      'interval' => _parseInterval(value),
      'weekly_times' => _parseWeeklyTimes(value),
      'weekly_days' => _parseWeeklyDays(value),
      'custom' => _parseCustom(value),
      'event' => value.isEmpty ? null : EventDrivenRule(value),
      _ => null,
    };
  }

  ScheduleRule? _parseInterval(String value) {
    final match = RegExp(r'^(\d+)d$').firstMatch(value);
    if (match == null) return null;
    final days = int.tryParse(match.group(1)!);
    return days != null && days > 0 ? IntervalDayRule(days) : null;
  }

  ScheduleRule? _parseWeeklyTimes(String value) {
    final times = int.tryParse(value);
    return times != null && times > 0 ? WeeklyTimesRule(times) : null;
  }

  ScheduleRule? _parseWeeklyDays(String value) {
    final parts = value
        .split(',')
        .map((s) => int.tryParse(s.trim()))
        .whereType<int>()
        .toList();
    if (parts.isEmpty) return null;
    return WeeklyDayRule(parts.where((d) => d >= 1 && d <= 7).toList());
  }

  ScheduleRule? _parseCustom(String value) {
    final days = int.tryParse(value);
    return days != null && days > 0 ? CustomCycleRule(days) : null;
  }

  /// 向后兼容：尝试解析旧版中文格式的规则字符串。
  ScheduleRule? decodeLegacy(String raw) {
    final normalized = raw.trim();
    if (normalized.isEmpty) return null;

    if (normalized == '每天') return const DailyRule();

    final intervalMatch = RegExp(r'^每\s*(\d+)\s*(周|天)').firstMatch(normalized);
    if (intervalMatch != null) {
      final n = int.tryParse(intervalMatch.group(1)!) ?? 1;
      final unit = intervalMatch.group(2);
      return IntervalDayRule(unit == '周' ? n * 7 : n);
    }

    final weeklyTimesMatch = RegExp(r'^每周\s*(\d+)\s*次$').firstMatch(normalized);
    if (weeklyTimesMatch != null) {
      final times = int.tryParse(weeklyTimesMatch.group(1)!) ?? 1;
      if (times <= 0) return null;
      return WeeklyTimesRule(times);
    }

    if (normalized == '每周一次' ||
        normalized == '每周 1 次' ||
        normalized == '每周观察') {
      return const WeeklyTimesRule(1);
    }

    if (normalized.startsWith('根据历史') || normalized.startsWith('自定义')) {
      return const CustomCycleRule(14); // 默认 14 天
    }

    if (normalized.contains('遛狗后') || normalized.contains('事件')) {
      return const EventDrivenRule('walk');
    }

    return null;
  }

  /// 先尝试新格式，失败后回退到旧格式兼容。
  ScheduleRule? decodeAny(String raw) {
    return decode(raw) ?? decodeLegacy(raw);
  }
}

const scheduleRuleCodec = ScheduleRuleCodec();

/// 静态候选项，不入库，由 [carePlanCandidatesProvider] 提供。
@immutable
class CarePlanCandidate {
  const CarePlanCandidate({
    required this.id,
    required this.title,
    required this.summary,
    required this.reason,
    required this.source,
    required this.scheduleOptions,
    required this.defaultSchedule,
    required this.iconKey,
  });

  final String id;
  final String title;
  final String summary;
  final String reason;
  final CareSuggestionSource source;

  /// 可选的调度规则列表。
  final List<ScheduleRule> scheduleOptions;

  /// 默认选中的调度规则。
  final ScheduleRule defaultSchedule;

  final String iconKey;
}

/// 持久化的护理计划，对应数据库 care_plans 表行。
@immutable
class CarePlan {
  const CarePlan({
    required this.id,
    required this.petId,
    required this.candidateId,
    required this.careType,
    required this.title,
    required this.scheduleRule,
    required this.enabled,
    required this.createdAt,
    required this.updatedAt,
    this.nextDueAt,
    this.paused = false,
    this.reasonSnapshot = '',
    this.ruleId,
    this.ruleVersion,
  });

  final String id;
  final String petId;
  final String candidateId;
  final String careType;
  final String title;
  final String scheduleRule;
  final DateTime? nextDueAt;
  final bool enabled;
  final bool paused;
  final String reasonSnapshot;
  final String? ruleId;
  final String? ruleVersion;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// 是否已被忽略（关闭且未启用）。
  bool get isDismissed => !enabled;
}

/// 创建或更新护理计划的草稿。
@immutable
class CarePlanDraft {
  const CarePlanDraft({
    required this.petId,
    required this.candidateId,
    required this.careType,
    required this.title,
    required this.scheduleRule,
    this.enabled = true,
    this.paused = false,
    this.nextDueAt,
    this.reasonSnapshot = '',
    this.ruleId,
    this.ruleVersion,
  });

  final String petId;
  final String candidateId;
  final String careType;
  final String title;
  final String scheduleRule;
  final bool enabled;
  final bool paused;
  final DateTime? nextDueAt;
  final String reasonSnapshot;
  final String? ruleId;
  final String? ruleVersion;
}

/// 护理计划完成或跳过的日志。
@immutable
class CarePlanLog {
  const CarePlanLog({
    required this.id,
    required this.planId,
    required this.petId,
    required this.occurredAt,
    required this.action,
    this.note = '',
    required this.createdAt,
  });

  final String id;
  final String planId;
  final String petId;
  final DateTime occurredAt;

  /// `completed` 或 `skipped`。
  final String action;
  final String note;
  final DateTime createdAt;
}

/// 写入护理计划日志的草稿。
@immutable
class CarePlanLogDraft {
  const CarePlanLogDraft({
    required this.planId,
    required this.petId,
    required this.action,
    this.occurredAt,
    this.note = '',
  });

  final String planId;
  final String petId;
  final String action;
  final DateTime? occurredAt;
  final String note;
}

/// 内存视图状态，由 CarePlanController 维护。
///
/// [enabledPlans] 以 candidateId 为 key，方便 UI 快速查找。
/// [dismissedCandidateIds] 包含已被忽略的候选 ID。
@immutable
class CarePlanState {
  const CarePlanState({
    this.enabledPlans = const {},
    this.dismissedCandidateIds = const {},
    this.isLoading = false,
  });

  final Map<String, CarePlan> enabledPlans;
  final Set<String> dismissedCandidateIds;
  final bool isLoading;

  CarePlanState copyWith({
    Map<String, CarePlan>? enabledPlans,
    Set<String>? dismissedCandidateIds,
    bool? isLoading,
  }) {
    return CarePlanState(
      enabledPlans: enabledPlans ?? this.enabledPlans,
      dismissedCandidateIds:
          dismissedCandidateIds ?? this.dismissedCandidateIds,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
