import 'package:flutter/foundation.dart';

import 'health_summary.dart';
import 'health_tip.dart';

const healthDynamicsCategories = {
  'weight',
  'diet',
  'water',
  'elimination',
  'symptom',
  'care',
  'preventive',
  'data_quality',
  'positive',
};

const healthDynamicsTones = {'alert', 'watch', 'positive', 'info'};

@immutable
class HealthDynamicInsight {
  const HealthDynamicInsight({
    required this.id,
    required this.category,
    required this.tone,
    required this.title,
    required this.body,
    required this.suggestion,
    required this.occurredAt,
    required this.score,
    this.evidence = const [],
  });

  final String id;
  final String category;
  final String tone;
  final String title;
  final String body;
  final String suggestion;
  final DateTime occurredAt;
  final int score;
  final List<String> evidence;
}

@immutable
class HealthDynamics {
  const HealthDynamics({
    required this.petName,
    required this.generatedAt,
    this.summary = const HealthSummary(),
    this.insights = const [],
    this.recommendations = const [],
  });

  final String petName;
  final DateTime generatedAt;
  final HealthSummary summary;
  final List<HealthDynamicInsight> insights;
  final List<HealthTip> recommendations;

  bool get hasContent =>
      summary.hasAnyMetric || insights.isNotEmpty || recommendations.isNotEmpty;

  List<HealthDynamicInsight> get priorityInsights => insights
      .where((item) => item.tone == 'alert' || item.tone == 'watch')
      .toList(growable: false);
}
