import '../domain/care_plan_models.dart';

class CareReminderDecision {
  const CareReminderDecision({
    required this.dueAt,
    required this.effectiveIntervalDays,
    required this.isOverdue,
    required this.isRecommended,
    required this.urgencyLevel,
    required this.priorityScore,
    required this.recommendationText,
    this.lastCompletedAt,
    this.daysSinceLastCare,
    this.daysUntilDue,
    this.recentSkipCount = 0,
  });

  final DateTime? dueAt;
  final DateTime? lastCompletedAt;
  final int? daysSinceLastCare;
  final int? daysUntilDue;
  final int? effectiveIntervalDays;
  final int recentSkipCount;
  final bool isOverdue;
  final bool isRecommended;
  final String urgencyLevel;
  final int priorityScore;
  final String recommendationText;
}

class CareReminderEngine {
  const CareReminderEngine();

  DateTime? initialDueAt({
    required ScheduleRule? rule,
    required DateTime now,
    DateTime? lastCareAt,
  }) {
    if (rule == null || rule.isEventDriven) return null;

    final interval = rule.intervalDays;
    if (interval == null || interval <= 0) return null;

    final anchor = lastCareAt ?? now;
    final rawDue = lastCareAt == null
        ? _firstDueAt(now, interval)
        : _friendlyCareTime(anchor.add(Duration(days: interval)));

    return rawDue.isAfter(now)
        ? rawDue
        : _friendlyCareTime(now.add(const Duration(days: 1)));
  }

  DateTime? nextDueAfterLogs({
    required ScheduleRule? rule,
    required String careType,
    required DateTime now,
    required List<CarePlanLog> logs,
    List<DateTime>? completedAt,
    DateTime? fallbackDueAt,
  }) {
    if (rule == null || rule.isEventDriven) return null;
    final interval = effectiveIntervalDays(
      rule: rule,
      careType: careType,
      logs: logs,
      completedAt: completedAt,
    );
    if (interval == null) return fallbackDueAt;

    final latestAction = _latestAction(logs);
    final lastCompleted = _lastCompletedAt(logs, completedAt: completedAt);
    if (lastCompleted == null && completedAt != null) {
      return initialDueAt(rule: rule, now: now) ?? fallbackDueAt;
    }
    if (latestAction == null && lastCompleted == null) {
      return fallbackDueAt ?? initialDueAt(rule: rule, now: now);
    }

    if (latestAction != null &&
        latestAction.action == 'skipped' &&
        (lastCompleted == null ||
            latestAction.occurredAt.isAfter(lastCompleted))) {
      return _friendlyCareTime(
        latestAction.occurredAt.add(
          Duration(days: _skipFollowUpDays(interval)),
        ),
      );
    }

    if (lastCompleted == null) return fallbackDueAt;
    return _friendlyCareTime(lastCompleted.add(Duration(days: interval)));
  }

  CareReminderDecision evaluate({
    required CarePlan plan,
    required List<CarePlanLog> logs,
    required DateTime now,
    List<DateTime>? completedAt,
  }) {
    final rule = scheduleRuleCodec.decodeAny(plan.scheduleRule);
    if (rule == null || rule.isEventDriven) {
      return CareReminderDecision(
        dueAt: null,
        effectiveIntervalDays: null,
        isOverdue: false,
        isRecommended: false,
        urgencyLevel: 'on_track',
        priorityScore: 0,
        recommendationText: '由事件触发，暂不需要固定提醒',
      );
    }

    final interval = effectiveIntervalDays(
      rule: rule,
      careType: plan.careType,
      logs: logs,
      completedAt: completedAt,
    );
    final lastCompleted = _lastCompletedAt(logs, completedAt: completedAt);
    final recentSkips = _recentSkipCount(logs);
    final dueAt = nextDueAfterLogs(
      rule: rule,
      careType: plan.careType,
      logs: logs,
      now: now,
      completedAt: completedAt,
      fallbackDueAt: plan.nextDueAt,
    );
    final daysSince = lastCompleted == null
        ? null
        : now.difference(lastCompleted).inDays;
    final daysUntil = dueAt?.difference(now).inDays;
    final isOverdue = dueAt != null && !dueAt.isAfter(now);
    final reminderWindow = _reminderWindowDaysFor(plan.careType, interval);
    final shouldSurface =
        isOverdue ||
        lastCompleted == null ||
        _isInsideReminderWindow(dueAt, now, reminderWindow) ||
        _isInsideSkipFollowUpWindow(dueAt, now, interval, recentSkips) ||
        recentSkips >= 2;

    final score = _priorityScore(
      careType: plan.careType,
      interval: interval,
      daysSince: daysSince,
      daysUntil: daysUntil,
      dueAt: dueAt,
      now: now,
      isOverdue: isOverdue,
      hasNeverCompleted: lastCompleted == null,
      recentSkips: recentSkips,
    );
    final urgencyLevel = _urgencyLevel(score, isOverdue, interval, daysSince);

    return CareReminderDecision(
      dueAt: dueAt,
      lastCompletedAt: lastCompleted,
      daysSinceLastCare: daysSince,
      daysUntilDue: daysUntil,
      effectiveIntervalDays: interval,
      recentSkipCount: recentSkips,
      isOverdue: isOverdue,
      isRecommended: shouldSurface,
      urgencyLevel: urgencyLevel,
      priorityScore: score,
      recommendationText: _recommendationText(
        interval: interval,
        careType: plan.careType,
        daysSince: daysSince,
        daysUntil: daysUntil,
        dueAt: dueAt,
        now: now,
        isOverdue: isOverdue,
        lastCompletedAt: lastCompleted,
        recentSkips: recentSkips,
      ),
    );
  }

  int? effectiveIntervalDays({
    required ScheduleRule rule,
    required String careType,
    required List<CarePlanLog> logs,
    List<DateTime>? completedAt,
  }) {
    final base = rule.intervalDays;
    if (base == null || base <= 0) return null;

    final completed = [..._completedTimeline(logs, completedAt)]..sort();
    if (completed.length < 3) return base;

    final gaps = <int>[];
    for (var i = 1; i < completed.length; i++) {
      final gap = completed[i].difference(completed[i - 1]).inDays;
      if (gap > 0) gaps.add(gap);
    }
    if (gaps.length < 2) return base;

    gaps.sort();
    final median = gaps[gaps.length ~/ 2];
    final blended = ((base * 0.35) + (median * 0.65)).round();
    final lower = (base * _lowerClampFor(careType)).round().clamp(1, base);
    final upper = (base * _upperClampFor(careType)).round().clamp(base, 365);
    return blended.clamp(lower, upper).toInt();
  }
}

const careReminderEngine = CareReminderEngine();

DateTime? _lastCompletedAt(
  List<CarePlanLog> logs, {
  List<DateTime>? completedAt,
}) {
  DateTime? last;
  for (final occurredAt in _completedTimeline(logs, completedAt)) {
    if (last == null || occurredAt.isAfter(last)) {
      last = occurredAt;
    }
  }
  return last;
}

List<DateTime> _completedTimeline(
  List<CarePlanLog> logs,
  List<DateTime>? completedAt,
) {
  if (completedAt != null) return completedAt;
  return logs
      .where((log) => log.action == 'completed')
      .map((log) => log.occurredAt)
      .toList();
}

CarePlanLog? _latestAction(List<CarePlanLog> logs) {
  CarePlanLog? latest;
  for (final log in logs) {
    if (latest == null || log.occurredAt.isAfter(latest.occurredAt)) {
      latest = log;
    }
  }
  return latest;
}

int _recentSkipCount(List<CarePlanLog> logs) {
  final sorted = [...logs]
    ..sort((a, b) => b.occurredAt.compareTo(a.occurredAt));
  var count = 0;
  for (final log in sorted.take(4)) {
    if (log.action == 'skipped') {
      count++;
      continue;
    }
    if (log.action == 'completed') break;
  }
  return count;
}

DateTime _firstDueAt(DateTime now, int interval) {
  if (interval <= 1) return _friendlyCareTime(now);
  if (interval <= 7) {
    return _friendlyCareTime(now.add(const Duration(days: 1)));
  }
  return _friendlyCareTime(now.add(Duration(days: (interval / 3).ceil())));
}

DateTime _friendlyCareTime(DateTime date) {
  final local = date.toLocal();
  return DateTime(local.year, local.month, local.day, 20).toUtc();
}

int _skipFollowUpDays(int interval) {
  if (interval <= 3) return 1;
  if (interval <= 14) return 2;
  if (interval <= 45) return 3;
  return 7;
}

int _reminderWindowDaysFor(String careType, int? interval) {
  if (interval == null || interval <= 3) return 0;
  if (careType == 'ear' || careType == 'eye') return 0;
  if (interval <= 14) return 1;
  if (interval <= 45) return 2;
  return 7;
}

bool _isInsideReminderWindow(DateTime? dueAt, DateTime now, int windowDays) {
  if (dueAt == null || !dueAt.isAfter(now)) return false;
  if (windowDays <= 0) return false;
  return dueAt.difference(now) <= Duration(days: windowDays);
}

bool _isInsideSkipFollowUpWindow(
  DateTime? dueAt,
  DateTime now,
  int? interval,
  int recentSkips,
) {
  if (recentSkips <= 0 || dueAt == null || !dueAt.isAfter(now)) return false;
  if (interval == null || interval <= 0) return false;
  return dueAt.difference(now) <= Duration(days: _skipFollowUpDays(interval));
}

int _priorityScore({
  required String careType,
  required int? interval,
  required int? daysSince,
  required int? daysUntil,
  required DateTime? dueAt,
  required DateTime now,
  required bool isOverdue,
  required bool hasNeverCompleted,
  required int recentSkips,
}) {
  var score = _riskWeight(careType);
  if (hasNeverCompleted) score += 35;
  if (recentSkips > 0) score += 12 * recentSkips;

  if (isOverdue) {
    score += 45;
    if (interval != null && daysSince != null) {
      score += ((daysSince / interval) * 25).round();
    } else if (daysUntil != null) {
      score += (-daysUntil).clamp(0, 14) * 3;
    }
  } else if (dueAt != null && interval != null) {
    final window = _reminderWindowDaysFor(careType, interval);
    if (_isInsideReminderWindow(dueAt, now, window)) {
      score += 25 - ((daysUntil ?? 0).clamp(0, window) * 5);
    }
  }

  return score.clamp(0, 100);
}

String _urgencyLevel(int score, bool isOverdue, int? interval, int? daysSince) {
  final overdueALot =
      isOverdue &&
      interval != null &&
      daysSince != null &&
      daysSince >= (interval * 1.4).ceil();
  if (score >= 75 || overdueALot) return 'urgent';
  if (score >= 40 || isOverdue) return 'recommended';
  return 'on_track';
}

String _recommendationText({
  required int? interval,
  required String careType,
  required int? daysSince,
  required int? daysUntil,
  required DateTime? dueAt,
  required DateTime now,
  required bool isOverdue,
  required DateTime? lastCompletedAt,
  required int recentSkips,
}) {
  if (recentSkips >= 2) {
    return '最近连续跳过，建议安排一个更容易完成的时间';
  }
  if (lastCompletedAt == null) {
    final hint = interval == null ? '' : '，之后约每 $interval 天一次';
    return '还没有完成过这项护理，建议先完成第一次$hint';
  }
  if (isOverdue) {
    final overdueDays = daysUntil == null ? null : -daysUntil;
    if (overdueDays != null && overdueDays > 0) {
      return '已超过推荐时间 $overdueDays 天，建议尽快护理';
    }
    return '已到推荐护理时间，建议今天完成';
  }
  if (_isInsideReminderWindow(
    dueAt,
    now,
    _reminderWindowDaysFor(careType, interval),
  )) {
    final daysText = daysUntil == null || daysUntil <= 0
        ? '今天'
        : '$daysUntil 天后';
    return '$daysText 到推荐时间，可以提前安排';
  }
  if (daysSince != null && interval != null) {
    return '节奏正常，距离上次护理 $daysSince 天，建议间隔约 $interval 天';
  }
  return '按计划进行中';
}

int _riskWeight(String careType) => switch (careType) {
  'deworming' => 28,
  'oral' => 22,
  'ear' || 'eye' => 18,
  'nail' || 'paw' => 14,
  'bath' || 'combing' || 'environment' => 10,
  _ => 8,
};

double _lowerClampFor(String careType) => switch (careType) {
  'deworming' || 'oral' => 0.75,
  _ => 0.6,
};

double _upperClampFor(String careType) => switch (careType) {
  'deworming' => 1.15,
  'oral' || 'ear' || 'eye' => 1.4,
  _ => 1.8,
};
