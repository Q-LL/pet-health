import 'package:flutter/foundation.dart';

enum CareSuggestionSource { profile, history, event, general }

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
  final List<String> scheduleOptions;
  final String defaultSchedule;
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
