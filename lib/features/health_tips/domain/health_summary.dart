import 'package:flutter/material.dart';

/// 单项健康指标摘要。
///
/// 展示某个维度（体重、记录频次、护理等）的当前值与上期对比。
@immutable
class MetricItem {
  const MetricItem({
    required this.label,
    required this.value,
    required this.comparison,
    required this.trend,
    this.positiveTrend = true,
  });

  /// 指标名称，如"体重"、"记录"、"护理"。
  final String label;

  /// 当前值文本，如"5.2 kg"、"23 条"、"78%"。
  final String value;

  /// 对比文本，如"↑0.3 kg"、"+5 条"、"↑12%"。
  final String comparison;

  /// 趋势方向：'up' | 'down' | 'stable'。
  final String trend;

  /// 趋势是否为正向（好方向）。
  ///
  /// 由引擎在构建时根据指标类型决定：
  /// - 体重上升 → 通常为负向
  /// - 记录增多 → 通常为正向
  /// - 护理提高 → 正向
  final bool positiveTrend;

  /// 复制并覆盖部分字段。
  MetricItem copyWith({
    String? label,
    String? value,
    String? comparison,
    String? trend,
    bool? positiveTrend,
  }) {
    return MetricItem(
      label: label ?? this.label,
      value: value ?? this.value,
      comparison: comparison ?? this.comparison,
      trend: trend ?? this.trend,
      positiveTrend: positiveTrend ?? this.positiveTrend,
    );
  }

  /// 根据趋势返回合适的颜色提示。
  Color trendColor(ColorScheme colors, {bool positiveIsGood = true}) {
    if (trend == 'stable') return colors.onSurfaceVariant;
    final isGood = positiveIsGood ? (trend == 'up') : (trend == 'down');
    return isGood ? colors.primary : colors.error;
  }

  /// 根据趋势返回图标。
  IconData trendIcon() {
    return switch (trend) {
      'up' => Icons.trending_up_rounded,
      'down' => Icons.trending_down_rounded,
      _ => Icons.trending_flat_rounded,
    };
  }
}

/// 健康数据摘要，由 [HealthSummaryEngine] 计算产生。
///
/// 包含最多 5 个维度的指标和一个交叉洞察文案。
@immutable
class HealthSummary {
  const HealthSummary({
    this.weightMetric,
    this.recordMetric,
    this.careMetric,
    this.dietMetric,
    this.symptomMetric,
    this.crossInsight,
  });

  /// 体重趋势指标。
  final MetricItem? weightMetric;

  /// 记录频次指标。
  final MetricItem? recordMetric;

  /// 护理完成率指标。
  final MetricItem? careMetric;

  /// 饮食规律性指标。
  final MetricItem? dietMetric;

  /// 症状/异常指标。
  final MetricItem? symptomMetric;

  /// 基于多指标交叉分析生成的洞察文案。
  ///
  /// 如"体重持续上升且饮食增多，建议适当控制饮食量"。
  /// 数据不足时为 null。
  final String? crossInsight;

  /// 是否有任何可用数据。
  bool get hasAnyMetric =>
      weightMetric != null ||
      recordMetric != null ||
      careMetric != null ||
      dietMetric != null ||
      symptomMetric != null;

  /// 获取所有非空指标列表，用于 UI 渲染。
  List<MetricItem> get visibleMetrics => [
    ?weightMetric,
    ?recordMetric,
    ?careMetric,
    ?dietMetric,
    ?symptomMetric,
  ];
}

/// 摘要引擎的输入上下文。
///
/// 复用 [HealthTipsContext] 中已有的数据源，
/// 额外增加上月数据用于前后对比。
@immutable
class HealthSummaryContext {
  const HealthSummaryContext({
    required this.recentRecords,
    required this.previousRecords,
    required this.weightHistory,
    required this.weeklyCoverageRate,
    required this.previousWeekCoverageRate,
    required this.enabledPlanCount,
    required this.now,
  });

  /// 近 30 天的健康记录。
  final List<SummaryHealthRecord> recentRecords;

  /// 30–60 天前的健康记录（对比基准）。
  final List<SummaryHealthRecord> previousRecords;

  /// 全部体重记录（按时间正序）。
  final List<SummaryWeightRecord> weightHistory;

  /// 本周护理覆盖率 (0.0–1.0)。
  final double weeklyCoverageRate;

  /// 上周护理覆盖率 (0.0–1.0)。
  final double previousWeekCoverageRate;

  /// 已开启的护理计划数量。
  final int enabledPlanCount;

  /// 当前时间。
  final DateTime now;
}

/// 摘要引擎使用的健康记录精简模型。
@immutable
class SummaryHealthRecord {
  const SummaryHealthRecord({
    required this.type,
    required this.occurredAt,
    this.numericValue,
    this.unit,
    this.details = const {},
  });

  final String type;
  final DateTime occurredAt;
  final double? numericValue;
  final String? unit;
  final Map<String, String> details;
}

/// 摘要引擎使用的体重记录精简模型。
@immutable
class SummaryWeightRecord {
  const SummaryWeightRecord({
    required this.occurredAt,
    required this.value,
    this.unit = 'kg',
  });

  final DateTime occurredAt;
  final double value;
  final String? unit;
}
