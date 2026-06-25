import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/care_plan_repository.dart';
import '../domain/care_plan_models.dart';
import 'care_plan_controller.dart';

/// 护理覆盖率统计模型。
class CareCoverage {
  const CareCoverage({
    required this.totalActivePlans,
    required this.completedThisWeek,
    required this.expectedThisWeek,
    required this.weeklyRate,
    required this.currentStreak,
    required this.coverageLevel,
  });

  /// 开启的非事件驱动计划总数。
  final int totalActivePlans;

  /// 本周（过去 7 天）完成次数。
  final int completedThisWeek;

  /// 本周应完成次数。
  final int expectedThisWeek;

  /// 本周覆盖率 (0.0~1.0)。
  final double weeklyRate;

  /// 连续达标周数（覆盖率 >= 80%）。
  final int currentStreak;

  /// 覆盖率等级：'excellent' | 'good' | 'needs_improvement'。
  final String coverageLevel;
}

class CarePlanCoverageProgress {
  const CarePlanCoverageProgress({
    required this.plan,
    required this.expected,
    required this.completed,
  });

  final CarePlan plan;
  final int expected;
  final int completed;

  int get remaining => (expected - completed).clamp(0, expected).toInt();
  double get rate =>
      expected == 0 ? 1.0 : (completed / expected).clamp(0.0, 1.0);
}

class CareCoveragePeriod {
  const CareCoveragePeriod({
    required this.label,
    required this.completed,
    required this.expected,
  });

  final String label;
  final int completed;
  final int expected;

  double get rate =>
      expected == 0 ? 1.0 : (completed / expected).clamp(0.0, 1.0);
}

class CareCoverageDetail {
  const CareCoverageDetail({
    required this.thisWeek,
    required this.weeklyPeriods,
    required this.monthlyPeriods,
  });

  final List<CarePlanCoverageProgress> thisWeek;
  final List<CareCoveragePeriod> weeklyPeriods;
  final List<CareCoveragePeriod> monthlyPeriods;

  List<CarePlanCoverageProgress> get remainingThisWeek =>
      thisWeek.where((item) => item.remaining > 0).toList(growable: false);
}

/// 护理覆盖率 Provider。
final careCoverageProvider = FutureProvider<CareCoverage>((ref) async {
  final planState = ref.watch(carePlanControllerProvider);
  final activePlans = _activePlans(planState);

  if (activePlans.isEmpty) {
    return const CareCoverage(
      totalActivePlans: 0,
      completedThisWeek: 0,
      expectedThisWeek: 0,
      weeklyRate: 1.0,
      currentStreak: 0,
      coverageLevel: 'excellent',
    );
  }

  final now = DateTime.now();
  final weekStart = _startOfWeek(now);
  final weekEnd = weekStart.add(const Duration(days: 7));
  final repository = ref.read(carePlanRepositoryProvider);

  var totalCompleted = 0;
  var totalExpected = 0;

  for (final plan in activePlans) {
    final rule = scheduleRuleCodec.decodeAny(plan.scheduleRule);
    if (rule == null || rule.isEventDriven) continue;

    final interval = rule.intervalDays;
    if (interval == null || interval <= 0) continue;

    totalExpected += _expectedCountForPlan(plan, interval, weekStart, weekEnd);

    final logs = await repository.findLogs(plan.id);
    totalCompleted += _completedForPlan(plan, logs, weekStart, weekEnd);
  }

  final rate = totalExpected > 0
      ? (totalCompleted / totalExpected).clamp(0.0, 1.0).toDouble()
      : 1.0;

  // 计算连续达标周数（简化版：检查过去 N 周的覆盖率）
  final streak = await _calculateStreak(
    activePlans: activePlans,
    repository: repository,
    currentRate: rate,
  );

  String level;
  if (rate >= 0.9) {
    level = 'excellent';
  } else if (rate >= 0.7) {
    level = 'good';
  } else {
    level = 'needs_improvement';
  }

  return CareCoverage(
    totalActivePlans: activePlans.length,
    completedThisWeek: totalCompleted,
    expectedThisWeek: totalExpected,
    weeklyRate: rate,
    currentStreak: streak,
    coverageLevel: level,
  );
});

final careCoverageDetailProvider = FutureProvider<CareCoverageDetail>((
  ref,
) async {
  final activePlans = _activePlans(ref.watch(carePlanControllerProvider));
  final repository = ref.read(carePlanRepositoryProvider);
  final now = DateTime.now();
  final weekStart = _startOfWeek(now);
  final weekEnd = weekStart.add(const Duration(days: 7));

  final thisWeek = <CarePlanCoverageProgress>[];
  for (final plan in activePlans) {
    final rule = scheduleRuleCodec.decodeAny(plan.scheduleRule);
    final interval = rule?.intervalDays;
    if (interval == null || interval <= 0) continue;
    final logs = await repository.findLogs(plan.id);
    final expected = _expectedCountForPlan(plan, interval, weekStart, weekEnd);
    thisWeek.add(
      CarePlanCoverageProgress(
        plan: plan,
        expected: expected,
        completed: _completedForPlan(plan, logs, weekStart, weekEnd),
      ),
    );
  }

  final weeklyPeriods = <CareCoveragePeriod>[];
  for (var offset = 0; offset < 6; offset++) {
    final start = weekStart.subtract(Duration(days: offset * 7));
    final end = start.add(const Duration(days: 7));
    final totals = await _periodTotals(activePlans, repository, start, end);
    if (totals.$2 > 0) {
      weeklyPeriods.add(
        CareCoveragePeriod(
          label: offset == 0
              ? '本周'
              : offset == 1
              ? '上周'
              : '${start.toLocal().month}/${start.toLocal().day}',
          completed: totals.$1,
          expected: totals.$2,
        ),
      );
    }
  }

  final monthlyPeriods = <CareCoveragePeriod>[];
  for (var offset = 0; offset < 6; offset++) {
    final month = DateTime(now.year, now.month - offset);
    final start = DateTime(month.year, month.month);
    final end = DateTime(month.year, month.month + 1);
    final totals = await _periodTotals(activePlans, repository, start, end);
    if (totals.$2 > 0) {
      monthlyPeriods.add(
        CareCoveragePeriod(
          label: offset == 0 ? '本月' : '${start.year}/${start.month}',
          completed: totals.$1,
          expected: totals.$2,
        ),
      );
    }
  }

  return CareCoverageDetail(
    thisWeek: thisWeek,
    weeklyPeriods: weeklyPeriods,
    monthlyPeriods: monthlyPeriods,
  );
});

/// 计算连续达标周数。
Future<int> _calculateStreak({
  required List<CarePlan> activePlans,
  required CarePlanRepository repository,
  required double currentRate,
}) async {
  if (currentRate < 0.8) return 0;

  var streak = 1; // 本周已达标
  final weekStartNow = _startOfWeek(DateTime.now());

  // 检查过去最多 4 周
  for (var weekOffset = 1; weekOffset <= 4; weekOffset++) {
    final weekEnd = weekStartNow.subtract(Duration(days: 7 * (weekOffset - 1)));
    final weekStart = weekEnd.subtract(const Duration(days: 7));

    var weekCompleted = 0;
    var weekExpected = 0;

    for (final plan in activePlans) {
      final rule = scheduleRuleCodec.decodeAny(plan.scheduleRule);
      if (rule == null || rule.isEventDriven) continue;

      final interval = rule.intervalDays;
      if (interval == null || interval <= 0) continue;

      weekExpected += _expectedCountForPlan(plan, interval, weekStart, weekEnd);

      final logs = await repository.findLogs(plan.id);
      weekCompleted += _completedForPlan(plan, logs, weekStart, weekEnd);
    }

    if (weekExpected == 0) break;

    final weekRate = weekExpected > 0
        ? (weekCompleted / weekExpected).clamp(0.0, 1.0).toDouble()
        : 1.0;

    if (weekRate >= 0.8) {
      streak++;
    } else {
      break;
    }
  }

  return streak;
}

List<CarePlan> _activePlans(CarePlanState planState) {
  return planState.enabledPlans.values.where((plan) {
    if (plan.paused) return false;
    final rule = scheduleRuleCodec.decodeAny(plan.scheduleRule);
    return rule != null && !rule.isEventDriven;
  }).toList();
}

Future<(int, int)> _periodTotals(
  List<CarePlan> plans,
  CarePlanRepository repository,
  DateTime start,
  DateTime end,
) async {
  var completed = 0;
  var expected = 0;
  for (final plan in plans) {
    final rule = scheduleRuleCodec.decodeAny(plan.scheduleRule);
    final interval = rule?.intervalDays;
    if (interval == null || interval <= 0) continue;
    expected += _expectedCountForPlan(plan, interval, start, end);
    completed += _completedForPlan(
      plan,
      await repository.findLogs(plan.id),
      start,
      end,
    );
  }
  return (completed, expected);
}

int _completedForPlan(
  CarePlan plan,
  List<CarePlanLog> logs,
  DateTime start,
  DateTime end,
) {
  final effectiveStart = _maxDate(start, plan.createdAt.toUtc());
  return logs
      .where(
        (log) =>
            log.action == 'completed' &&
            !log.occurredAt.isBefore(effectiveStart) &&
            log.occurredAt.isBefore(end),
      )
      .length;
}

int _expectedCountForPlan(
  CarePlan plan,
  int intervalDays,
  DateTime start,
  DateTime end,
) {
  final effectiveStart = _maxDate(start, plan.createdAt.toUtc());
  if (!effectiveStart.isBefore(end)) return 0;
  final days = end.difference(effectiveStart).inDays;
  return (days / intervalDays).ceil().clamp(1, 365).toInt();
}

DateTime _maxDate(DateTime a, DateTime b) => a.isAfter(b) ? a : b;

DateTime _startOfWeek(DateTime date) {
  final local = date.toLocal();
  final day = DateTime(local.year, local.month, local.day);
  return day.subtract(Duration(days: day.weekday - DateTime.monday)).toUtc();
}
