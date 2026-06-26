import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/care_repository.dart';
import '../data/care_plan_repository.dart';
import '../domain/care_activity_filter.dart';
import '../domain/care_plan_models.dart';
import 'care_plan_controller.dart';
import 'care_reminder_engine.dart';

/// 护理推荐模型，包含上次护理时间、紧急程度和推荐文案。
class CareRecommendation {
  const CareRecommendation({
    required this.plan,
    required this.lastCompletedAt,
    required this.daysSinceLastCare,
    required this.isOverdue,
    required this.isRecommended,
    required this.urgencyLevel,
    required this.recommendationText,
    this.dueAt,
    this.daysUntilDue,
    this.effectiveIntervalDays,
    this.priorityScore = 0,
    this.recentSkipCount = 0,
  });

  final CarePlan plan;

  /// 上次完成时间，null 表示从未完成过。
  final DateTime? lastCompletedAt;

  /// 距上次护理天数，null 表示从未完成过。
  final int? daysSinceLastCare;

  /// 是否已逾期（超过 nextDueAt）。
  final bool isOverdue;

  /// 计算出的下次到期时间，可能来自计划字段，也可能由日志推断。
  final DateTime? dueAt;

  /// 距离下次护理的天数，负数表示逾期。
  final int? daysUntilDue;

  /// 学习历史行为后的有效间隔。
  final int? effectiveIntervalDays;

  /// 推荐优先级分数，0~100。
  final int priorityScore;

  /// 最近连续跳过次数。
  final int recentSkipCount;

  /// 是否推荐现在护理。
  final bool isRecommended;

  /// 紧急程度：'urgent' | 'recommended' | 'on_track'。
  final String urgencyLevel;

  /// 推荐文案。
  final String recommendationText;
}

/// 聚合已开启计划 + 完成日志 + 调度规则，输出推荐列表。
/// 按紧急程度排序：urgent > recommended > on_track。
final careRecommendationsProvider = Provider<List<CareRecommendation>>((ref) {
  final planState = ref.watch(carePlanControllerProvider);
  final enabledPlans = planState.enabledPlans.values.toList();

  if (enabledPlans.isEmpty) return const [];

  final recommendations = <CareRecommendation>[];

  for (final plan in enabledPlans) {
    if (plan.paused) continue;

    // 事件驱动型计划不参与推荐排序
    final rule = scheduleRuleCodec.decodeAny(plan.scheduleRule);
    if (rule != null && rule.isEventDriven) continue;

    final logs = ref.watch(carePlanLogsProvider(plan.id)).value ?? const [];
    final activities =
        ref
            .watch(
              filteredCareActivitiesProvider(
                CareActivityFilter(petId: plan.petId, type: plan.careType),
              ),
            )
            .value ??
        const [];
    final completedAt = activities
        .map((activity) => activity.occurredAt)
        .toList(growable: false);
    final completionTimeline = completedAt;
    final lastCompleted = completionTimeline.fold<DateTime?>(null, (
      previous,
      occurredAt,
    ) {
      if (previous == null || occurredAt.isAfter(previous)) return occurredAt;
      return previous;
    });

    final now = DateTime.now();
    final daysSince = lastCompleted == null
        ? null
        : now.difference(lastCompleted).inDays;

    final decision = careReminderEngine.evaluate(
      plan: plan,
      logs: logs,
      now: now,
      completedAt: completedAt,
    );

    recommendations.add(
      CareRecommendation(
        plan: plan,
        lastCompletedAt: lastCompleted,
        daysSinceLastCare: daysSince,
        dueAt: decision.dueAt,
        daysUntilDue: decision.daysUntilDue,
        effectiveIntervalDays: decision.effectiveIntervalDays,
        recentSkipCount: decision.recentSkipCount,
        isOverdue: decision.isOverdue,
        isRecommended: decision.isRecommended,
        urgencyLevel: decision.urgencyLevel,
        priorityScore: decision.priorityScore,
        recommendationText: decision.recommendationText,
      ),
    );
  }

  // 按紧急程度 + 优先级排序。
  const urgencyOrder = {'urgent': 0, 'recommended': 1, 'on_track': 2};
  recommendations.sort((a, b) {
    final urgencyCompare = (urgencyOrder[a.urgencyLevel] ?? 3).compareTo(
      urgencyOrder[b.urgencyLevel] ?? 3,
    );
    if (urgencyCompare != 0) return urgencyCompare;
    final scoreCompare = b.priorityScore.compareTo(a.priorityScore);
    if (scoreCompare != 0) return scoreCompare;
    final aDue = a.dueAt;
    final bDue = b.dueAt;
    if (aDue != null && bDue != null) return aDue.compareTo(bDue);
    if (aDue != null) return -1;
    if (bDue != null) return 1;
    return a.plan.title.compareTo(b.plan.title);
  });

  return recommendations;
});

/// 计算到期推荐数量（用于通知 Badge）。
final dueRecommendationCountProvider = Provider<int>((ref) {
  final recommendations = ref.watch(careRecommendationsProvider);
  return recommendations.where((r) => r.isRecommended).length;
});
