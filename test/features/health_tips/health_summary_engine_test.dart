import 'package:flutter_test/flutter_test.dart';
import 'package:pet_health/features/health_tips/application/health_summary_engine.dart';
import 'package:pet_health/features/health_tips/domain/health_summary.dart';

const _engine = HealthSummaryEngine();

HealthSummaryContext _ctx({
  List<SummaryHealthRecord> recentRecords = const [],
  List<SummaryHealthRecord> previousRecords = const [],
  List<SummaryWeightRecord> weightHistory = const [],
  double weeklyCoverageRate = 1.0,
  double previousWeekCoverageRate = 1.0,
  int enabledPlanCount = 0,
  DateTime? now,
}) {
  return HealthSummaryContext(
    recentRecords: recentRecords,
    previousRecords: previousRecords,
    weightHistory: weightHistory,
    weeklyCoverageRate: weeklyCoverageRate,
    previousWeekCoverageRate: previousWeekCoverageRate,
    enabledPlanCount: enabledPlanCount,
    now: now ?? DateTime(2026, 6, 25),
  );
}

void main() {
  group('HealthSummaryEngine - 体重趋势', () {
    test('体重上升显示上升趋势', () {
      final summary = _engine.generate(
        _ctx(
          weightHistory: [
            SummaryWeightRecord(occurredAt: DateTime(2026, 5, 10), value: 5.0),
            SummaryWeightRecord(occurredAt: DateTime(2026, 6, 20), value: 5.4),
          ],
        ),
      );

      expect(summary.weightMetric, isNotNull);
      expect(summary.weightMetric!.trend, 'up');
      expect(summary.weightMetric!.value, contains('5.4'));
    });

    test('体重下降显示下降趋势', () {
      final summary = _engine.generate(
        _ctx(
          weightHistory: [
            SummaryWeightRecord(occurredAt: DateTime(2026, 5, 10), value: 6.0),
            SummaryWeightRecord(occurredAt: DateTime(2026, 6, 20), value: 5.5),
          ],
        ),
      );

      expect(summary.weightMetric, isNotNull);
      expect(summary.weightMetric!.trend, 'down');
    });

    test('体重稳定显示稳定', () {
      final summary = _engine.generate(
        _ctx(
          weightHistory: [
            SummaryWeightRecord(occurredAt: DateTime(2026, 5, 10), value: 5.0),
            SummaryWeightRecord(occurredAt: DateTime(2026, 6, 20), value: 5.02),
          ],
        ),
      );

      expect(summary.weightMetric, isNotNull);
      expect(summary.weightMetric!.trend, 'stable');
    });

    test('体重记录不足时返回 null', () {
      final summary = _engine.generate(
        _ctx(
          weightHistory: [
            SummaryWeightRecord(occurredAt: DateTime(2026, 6, 20), value: 5.0),
          ],
        ),
      );

      expect(summary.weightMetric, isNull);
    });
  });

  group('HealthSummaryEngine - 记录频次', () {
    test('记录增多显示正向趋势', () {
      final summary = _engine.generate(
        _ctx(
          recentRecords: List.generate(
            20,
            (i) => SummaryHealthRecord(
              type: 'weight',
              occurredAt: DateTime(2026, 6, 1 + i),
            ),
          ),
          previousRecords: List.generate(
            10,
            (i) => SummaryHealthRecord(
              type: 'weight',
              occurredAt: DateTime(2026, 5, 1 + i),
            ),
          ),
        ),
      );

      expect(summary.recordMetric, isNotNull);
      expect(summary.recordMetric!.trend, 'up');
      expect(summary.recordMetric!.positiveTrend, isTrue);
    });

    test('记录减少显示负向趋势', () {
      final summary = _engine.generate(
        _ctx(
          recentRecords: List.generate(
            5,
            (i) => SummaryHealthRecord(
              type: 'weight',
              occurredAt: DateTime(2026, 6, 1 + i),
            ),
          ),
          previousRecords: List.generate(
            15,
            (i) => SummaryHealthRecord(
              type: 'weight',
              occurredAt: DateTime(2026, 5, 1 + i),
            ),
          ),
        ),
      );

      expect(summary.recordMetric, isNotNull);
      expect(summary.recordMetric!.trend, 'down');
    });

    test('无记录时返回 null', () {
      final summary = _engine.generate(_ctx());
      expect(summary.recordMetric, isNull);
    });
  });

  group('HealthSummaryEngine - 护理完成率', () {
    test('覆盖率上升显示正向', () {
      final summary = _engine.generate(
        _ctx(
          enabledPlanCount: 3,
          weeklyCoverageRate: 0.9,
          previousWeekCoverageRate: 0.7,
        ),
      );

      expect(summary.careMetric, isNotNull);
      expect(summary.careMetric!.trend, 'up');
      expect(summary.careMetric!.value, '90%');
    });

    test('覆盖率下降显示负向', () {
      final summary = _engine.generate(
        _ctx(
          enabledPlanCount: 2,
          weeklyCoverageRate: 0.5,
          previousWeekCoverageRate: 0.8,
        ),
      );

      expect(summary.careMetric, isNotNull);
      expect(summary.careMetric!.trend, 'down');
    });

    test('无护理计划时返回 null', () {
      final summary = _engine.generate(_ctx(enabledPlanCount: 0));
      expect(summary.careMetric, isNull);
    });
  });

  group('HealthSummaryEngine - 饮食规律性', () {
    test('饮食记录天数增多显示正向', () {
      final recent = List.generate(
        10,
        (i) => SummaryHealthRecord(
          type: 'food',
          occurredAt: DateTime(2026, 6, 1 + i),
        ),
      );
      final previous = List.generate(
        5,
        (i) => SummaryHealthRecord(
          type: 'food',
          occurredAt: DateTime(2026, 5, 1 + i),
        ),
      );

      final summary = _engine.generate(
        _ctx(recentRecords: recent, previousRecords: previous),
      );

      expect(summary.dietMetric, isNotNull);
      expect(summary.dietMetric!.trend, 'up');
    });

    test('无饮食记录时返回 null', () {
      final summary = _engine.generate(_ctx());
      expect(summary.dietMetric, isNull);
    });
  });

  group('HealthSummaryEngine - 症状/异常', () {
    test('症状增多显示负向趋势', () {
      final recent = List.generate(
        5,
        (i) => SummaryHealthRecord(
          type: 'symptom',
          occurredAt: DateTime(2026, 6, 1 + i),
        ),
      );
      final previous = List.generate(
        2,
        (i) => SummaryHealthRecord(
          type: 'symptom',
          occurredAt: DateTime(2026, 5, 1 + i),
        ),
      );

      final summary = _engine.generate(
        _ctx(recentRecords: recent, previousRecords: previous),
      );

      expect(summary.symptomMetric, isNotNull);
      expect(summary.symptomMetric!.trend, 'up');
      // 症状增多是负向
      expect(summary.symptomMetric!.positiveTrend, isFalse);
    });

    test('无异常记录时返回 null', () {
      final summary = _engine.generate(_ctx());
      expect(summary.symptomMetric, isNull);
    });
  });

  group('HealthSummaryEngine - 交叉洞察', () {
    test('体重上升+饮食增多触发洞察', () {
      final recentFood = List.generate(
        15,
        (i) => SummaryHealthRecord(
          type: 'food',
          occurredAt: DateTime(2026, 6, 1 + i),
        ),
      );
      final previousFood = List.generate(
        5,
        (i) => SummaryHealthRecord(
          type: 'food',
          occurredAt: DateTime(2026, 5, 1 + i),
        ),
      );

      final summary = _engine.generate(
        _ctx(
          weightHistory: [
            SummaryWeightRecord(occurredAt: DateTime(2026, 5, 10), value: 5.0),
            SummaryWeightRecord(occurredAt: DateTime(2026, 6, 20), value: 5.5),
          ],
          recentRecords: recentFood,
          previousRecords: previousFood,
        ),
      );

      expect(summary.crossInsight, isNotNull);
      expect(summary.crossInsight!, contains('饮食'));
    });

    test('所有指标稳定时输出鼓励文案', () {
      final summary = _engine.generate(
        _ctx(
          weightHistory: [
            SummaryWeightRecord(occurredAt: DateTime(2026, 5, 10), value: 5.0),
            SummaryWeightRecord(occurredAt: DateTime(2026, 6, 20), value: 5.01),
          ],
          recentRecords: List.generate(
            10,
            (i) => SummaryHealthRecord(
              type: 'weight',
              occurredAt: DateTime(2026, 6, 1 + i),
            ),
          ),
          previousRecords: List.generate(
            10,
            (i) => SummaryHealthRecord(
              type: 'weight',
              occurredAt: DateTime(2026, 5, 1 + i),
            ),
          ),
          enabledPlanCount: 2,
          weeklyCoverageRate: 0.9,
          previousWeekCoverageRate: 0.88,
        ),
      );

      expect(summary.crossInsight, isNotNull);
      expect(summary.crossInsight!, contains('保持稳定'));
    });

    test('数据不足时洞察为 null', () {
      final summary = _engine.generate(_ctx());
      expect(summary.crossInsight, isNull);
    });
  });

  group('HealthSummary - 模型方法', () {
    test('hasAnyMetric 正确判断', () {
      const empty = HealthSummary();
      expect(empty.hasAnyMetric, isFalse);

      const withWeight = HealthSummary(
        weightMetric: MetricItem(
          label: '体重',
          value: '5.0 kg',
          comparison: '持平',
          trend: 'stable',
        ),
      );
      expect(withWeight.hasAnyMetric, isTrue);

      const withDietOnly = HealthSummary(
        dietMetric: MetricItem(
          label: '饮食',
          value: '5 天',
          comparison: '+2 天',
          trend: 'up',
        ),
      );
      expect(withDietOnly.hasAnyMetric, isTrue);
    });

    test('visibleMetrics 只返回非空指标', () {
      const summary = HealthSummary(
        weightMetric: MetricItem(
          label: '体重',
          value: '5.0 kg',
          comparison: '持平',
          trend: 'stable',
        ),
        recordMetric: MetricItem(
          label: '记录',
          value: '10 条',
          comparison: '+2 条',
          trend: 'up',
        ),
      );

      expect(summary.visibleMetrics.length, 2);
    });
  });
}
