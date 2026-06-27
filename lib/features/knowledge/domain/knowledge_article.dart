import 'package:flutter/foundation.dart';

const knowledgeCategories = {
  'symptom_observation': '症状观察',
  'record_guide': '记录指南',
  'daily_care': '日常护理',
  'preventive_health': '预防健康',
  'vet_preparation': '就医准备',
  'life_stage': '生命周期',
  'breed_traits': '犬种差异',
  'seasonal_care': '季节照护',
  'emergency_first_aid': '急救常识',
  'nutrition_diet': '营养与饮食',
  'skin_coat': '皮肤与被毛',
  'behavior_training': '行为与训练',
};

const knowledgeSeverityLabels = {
  'info': '参考',
  'watch': '观察',
  'urgent': '尽快联系兽医',
};

@immutable
class KnowledgeArticle {
  const KnowledgeArticle({
    required this.id,
    required this.title,
    required this.category,
    required this.summary,
    required this.body,
    required this.severityLevel,
    required this.species,
    required this.lifeStage,
    required this.contextKeys,
    required this.tags,
    required this.redFlags,
    required this.suggestedActions,
    required this.reviewedStatus,
    required this.version,
    required this.updatedAt,
    this.sources = const [],
  });

  final String id;
  final String title;
  final String category;
  final String summary;
  final String body;
  final String severityLevel;
  final String species;
  final String lifeStage;
  final List<String> contextKeys;
  final List<String> tags;
  final List<String> redFlags;
  final List<String> suggestedActions;
  final String reviewedStatus;
  final String version;
  final DateTime updatedAt;
  final List<KnowledgeSource> sources;

  String get categoryLabel => knowledgeCategories[category] ?? category;
  String get severityLabel =>
      knowledgeSeverityLabels[severityLevel] ?? severityLevel;

  KnowledgeArticle copyWith({List<KnowledgeSource>? sources}) {
    return KnowledgeArticle(
      id: id,
      title: title,
      category: category,
      summary: summary,
      body: body,
      severityLevel: severityLevel,
      species: species,
      lifeStage: lifeStage,
      contextKeys: contextKeys,
      tags: tags,
      redFlags: redFlags,
      suggestedActions: suggestedActions,
      reviewedStatus: reviewedStatus,
      version: version,
      updatedAt: updatedAt,
      sources: sources ?? this.sources,
    );
  }
}

@immutable
class KnowledgeSource {
  const KnowledgeSource({
    required this.id,
    required this.title,
    required this.organization,
    required this.url,
    required this.licenseNote,
    required this.accessedAt,
  });

  final String id;
  final String title;
  final String organization;
  final String url;
  final String licenseNote;
  final DateTime accessedAt;
}
