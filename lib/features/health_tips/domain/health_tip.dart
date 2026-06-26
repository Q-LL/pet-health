import 'package:flutter/material.dart';

/// 健康动态提示类别。
const healthTipCategories = {'seasonal', 'life_stage', 'data_insight', 'breed'};

/// 健康动态提示优先级。
const healthTipPriorities = {'high', 'medium', 'low'};

/// 一条健康动态提示。
///
/// 由 [HealthTipsEngine] 计算产生，每条建议都带有「为什么出现」的透明说明。
@immutable
class HealthTip {
  const HealthTip({
    required this.id,
    required this.category,
    required this.priority,
    required this.icon,
    required this.title,
    required this.body,
    required this.reason,
    this.actionLabel,
  });

  /// 唯一标识，用于去重和 dismiss。
  final String id;

  /// 类别：'seasonal' | 'life_stage' | 'data_insight' | 'breed'。
  final String category;

  /// 优先级：'high' | 'medium' | 'low'。
  final String priority;

  /// 展示图标。
  final IconData icon;

  /// 建议标题（简短，一行内）。
  final String title;

  /// 建议正文（1–3 句话）。
  final String body;

  /// "为什么出现这条建议" 的透明说明。
  final String reason;

  /// 可选的操作按钮文案。
  final String? actionLabel;
}

/// 健康提示引擎输入上下文。
@immutable
class HealthTipsContext {
  const HealthTipsContext({
    required this.pet,
    required this.recentRecords,
    required this.weightHistory,
    required this.enabledPlanCount,
    required this.hasEnabledDewormingPlan,
    required this.coverageRate,
    required this.now,
  });

  /// 当前宠物档案。
  final PetTipsProfile pet;

  /// 最近 30 天的健康记录。
  final List<TipsHealthRecord> recentRecords;

  /// 全部体重记录（按时间正序）。
  final List<TipsWeightRecord> weightHistory;

  /// 已开启的护理计划数量。
  final int enabledPlanCount;

  /// 是否已开启驱虫类护理计划。
  final bool hasEnabledDewormingPlan;

  /// 本周护理覆盖率 (0.0–1.0)。
  final double coverageRate;

  /// 当前时间。
  final DateTime now;
}

/// 引擎使用的宠物档案精简模型，避免直接依赖数据库模型。
@immutable
class PetTipsProfile {
  const PetTipsProfile({
    required this.id,
    required this.name,
    this.species,
    this.breed,
    this.birthday,
    this.neutered,
    this.allergies = '',
    this.chronicConditions = '',
  });

  final String id;
  final String name;
  final String? species;
  final String? breed;
  final DateTime? birthday;
  final bool? neutered;
  final String allergies;
  final String chronicConditions;
}

/// 引擎使用的健康记录精简模型。
@immutable
class TipsHealthRecord {
  const TipsHealthRecord({
    required this.type,
    required this.occurredAt,
    required this.title,
    this.note = '',
    this.numericValue,
    this.unit,
    this.severity,
    this.details = const {},
  });

  final String type;
  final DateTime occurredAt;
  final String title;
  final String note;
  final double? numericValue;
  final String? unit;
  final int? severity;
  final Map<String, String> details;
}

/// 引擎使用的体重记录精简模型。
@immutable
class TipsWeightRecord {
  const TipsWeightRecord({
    required this.occurredAt,
    required this.value,
    this.unit = 'kg',
  });

  final DateTime occurredAt;
  final double value;
  final String? unit;
}
