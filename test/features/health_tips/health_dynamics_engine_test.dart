import 'package:flutter_test/flutter_test.dart';
import 'package:pet_health/features/health_tips/application/health_dynamics_engine.dart';
import 'package:pet_health/features/health_tips/domain/health_summary.dart';
import 'package:pet_health/features/health_tips/domain/health_tip.dart';

const _engine = HealthDynamicsEngine();

PetTipsProfile _pet() {
  return PetTipsProfile(id: 'pet', name: '团子', birthday: DateTime(2020, 1, 1));
}

HealthTipsContext _ctx({
  List<TipsHealthRecord> recentRecords = const [],
  List<TipsWeightRecord> weightHistory = const [],
  int enabledPlanCount = 0,
  double coverageRate = 1,
  DateTime? now,
}) {
  return HealthTipsContext(
    pet: _pet(),
    recentRecords: recentRecords,
    weightHistory: weightHistory,
    enabledPlanCount: enabledPlanCount,
    hasEnabledDewormingPlan: false,
    coverageRate: coverageRate,
    now: now ?? DateTime(2026, 6, 25),
  );
}

void main() {
  test('体重下降叠加食欲异常时输出高优先级洞察', () {
    final dynamics = _engine.generate(
      tipsContext: _ctx(
        weightHistory: [
          TipsWeightRecord(occurredAt: DateTime(2026, 5, 20), value: 10),
          TipsWeightRecord(occurredAt: DateTime(2026, 6, 24), value: 9.1),
        ],
        recentRecords: [
          TipsHealthRecord(
            type: 'food',
            occurredAt: DateTime(2026, 6, 20),
            title: '喂食',
            details: {'appetite': '少吃'},
          ),
          TipsHealthRecord(
            type: 'food',
            occurredAt: DateTime(2026, 6, 22),
            title: '喂食',
            details: {'appetite': '没吃'},
          ),
        ],
      ),
      summary: const HealthSummary(),
      recommendations: const [],
    );

    final insight = dynamics.insights.firstWhere(
      (item) => item.id == 'weight_loss_pattern',
    );
    expect(insight.tone, 'alert');
    expect(insight.evidence.any((item) => item.contains('食欲异常')), isTrue);
  });

  test('饮食和排泄组合信号生成消化洞察', () {
    final dynamics = _engine.generate(
      tipsContext: _ctx(
        recentRecords: [
          TipsHealthRecord(
            type: 'food',
            occurredAt: DateTime(2026, 6, 23),
            title: '喂食',
            details: {'appetite': '需要观察'},
          ),
          TipsHealthRecord(
            type: 'elimination',
            occurredAt: DateTime(2026, 6, 24),
            title: '排泄',
            details: {'stool': '腹泻'},
          ),
        ],
      ),
      summary: const HealthSummary(),
      recommendations: const [],
    );

    expect(
      dynamics.insights.any((item) => item.id == 'diet_digestive_cluster'),
      isTrue,
    );
  });

  test('护理完成率高时输出鼓励洞察', () {
    final dynamics = _engine.generate(
      tipsContext: _ctx(enabledPlanCount: 2, coverageRate: 0.95),
      summary: const HealthSummary(),
      recommendations: const [],
    );

    expect(
      dynamics.insights.any((item) => item.id == 'care_excellent'),
      isTrue,
    );
  });
}
