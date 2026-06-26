import '../domain/health_summary.dart';

/// 健康数据摘要引擎。
///
/// 纯本地计算，将近 30 天数据与 30–60 天前数据对比，
/// 生成各维度指标和交叉洞察文案。
class HealthSummaryEngine {
  const HealthSummaryEngine();

  /// 生成健康摘要。
  HealthSummary generate(HealthSummaryContext ctx) {
    final weightMetric = _computeWeight(ctx);
    final recordMetric = _computeRecordCount(ctx);
    final careMetric = _computeCareCoverage(ctx);
    final dietMetric = _computeDietRegularity(ctx);
    final symptomMetric = _computeSymptoms(ctx);

    final crossInsight = _generateCrossInsight(
      ctx,
      weight: weightMetric,
      record: recordMetric,
      care: careMetric,
      diet: dietMetric,
      symptom: symptomMetric,
    );

    return HealthSummary(
      weightMetric: weightMetric,
      recordMetric: recordMetric,
      careMetric: careMetric,
      dietMetric: dietMetric,
      symptomMetric: symptomMetric,
      crossInsight: crossInsight,
    );
  }

  // ─── 体重趋势 ──────────────────────────────────────────────────────────────

  MetricItem? _computeWeight(HealthSummaryContext ctx) {
    final weights = ctx.weightHistory;
    if (weights.length < 2) return null;

    // 取最近一条和 30 天前最近的一条
    final latest = weights.last;
    final thirtyDaysAgo = ctx.now.subtract(const Duration(days: 30));

    // 找 30 天前最近的记录
    final previousWeights = weights
        .where((w) => w.occurredAt.isBefore(thirtyDaysAgo))
        .toList();
    if (previousWeights.isEmpty) {
      // 没有 30 天前的记录，尝试用前后半月对比
      return _computeWeightByHalves(ctx, weights);
    }

    final previous = previousWeights.last;
    final change = latest.value - previous.value;
    final changePercent = previous.value > 0
        ? (change / previous.value) * 100
        : 0.0;

    if (change.abs() < 0.05) {
      return MetricItem(
        label: '体重',
        value: '${latest.value.toStringAsFixed(1)} ${latest.unit ?? 'kg'}',
        comparison: '持平',
        trend: 'stable',
      );
    }

    final trend = change > 0 ? 'up' : 'down';
    final arrow = change > 0 ? '↑' : '↓';
    return MetricItem(
      label: '体重',
      value: '${latest.value.toStringAsFixed(1)} ${latest.unit ?? 'kg'}',
      comparison:
          '$arrow${change.abs().toStringAsFixed(1)} ${latest.unit ?? 'kg'} (${changePercent >= 0 ? '+' : ''}${changePercent.toStringAsFixed(1)}%)',
      trend: trend,
      // 体重上升通常为负向（肥胖风险），下降也可能有问题
      positiveTrend: change.abs() < latest.value * 0.02,
    );
  }

  MetricItem? _computeWeightByHalves(
    HealthSummaryContext ctx,
    List<SummaryWeightRecord> weights,
  ) {
    final midpoint = ctx.now.subtract(const Duration(days: 15));
    final firstHalf = weights
        .where((w) => w.occurredAt.isBefore(midpoint))
        .toList();
    final secondHalf = weights
        .where((w) => !w.occurredAt.isBefore(midpoint))
        .toList();

    if (firstHalf.isEmpty || secondHalf.isEmpty) return null;

    final firstAvg =
        firstHalf.map((w) => w.value).reduce((a, b) => a + b) /
        firstHalf.length;
    final secondAvg =
        secondHalf.map((w) => w.value).reduce((a, b) => a + b) /
        secondHalf.length;
    final change = secondAvg - firstAvg;

    if (change.abs() < 0.05) {
      return MetricItem(
        label: '体重',
        value:
            '${secondAvg.toStringAsFixed(1)} ${secondHalf.last.unit ?? 'kg'}',
        comparison: '持平',
        trend: 'stable',
      );
    }

    final trend = change > 0 ? 'up' : 'down';
    final arrow = change > 0 ? '↑' : '↓';
    return MetricItem(
      label: '体重',
      value: '${secondAvg.toStringAsFixed(1)} ${secondHalf.last.unit ?? 'kg'}',
      comparison:
          '$arrow${change.abs().toStringAsFixed(1)} ${secondHalf.last.unit ?? 'kg'}',
      trend: trend,
      positiveTrend: change.abs() < secondAvg * 0.02,
    );
  }

  // ─── 记录频次 ──────────────────────────────────────────────────────────────

  MetricItem? _computeRecordCount(HealthSummaryContext ctx) {
    final recentCount = ctx.recentRecords.length;
    final previousCount = ctx.previousRecords.length;

    if (recentCount == 0 && previousCount == 0) return null;

    final change = recentCount - previousCount;
    String trend;
    String comparison;

    if (change.abs() <= 1) {
      trend = 'stable';
      comparison = '与上月持平';
    } else if (change > 0) {
      trend = 'up';
      comparison = '+$change 条';
    } else {
      trend = 'down';
      comparison = '$change 条';
    }

    return MetricItem(
      label: '记录',
      value: '$recentCount 条',
      comparison: comparison,
      trend: trend,
      // 记录增多是正向（坚持记录）
      positiveTrend: change >= 0,
    );
  }

  // ─── 护理完成率 ──────────────────────────────────────────────────────────────

  MetricItem? _computeCareCoverage(HealthSummaryContext ctx) {
    if (ctx.enabledPlanCount == 0) return null;

    final currentRate = ctx.weeklyCoverageRate;
    final previousRate = ctx.previousWeekCoverageRate;
    final change = currentRate - previousRate;
    final currentPercent = (currentRate * 100).round();

    String trend;
    String comparison;

    if (change.abs() < 0.05) {
      trend = 'stable';
      comparison = '与上周持平';
    } else if (change > 0) {
      trend = 'up';
      comparison = '↑${(change * 100).round()}%';
    } else {
      trend = 'down';
      comparison = '↓${(change.abs() * 100).round()}%';
    }

    return MetricItem(
      label: '护理',
      value: '$currentPercent%',
      comparison: comparison,
      trend: trend,
      positiveTrend: change >= 0,
    );
  }

  // ─── 饮食规律性 ──────────────────────────────────────────────────────────────

  MetricItem? _computeDietRegularity(HealthSummaryContext ctx) {
    final recentFoodDays = _countDistinctDays(ctx.recentRecords, 'food');
    final previousFoodDays = _countDistinctDays(ctx.previousRecords, 'food');

    if (recentFoodDays == 0 && previousFoodDays == 0) return null;

    final change = recentFoodDays - previousFoodDays;
    String trend;
    String comparison;

    if (change.abs() <= 1) {
      trend = 'stable';
      comparison = '与上月持平';
    } else if (change > 0) {
      trend = 'up';
      comparison = '+$change 天';
    } else {
      trend = 'down';
      comparison = '$change 天';
    }

    return MetricItem(
      label: '饮食',
      value: '$recentFoodDays 天',
      comparison: comparison,
      trend: trend,
      positiveTrend: change >= 0,
    );
  }

  // ─── 症状/异常 ──────────────────────────────────────────────────────────────

  MetricItem? _computeSymptoms(HealthSummaryContext ctx) {
    const abnormalTypes = {'symptom', 'elimination'};
    final recentAbnormal = ctx.recentRecords
        .where((r) => abnormalTypes.contains(r.type))
        .length;
    final previousAbnormal = ctx.previousRecords
        .where((r) => abnormalTypes.contains(r.type))
        .length;

    if (recentAbnormal == 0 && previousAbnormal == 0) return null;

    final change = recentAbnormal - previousAbnormal;
    String trend;
    String comparison;

    if (change.abs() <= 1) {
      trend = 'stable';
      comparison = '与上月持平';
    } else if (change > 0) {
      trend = 'up';
      comparison = '+$change 次';
    } else {
      trend = 'down';
      comparison = '$change 次';
    }

    return MetricItem(
      label: '异常',
      value: '$recentAbnormal 次',
      comparison: comparison,
      trend: trend,
      // 症状增多是负向
      positiveTrend: change <= 0,
    );
  }

  // ─── 交叉洞察 ──────────────────────────────────────────────────────────────

  String? _generateCrossInsight(
    HealthSummaryContext ctx, {
    MetricItem? weight,
    MetricItem? record,
    MetricItem? care,
    MetricItem? diet,
    MetricItem? symptom,
  }) {
    final insights = <String>[];

    // 规则1：体重上升 + 饮食记录增多
    if (weight?.trend == 'up' && diet?.trend == 'up') {
      insights.add('体重上升且饮食记录增多，建议适当控制饮食量并增加运动。');
    }

    // 规则2：记录频次下降 + 症状增多
    if (record?.trend == 'down' && symptom?.trend == 'up') {
      insights.add('健康记录减少但异常增多，建议加强日常观察和记录。');
    }

    // 规则3：护理覆盖率下降 + 体重波动
    if (care?.trend == 'down' && weight != null && weight.trend != 'stable') {
      insights.add('护理完成率下降伴随体重变化，建议坚持护理计划。');
    }

    // 规则4：饮食不规律 + 排泄异常
    if (diet?.trend == 'down' && symptom?.trend == 'up') {
      insights.add('饮食记录减少且异常增多，饮食不规律可能影响消化健康。');
    }

    // 规则5：多类症状聚集（30天内≥3种不同类型异常）
    final symptomTypes = ctx.recentRecords
        .where((r) => r.type == 'symptom')
        .map((r) => r.type)
        .toSet();
    final eliminationAbnormal = ctx.recentRecords.where((r) {
      if (r.type != 'elimination') return false;
      final stool = r.details['stool'] ?? '';
      final urine = r.details['urine'] ?? '';
      return stool.contains('腹泻') ||
          stool.contains('带血') ||
          urine.contains('带血');
    }).length;
    if (symptomTypes.length >= 2 && eliminationAbnormal > 0) {
      insights.add('多系统出现异常信号，建议做一次系统性体检排查。');
    }

    // 规刡6：所有指标都稳定/正向 → 鼓励（但必须有数据）
    if (insights.isEmpty &&
        (weight != null || record != null || care != null) &&
        (weight?.trend == 'stable' || weight == null) &&
        (record?.trend != 'down') &&
        (care?.trend != 'down')) {
      insights.add('各项健康指标保持稳定，继续保持当前的护理节奏。');
    }

    if (insights.isEmpty) return null;

    // 返回最相关的一条（优先级：多症状 > 体重相关 > 其他）
    return insights.first;
  }

  // ─── 工具方法 ──────────────────────────────────────────────────────────────

  int _countDistinctDays(List<SummaryHealthRecord> records, String type) {
    final filtered = records.where((r) => r.type == type);
    final days = filtered
        .map(
          (r) =>
              DateTime(r.occurredAt.year, r.occurredAt.month, r.occurredAt.day),
        )
        .toSet();
    return days.length;
  }
}
