import 'package:flutter/material.dart';

import 'health_tip.dart';

/// 数据洞察子生成器。
///
/// 分析 [HealthTipsContext] 中的健康记录，发现趋势和异常，
/// 输出对应的 [HealthTip] 列表。
class DataInsightTipsGenerator {
  const DataInsightTipsGenerator();

  static const _digestiveKeywords = {
    '吐',
    '呕',
    '腹泻',
    '软便',
    '便血',
    '食欲',
    '肠胃',
    '消化',
  };

  List<HealthTip> generate(HealthTipsContext ctx) {
    final tips = <HealthTip>[];

    tips.addAll(_multiSignalAlerts(ctx));
    tips.addAll(_weightTrend(ctx));
    tips.addAll(_dietRegularity(ctx));
    tips.addAll(_eliminationAlert(ctx));
    tips.addAll(_symptomFrequency(ctx));
    tips.addAll(_waterIntakeAlert(ctx));
    tips.addAll(_coverageAlert(ctx));
    tips.addAll(_recordGap(ctx));

    return tips;
  }

  // ─── 多维组合信号 ──────────────────────────────────────────────────────────

  List<HealthTip> _multiSignalAlerts(HealthTipsContext ctx) {
    final fourteenDaysAgo = ctx.now.subtract(const Duration(days: 14));
    final recent = ctx.recentRecords
        .where((r) => !r.occurredAt.isBefore(fourteenDaysAgo))
        .toList();

    final appetiteAlerts = recent.where((r) => r.type == 'food').where((r) {
      final appetite = r.details['appetite'] ?? '';
      return appetite.contains('少吃') ||
          appetite.contains('没吃') ||
          appetite.contains('观察');
    }).length;
    final stoolAlerts = recent.where((r) => r.type == 'elimination').where((r) {
      final stool = r.details['stool'] ?? '';
      return stool.contains('腹泻') ||
          stool.contains('偏软') ||
          stool.contains('带血') ||
          stool.contains('黏液');
    }).length;
    final digestiveSymptoms = recent.where((r) => r.type == 'symptom').where((
      r,
    ) {
      final text = '${r.title} ${r.note} ${r.details.values.join(' ')}';
      return _digestiveKeywords.any(text.contains);
    }).length;

    final tips = <HealthTip>[];
    final changedDimensions = [
      appetiteAlerts > 0,
      stoolAlerts > 0,
      digestiveSymptoms > 0,
    ].where((changed) => changed).length;

    if (changedDimensions >= 2) {
      tips.add(
        HealthTip(
          id: 'insight_digestive_cluster',
          category: 'data_insight',
          priority: stoolAlerts >= 2 || digestiveSymptoms >= 2
              ? 'high'
              : 'medium',
          icon: Icons.medical_information_outlined,
          title: '饮食和消化信号有关联',
          body: '近14天同时出现食欲、排泄或消化症状变化。建议回看是否换粮、误食或加餐，并连续记录精神状态和便便情况。',
          reason:
              '食欲异常 $appetiteAlerts 次，便便异常 $stoolAlerts 次，消化相关症状 $digestiveSymptoms 次。',
        ),
      );
    }

    final waterAlerts = recent.where((r) => r.type == 'water').where((r) {
      final pattern = r.details['pattern'] ?? '';
      return pattern.contains('偏多') ||
          pattern.contains('偏少') ||
          pattern.contains('突然') ||
          pattern.contains('几乎');
    }).length;
    final urineAlerts = recent.where((r) => r.type == 'elimination').where((r) {
      final urine = r.details['urine'] ?? '';
      return urine.contains('频繁') ||
          urine.contains('很少') ||
          urine.contains('带血') ||
          urine.contains('偏黄');
    }).length;

    if (waterAlerts > 0 && urineAlerts > 0) {
      tips.add(
        HealthTip(
          id: 'insight_water_urine_cluster',
          category: 'data_insight',
          priority: 'high',
          icon: Icons.water_drop_outlined,
          title: '饮水和排尿变化需要一起看',
          body: '饮水状态和排尿状态近期都出现变化。建议记录每日饮水量、尿频和尿色，若持续或带血应及时咨询兽医。',
          reason: '近14天饮水异常 $waterAlerts 次，排尿异常 $urineAlerts 次。',
        ),
      );
    }

    tips.addAll(_positivePattern(ctx, recent));
    return tips;
  }

  List<HealthTip> _positivePattern(
    HealthTipsContext ctx,
    List<TipsHealthRecord> recent,
  ) {
    if (recent.length < 6 || ctx.coverageRate < 0.8) return const [];
    final hasProblem = recent.any((r) {
      if (r.type == 'symptom') return true;
      if (r.type != 'elimination') return false;
      final stool = r.details['stool'] ?? '';
      final urine = r.details['urine'] ?? '';
      return stool.contains('腹泻') ||
          stool.contains('血') ||
          urine.contains('血') ||
          urine.contains('频繁');
    });
    if (hasProblem) return const [];

    return const [
      HealthTip(
        id: 'insight_positive_routine',
        category: 'data_insight',
        priority: 'low',
        icon: Icons.favorite_border_rounded,
        title: '近期护理节奏保持得不错',
        body: '最近记录和护理都在持续积累，暂未看到明显异常信号。继续保持这种轻量记录，就能更早发现变化。',
        reason: '基于近14天记录和本周护理完成情况。',
      ),
    ];
  }

  // ─── 体重趋势 ──────────────────────────────────────────────────────────────

  List<HealthTip> _weightTrend(HealthTipsContext ctx) {
    final weights = ctx.weightHistory;
    if (weights.length < 3) return const [];

    // 取最近 5 条做简单线性回归
    final recent = weights.length > 5
        ? weights.sublist(weights.length - 5)
        : weights;
    if (recent.length < 3) return const [];

    final n = recent.length.toDouble();
    var sumX = 0.0, sumY = 0.0, sumXY = 0.0, sumXX = 0.0;
    for (var i = 0; i < recent.length; i++) {
      final x = i.toDouble();
      final y = recent[i].value;
      sumX += x;
      sumY += y;
      sumXY += x * y;
      sumXX += x * x;
    }
    final denominator = n * sumXX - sumX * sumX;
    if (denominator.abs() < 1e-9) return const [];

    final slope = (n * sumXY - sumX * sumY) / denominator;

    // 斜率阈值：体重变化超过初始体重 3% / 记录点 才视为显著
    final baseWeight = recent.first.value;
    final threshold = baseWeight * 0.03;
    if (slope.abs() < threshold) return const [];

    final direction = slope > 0 ? '上升' : '下降';
    final firstWeight = recent.first.value.toStringAsFixed(1);
    final lastWeight = recent.last.value.toStringAsFixed(1);

    return [
      HealthTip(
        id: 'insight_weight_${slope > 0 ? 'up' : 'down'}',
        category: 'data_insight',
        priority: slope.abs() > threshold * 2 ? 'high' : 'medium',
        icon: slope > 0
            ? Icons.trending_up_rounded
            : Icons.trending_down_rounded,
        title: '体重持续$direction值得关注',
        body:
            '最近几次体重记录呈$direction趋势（$firstWeight → $lastWeight ${recent.first.unit ?? 'kg'}）。'
            '${slope > 0 ? '如果持续增重，建议适当控制饮食量并增加运动。' : '如果持续减重，需要关注是否食欲减退或有消化问题。'}',
        reason: '基于最近 ${recent.length} 条体重记录的趋势分析。',
      ),
    ];
  }

  // ─── 饮食规律 ──────────────────────────────────────────────────────────────

  List<HealthTip> _dietRegularity(HealthTipsContext ctx) {
    final now = ctx.now;
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    final foodRecords = ctx.recentRecords
        .where((r) => r.type == 'food' && r.occurredAt.isAfter(sevenDaysAgo))
        .toList();

    if (foodRecords.length >= 3 ||
        foodRecords.isEmpty && ctx.recentRecords.isEmpty) {
      return const [];
    }

    // 有其他记录但饮食记录少于 3 条
    return [
      const HealthTip(
        id: 'insight_diet_sparse',
        category: 'data_insight',
        priority: 'low',
        icon: Icons.restaurant_outlined,
        title: '饮食记录偏少',
        body: '最近7天的喂食记录不足3条。保持规律的饮食记录可以帮助观察食欲变化，也是判断健康状况的重要参考。',
        reason: '最近7天仅有少量喂食记录，无法有效评估饮食规律。',
      ),
    ];
  }

  // ─── 排泄异常 ──────────────────────────────────────────────────────────────

  List<HealthTip> _eliminationAlert(HealthTipsContext ctx) {
    final eliminations = ctx.recentRecords.where(
      (r) => r.type == 'elimination',
    );
    final abnormalStool = eliminations.where((r) {
      final stool = r.details['stool'] ?? '';
      return stool.contains('腹泻') ||
          stool.contains('带血') ||
          stool.contains('偏软');
    });
    final abnormalUrine = eliminations.where((r) {
      final urine = r.details['urine'] ?? '';
      return urine.contains('带血') ||
          urine.contains('频繁') ||
          urine.contains('很少');
    });

    if (abnormalStool.isEmpty && abnormalUrine.isEmpty) return const [];

    final tips = <HealthTip>[];

    if (abnormalStool.isNotEmpty) {
      tips.add(
        HealthTip(
          id: 'insight_stool_abnormal',
          category: 'data_insight',
          priority:
              abnormalStool.any((r) {
                final s = r.details['stool'] ?? '';
                return s.contains('带血');
              })
              ? 'high'
              : 'medium',
          icon: Icons.warning_amber_rounded,
          title: '便便状态需要留意',
          body:
              '最近有排泄记录显示便便异常（${abnormalStool.length} 次）。'
              '${abnormalStool.any((r) => (r.details['stool'] ?? '').contains('带血')) ? '发现带血建议尽快就医排查。' : '如果持续偏软或腹泻，建议关注饮食变化，必要时就医。'}',
          reason: '基于最近30天的排泄记录分析。',
        ),
      );
    }

    if (abnormalUrine.isNotEmpty) {
      tips.add(
        HealthTip(
          id: 'insight_urine_abnormal',
          category: 'data_insight',
          priority: 'medium',
          icon: Icons.water_drop_outlined,
          title: '排尿状态值得关注',
          body:
              '最近有排尿异常记录（${abnormalUrine.length} 次），可能与泌尿系统问题或饮水量变化有关。建议持续观察并记录，必要时咨询兽医。',
          reason: '基于最近30天的排泄记录分析。',
        ),
      );
    }

    return tips;
  }

  // ─── 症状频率 ──────────────────────────────────────────────────────────────

  List<HealthTip> _symptomFrequency(HealthTipsContext ctx) {
    final symptoms = ctx.recentRecords
        .where((r) => r.type == 'symptom')
        .toList();
    if (symptoms.length < 3) return const [];

    return [
      HealthTip(
        id: 'insight_symptom_frequent',
        category: 'data_insight',
        priority: symptoms.length >= 5 ? 'high' : 'medium',
        icon: Icons.healing_outlined,
        title: '近期症状记录较多',
        body:
            '最近30天记录了 ${symptoms.length} 次症状观察。如果同一问题反复出现，建议带狗狗做一次系统检查，排查潜在原因。',
        reason: '30天内症状记录达到 ${symptoms.length} 次，高于常规频率。',
      ),
    ];
  }

  // ─── 饮水量变化 ────────────────────────────────────────────────────────────

  List<HealthTip> _waterIntakeAlert(HealthTipsContext ctx) {
    final waterRecords = ctx.recentRecords
        .where((r) => r.type == 'water' && r.numericValue != null)
        .toList();

    if (waterRecords.length < 4) return const [];

    // 分前半段和后半段比较平均饮水量
    final mid = waterRecords.length ~/ 2;
    final firstHalf = waterRecords.sublist(0, mid);
    final secondHalf = waterRecords.sublist(mid);

    if (firstHalf.isEmpty || secondHalf.isEmpty) return const [];

    final firstAvg =
        firstHalf.map((r) => r.numericValue!).reduce((a, b) => a + b) /
        firstHalf.length;
    final secondAvg =
        secondHalf.map((r) => r.numericValue!).reduce((a, b) => a + b) /
        secondHalf.length;

    if (firstAvg < 1) return const []; // 数据太少，跳过
    final changeRate = (secondAvg - firstAvg) / firstAvg;

    if (changeRate.abs() < 0.3) return const []; // 变化不到30%，不提示

    final direction = changeRate > 0 ? '增多' : '减少';
    return [
      HealthTip(
        id: 'insight_water_change',
        category: 'data_insight',
        priority: changeRate.abs() > 0.5 ? 'high' : 'medium',
        icon: Icons.water_drop_rounded,
        title: '饮水量有明显$direction',
        body:
            '对比最近30天的前后两段记录，平均饮水量$direction了约 ${(changeRate.abs() * 100).toStringAsFixed(0)}%。'
            '${changeRate > 0 ? '饮水量突然增多可能与肾脏或代谢问题有关。' : '饮水量减少需要关注是否脱水，尤其在炎热天气。'}建议持续记录并咨询兽医。',
        reason: '基于最近30天饮水记录的前后对比分析。',
      ),
    ];
  }

  // ─── 护理覆盖率 ────────────────────────────────────────────────────────────

  List<HealthTip> _coverageAlert(HealthTipsContext ctx) {
    if (ctx.enabledPlanCount == 0) return const [];
    if (ctx.coverageRate >= 0.7) return const [];

    return [
      HealthTip(
        id: 'insight_coverage_low',
        category: 'data_insight',
        priority: ctx.coverageRate < 0.5 ? 'medium' : 'low',
        icon: Icons.emoji_events_outlined,
        title: '本周护理完成率偏低',
        body:
            '本周护理覆盖率约 ${(ctx.coverageRate * 100).toStringAsFixed(0)}%，还有提升空间。坚持完成护理计划对狗狗的长期健康很有帮助，哪怕每次只做一点也好。',
        reason: '基于本周护理计划完成情况计算。',
      ),
    ];
  }

  // ─── 记录空白 ──────────────────────────────────────────────────────────────

  List<HealthTip> _recordGap(HealthTipsContext ctx) {
    if (ctx.recentRecords.isEmpty) return const [];

    // 找到最新的记录时间
    final latest = ctx.recentRecords
        .map((r) => r.occurredAt)
        .reduce((a, b) => a.isAfter(b) ? a : b);

    final gapDays = ctx.now.difference(latest).inDays;
    if (gapDays < 7) return const [];

    return [
      HealthTip(
        id: 'insight_record_gap',
        category: 'data_insight',
        priority: 'low',
        icon: Icons.timeline_rounded,
        title: '好久没有记录啦',
        body: '距离上次健康记录已经 $gapDays 天了。连续记录越久，健康趋势分析越准确。哪怕记一条体重或饮水量也很有价值。',
        reason: '最近一条健康记录距今已超过7天。',
      ),
    ];
  }
}
