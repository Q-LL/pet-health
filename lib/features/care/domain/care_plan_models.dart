import 'package:flutter/foundation.dart';

enum CareSuggestionSource { profile, history, event, general }

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

@immutable
class EnabledCarePlan {
  const EnabledCarePlan({
    required this.candidateId,
    required this.schedule,
    required this.enabledAt,
  });

  final String candidateId;
  final String schedule;
  final DateTime enabledAt;
}

@immutable
class CarePlanState {
  const CarePlanState({
    this.enabledPlans = const {},
    this.dismissedCandidateIds = const {},
  });

  final Map<String, EnabledCarePlan> enabledPlans;
  final Set<String> dismissedCandidateIds;

  CarePlanState copyWith({
    Map<String, EnabledCarePlan>? enabledPlans,
    Set<String>? dismissedCandidateIds,
  }) {
    return CarePlanState(
      enabledPlans: enabledPlans ?? this.enabledPlans,
      dismissedCandidateIds:
          dismissedCandidateIds ?? this.dismissedCandidateIds,
    );
  }
}
