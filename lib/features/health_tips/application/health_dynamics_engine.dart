import '../domain/health_dynamics.dart';
import '../domain/health_summary.dart';
import '../domain/health_tip.dart';

class HealthDynamicsEngine {
  const HealthDynamicsEngine();

  HealthDynamics generate({
    required HealthTipsContext tipsContext,
    required HealthSummary summary,
    required List<HealthTip> recommendations,
  }) {
    final insights = <HealthDynamicInsight>[
      ..._weightInsights(tipsContext),
      ..._dietDigestiveInsights(tipsContext),
      ..._waterInsights(tipsContext),
      ..._symptomInsights(tipsContext),
      ..._careInsights(tipsContext),
      ..._preventiveInsights(tipsContext),
      ..._dataQualityInsights(tipsContext),
      ..._positiveInsights(tipsContext, summary),
    ];

    final deduped = <String, HealthDynamicInsight>{};
    for (final insight in insights) {
      final previous = deduped[insight.id];
      if (previous == null || insight.score > previous.score) {
        deduped[insight.id] = insight;
      }
    }

    final sorted = deduped.values.toList()
      ..sort((a, b) {
        final score = b.score.compareTo(a.score);
        if (score != 0) return score;
        return b.occurredAt.compareTo(a.occurredAt);
      });

    return HealthDynamics(
      petName: tipsContext.pet.name,
      generatedAt: tipsContext.now,
      summary: summary,
      insights: sorted,
      recommendations: recommendations,
    );
  }

  List<HealthDynamicInsight> _weightInsights(HealthTipsContext ctx) {
    final weights = ctx.weightHistory;
    if (weights.length < 2) return const [];

    final latest = weights.last;
    final baseline = weights.reversed.firstWhere(
      (item) =>
          latest.occurredAt.difference(item.occurredAt).inDays >= 21 &&
          item.value > 0,
      orElse: () => weights.first,
    );
    if (baseline == latest || baseline.value <= 0) return const [];

    final change = latest.value - baseline.value;
    final percent = change / baseline.value * 100;
    if (percent.abs() < 2) {
      return [
        HealthDynamicInsight(
          id: 'weight_stable',
          category: 'weight',
          tone: 'positive',
          title: '体重保持稳定',
          body:
              '${ctx.pet.name} 最近体重波动约 ${percent.abs().toStringAsFixed(1)}%，整体比较平稳。',
          suggestion: '继续在相似时间和状态下称重，趋势会更可靠。',
          occurredAt: latest.occurredAt,
          score: 18,
          evidence: [
            '${baseline.value.toStringAsFixed(1)} ${baseline.unit ?? 'kg'}',
            '${latest.value.toStringAsFixed(1)} ${latest.unit ?? 'kg'}',
          ],
        ),
      ];
    }

    final appetiteAlerts = _recordsSince(ctx, 21)
        .where((r) => r.type == 'food')
        .where((r) => _isBadAppetite(r.details['appetite']))
        .length;
    final symptomAlerts = _recordsSince(
      ctx,
      21,
    ).where((r) => r.type == 'symptom').length;
    final isDown = change < 0;
    final isHigh = percent.abs() >= 8 || isDown && appetiteAlerts >= 2;

    return [
      HealthDynamicInsight(
        id: isDown ? 'weight_loss_pattern' : 'weight_gain_pattern',
        category: 'weight',
        tone: isHigh ? 'alert' : 'watch',
        title: isDown ? '体重下降需要结合食欲观察' : '体重上升趋势比较明显',
        body:
            '从 ${baseline.value.toStringAsFixed(1)} 到 ${latest.value.toStringAsFixed(1)} ${latest.unit ?? 'kg'}，变化约 ${percent.toStringAsFixed(1)}%。'
            '${isDown && appetiteAlerts > 0 ? '同期还有 $appetiteAlerts 次食欲异常记录。' : ''}',
        suggestion: isDown
            ? '建议连续记录食欲、便便和精神状态；若持续下降或伴随精神差、呕吐、腹泻，应咨询兽医。'
            : '建议核对喂食量、零食和运动时长，必要时和兽医确认目标体重。家里无法准确判断体况时可补充体况评分记录。',
        occurredAt: latest.occurredAt,
        score: isHigh ? 92 : 70,
        evidence: [
          '${baseline.occurredAt.month}/${baseline.occurredAt.day}: ${baseline.value.toStringAsFixed(1)}',
          '${latest.occurredAt.month}/${latest.occurredAt.day}: ${latest.value.toStringAsFixed(1)}',
          if (appetiteAlerts > 0) '食欲异常 $appetiteAlerts 次',
          if (symptomAlerts > 0) '症状记录 $symptomAlerts 次',
        ],
      ),
    ];
  }

  List<HealthDynamicInsight> _dietDigestiveInsights(HealthTipsContext ctx) {
    final records = _recordsSince(ctx, 14);
    final appetiteAlerts = records
        .where((r) => r.type == 'food')
        .where((r) => _isBadAppetite(r.details['appetite']))
        .toList();
    final stoolAlerts = records
        .where((r) => r.type == 'elimination')
        .where((r) => _isAbnormalStool(r.details['stool']))
        .toList();
    final giSymptoms = records
        .where((r) => r.type == 'symptom')
        .where((r) => _containsAny(_recordText(r), _giKeywords))
        .toList();

    if (appetiteAlerts.isEmpty && stoolAlerts.isEmpty && giSymptoms.isEmpty) {
      return const [];
    }

    final clustered =
        [
          appetiteAlerts,
          stoolAlerts,
          giSymptoms,
        ].where((items) => items.isNotEmpty).length >=
        2;
    final hasBlood = stoolAlerts.any(
      (r) => (r.details['stool'] ?? '').contains('血'),
    );

    return [
      HealthDynamicInsight(
        id: 'diet_digestive_cluster',
        category: 'diet',
        tone: clustered || hasBlood ? 'alert' : 'watch',
        title: clustered ? '饮食和消化信号同时变化' : '近期有消化相关信号',
        body:
            '近14天里，食欲异常 ${appetiteAlerts.length} 次、便便异常 ${stoolAlerts.length} 次、消化相关症状 ${giSymptoms.length} 次。',
        suggestion: hasBlood
            ? '记录带血、腹泻次数和精神状态，建议尽快咨询兽医。'
            : '建议回看是否换粮、加餐或误食；若连续出现、精神变差或体重下降，及时就医排查。',
        occurredAt: _latestOf([
          ...appetiteAlerts,
          ...stoolAlerts,
          ...giSymptoms,
        ]),
        score: clustered || hasBlood ? 90 : 64,
        evidence: [
          if (appetiteAlerts.isNotEmpty) '食欲异常 ${appetiteAlerts.length} 次',
          if (stoolAlerts.isNotEmpty) '便便异常 ${stoolAlerts.length} 次',
          if (giSymptoms.isNotEmpty) '相关症状 ${giSymptoms.length} 次',
        ],
      ),
    ];
  }

  List<HealthDynamicInsight> _waterInsights(HealthTipsContext ctx) {
    final records = _recordsSince(
      ctx,
      30,
    ).where((r) => r.type == 'water').toList();
    if (records.isEmpty) return const [];

    final patternAlerts = records
        .where((r) => _isAbnormalWater(r.details['pattern']))
        .toList();
    final numeric = records.where((r) => r.numericValue != null).toList()
      ..sort((a, b) => a.occurredAt.compareTo(b.occurredAt));

    if (numeric.length >= 4) {
      final mid = numeric.length ~/ 2;
      final first = _average(numeric.take(mid).map((r) => r.numericValue!));
      final second = _average(numeric.skip(mid).map((r) => r.numericValue!));
      if (first > 0) {
        final change = (second - first) / first;
        if (change.abs() >= 0.3) {
          final up = change > 0;
          return [
            HealthDynamicInsight(
              id: 'water_numeric_shift',
              category: 'water',
              tone: change.abs() >= 0.5 ? 'alert' : 'watch',
              title: up ? '饮水量明显增多' : '饮水量明显减少',
              body: '近30天前后两段平均饮水量变化约 ${(change.abs() * 100).round()}%。',
              suggestion: up
                  ? '饮水突然增多可能和天气、运动、饮食或代谢/泌尿问题有关，建议配合排尿和精神状态一起记录。'
                  : '饮水减少时要留意脱水、食欲和排尿变化，炎热天气尤其需要补充观察。',
              occurredAt: numeric.last.occurredAt,
              score: change.abs() >= 0.5 ? 82 : 62,
              evidence: [
                '前段均值 ${first.toStringAsFixed(0)}',
                '后段均值 ${second.toStringAsFixed(0)}',
              ],
            ),
          ];
        }
      }
    }

    if (patternAlerts.length >= 2) {
      return [
        HealthDynamicInsight(
          id: 'water_pattern_alert',
          category: 'water',
          tone: 'watch',
          title: '饮水状态有多次异常',
          body: '近30天记录了 ${patternAlerts.length} 次“偏多/偏少/突然增多/几乎不喝”。',
          suggestion: '建议连续记录饮水量和排尿状态，帮助判断是天气运动影响还是需要进一步检查。',
          occurredAt: _latestOf(patternAlerts),
          score: 58,
          evidence: ['饮水异常 ${patternAlerts.length} 次'],
        ),
      ];
    }

    return const [];
  }

  List<HealthDynamicInsight> _symptomInsights(HealthTipsContext ctx) {
    final symptoms = _recordsSince(
      ctx,
      30,
    ).where((r) => r.type == 'symptom').toList();
    if (symptoms.isEmpty) return const [];

    final severe = symptoms.where((r) {
      final status = r.details['status'] ?? '';
      final duration = r.details['duration'] ?? '';
      return (r.severity ?? 0) >= 4 ||
          status.contains('加重') ||
          status.contains('就医') ||
          duration.contains('超过') ||
          duration.contains('反复');
    }).toList();

    final names = <String, int>{};
    for (final item in symptoms) {
      final name = (item.details['symptomName'] ?? item.title).trim();
      if (name.isEmpty) continue;
      names[name] = (names[name] ?? 0) + 1;
    }
    final repeated = names.entries.where((entry) => entry.value >= 2).toList();

    if (symptoms.length < 3 && severe.isEmpty && repeated.isEmpty) {
      return const [];
    }

    return [
      HealthDynamicInsight(
        id: 'symptom_pattern',
        category: 'symptom',
        tone: severe.isNotEmpty ? 'alert' : 'watch',
        title: severe.isNotEmpty ? '有需要优先处理的症状记录' : '近期症状记录偏多',
        body:
            '近30天症状记录 ${symptoms.length} 次'
            '${repeated.isNotEmpty ? '，其中“${repeated.first.key}”反复出现 ${repeated.first.value} 次' : ''}。',
        suggestion: severe.isNotEmpty
            ? '建议把症状持续时间、严重程度、饮食排泄和体重变化整理给兽医参考。'
            : '如果同一症状继续出现，可以用照片、视频和时间点补充记录，方便判断变化。',
        occurredAt: _latestOf(symptoms),
        score: severe.isNotEmpty ? 88 : 66,
        evidence: [
          '症状 ${symptoms.length} 次',
          if (severe.isNotEmpty) '高严重度/持续症状 ${severe.length} 次',
          if (repeated.isNotEmpty) '反复：${repeated.first.key}',
        ],
      ),
    ];
  }

  List<HealthDynamicInsight> _careInsights(HealthTipsContext ctx) {
    if (ctx.enabledPlanCount == 0) return const [];
    final rate = ctx.coverageRate;
    if (rate >= 0.9) {
      return [
        HealthDynamicInsight(
          id: 'care_excellent',
          category: 'care',
          tone: 'positive',
          title: '护理计划完成得很稳',
          body: '本周护理覆盖率约 ${(rate * 100).round()}%，节奏保持得不错。',
          suggestion: '继续保持固定护理节奏，后续趋势判断会更可靠。',
          occurredAt: ctx.now,
          score: 26,
          evidence: ['护理覆盖率 ${(rate * 100).round()}%'],
        ),
      ];
    }
    if (rate < 0.7) {
      return [
        HealthDynamicInsight(
          id: 'care_low',
          category: 'care',
          tone: rate < 0.5 ? 'watch' : 'info',
          title: '本周护理节奏有些松',
          body:
              '已开启 ${ctx.enabledPlanCount} 个护理计划，本周覆盖率约 ${(rate * 100).round()}%。',
          suggestion: '可以优先补齐驱虫、牙齿、梳毛或运动这类高收益项目，先恢复最容易坚持的一项。',
          occurredAt: ctx.now,
          score: rate < 0.5 ? 56 : 42,
          evidence: ['护理覆盖率 ${(rate * 100).round()}%'],
        ),
      ];
    }
    return const [];
  }

  List<HealthDynamicInsight> _preventiveInsights(HealthTipsContext ctx) {
    final insights = <HealthDynamicInsight>[];
    final vaccine = _latestRecord(ctx, 'vaccine');
    if (vaccine == null ||
        ctx.now.difference(vaccine.occurredAt).inDays > 365) {
      insights.add(
        HealthDynamicInsight(
          id: 'preventive_vaccine_check',
          category: 'preventive',
          tone: 'info',
          title: '可以核对一下疫苗档案',
          body: vaccine == null ? '当前没有看到疫苗记录。' : '最近一条疫苗记录距今已超过一年。',
          suggestion: '不同地区、年龄和生活方式对应的免疫计划不同，建议按疫苗本或兽医建议校准记录。',
          occurredAt: vaccine?.occurredAt ?? ctx.now,
          score: 34,
          evidence: [
            vaccine == null
                ? '无疫苗记录'
                : '上次疫苗 ${_daysAgo(ctx, vaccine.occurredAt)} 天前',
          ],
        ),
      );
    }

    final deworming = _latestRecord(ctx, 'deworming');
    if (!ctx.hasEnabledDewormingPlan &&
        (deworming == null ||
            ctx.now.difference(deworming.occurredAt).inDays > 90)) {
      insights.add(
        HealthDynamicInsight(
          id: 'preventive_deworming_check',
          category: 'preventive',
          tone: 'info',
          title: '驱虫节奏建议补充成计划',
          body: deworming == null ? '当前没有看到近期驱虫记录或计划。' : '最近一条驱虫记录距今已超过90天。',
          suggestion: '驱虫频率与外出、饮食和当地寄生虫风险有关，可以把兽医建议录成护理计划。',
          occurredAt: deworming?.occurredAt ?? ctx.now,
          score: 36,
          evidence: [
            deworming == null
                ? '无驱虫计划'
                : '上次驱虫 ${_daysAgo(ctx, deworming.occurredAt)} 天前',
          ],
        ),
      );
    }

    return insights;
  }

  List<HealthDynamicInsight> _dataQualityInsights(HealthTipsContext ctx) {
    final insights = <HealthDynamicInsight>[];
    final lastWeight = ctx.weightHistory.isEmpty
        ? null
        : ctx.weightHistory.last;
    if (lastWeight == null ||
        ctx.now.difference(lastWeight.occurredAt).inDays > 30) {
      insights.add(
        HealthDynamicInsight(
          id: 'data_quality_weight_missing',
          category: 'data_quality',
          tone: 'info',
          title: '体重趋势还可以更准确',
          body: lastWeight == null ? '目前还没有体重记录。' : '最近30天没有新的体重记录。',
          suggestion: '建议每1到2周在相似条件下称一次体重，趋势会比单点数值更有参考价值。',
          occurredAt: lastWeight?.occurredAt ?? ctx.now,
          score: 28,
          evidence: [
            lastWeight == null
                ? '无体重记录'
                : '上次称重 ${_daysAgo(ctx, lastWeight.occurredAt)} 天前',
          ],
        ),
      );
    }
    return insights;
  }

  List<HealthDynamicInsight> _positiveInsights(
    HealthTipsContext ctx,
    HealthSummary summary,
  ) {
    final recentSymptoms = _recordsSince(ctx, 30)
        .where((r) => r.type == 'symptom' || r.type == 'elimination')
        .where((r) => _isProblemRecord(r))
        .length;

    if (recentSymptoms == 0 &&
        (summary.weightMetric?.trend == 'stable' ||
            summary.weightMetric == null) &&
        ctx.recentRecords.length >= 5) {
      return [
        HealthDynamicInsight(
          id: 'positive_routine',
          category: 'positive',
          tone: 'positive',
          title: '近期状态整体平稳',
          body: '近30天没有明显异常记录，记录节奏也在持续积累。',
          suggestion: '继续保持饮食、体重、护理和异常观察的轻量记录，这就是长期健康管理的底座。',
          occurredAt: ctx.now,
          score: 24,
          evidence: ['近30天记录 ${ctx.recentRecords.length} 条'],
        ),
      ];
    }
    return const [];
  }

  List<TipsHealthRecord> _recordsSince(HealthTipsContext ctx, int days) {
    final from = ctx.now.subtract(Duration(days: days));
    return ctx.recentRecords
        .where((record) => !record.occurredAt.isBefore(from))
        .toList(growable: false);
  }

  TipsHealthRecord? _latestRecord(HealthTipsContext ctx, String type) {
    final records = ctx.recentRecords.where((r) => r.type == type).toList()
      ..sort((a, b) => b.occurredAt.compareTo(a.occurredAt));
    return records.firstOrNull;
  }

  bool _isProblemRecord(TipsHealthRecord record) {
    if (record.type == 'symptom') return true;
    if (record.type != 'elimination') return false;
    return _isAbnormalStool(record.details['stool']) ||
        _isAbnormalUrine(record.details['urine']);
  }

  bool _isBadAppetite(String? value) =>
      value != null &&
      (value.contains('少吃') || value.contains('没吃') || value.contains('观察'));

  bool _isAbnormalStool(String? value) =>
      value != null &&
      (value.contains('偏软') ||
          value.contains('腹泻') ||
          value.contains('偏硬') ||
          value.contains('血') ||
          value.contains('黏液'));

  bool _isAbnormalUrine(String? value) =>
      value != null &&
      (value.contains('频繁') ||
          value.contains('很少') ||
          value.contains('血') ||
          value.contains('偏黄'));

  bool _isAbnormalWater(String? value) =>
      value != null &&
      (value.contains('偏多') ||
          value.contains('偏少') ||
          value.contains('突然') ||
          value.contains('几乎'));

  bool _containsAny(String text, Set<String> keywords) =>
      keywords.any((keyword) => text.contains(keyword));

  String _recordText(TipsHealthRecord record) =>
      '${record.title} ${record.note} ${record.details.values.join(' ')}';

  DateTime _latestOf(List<TipsHealthRecord> records) => records
      .map((record) => record.occurredAt)
      .reduce((a, b) => a.isAfter(b) ? a : b);

  double _average(Iterable<double> values) {
    final list = values.toList();
    if (list.isEmpty) return 0;
    return list.reduce((a, b) => a + b) / list.length;
  }

  int _daysAgo(HealthTipsContext ctx, DateTime occurredAt) =>
      ctx.now.difference(occurredAt).inDays;

  static const _giKeywords = {'吐', '呕', '腹泻', '软便', '便血', '食欲', '肠胃', '消化'};
}
