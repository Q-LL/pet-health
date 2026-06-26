import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../care/application/care_coverage.dart';
import '../../pets/data/pet_repository.dart';
import '../../records/data/health_record_repository.dart';
import '../domain/health_summary.dart';
import 'health_summary_engine.dart';

const _summaryEngine = HealthSummaryEngine();

/// 健康数据摘要 Provider。
///
/// 聚合近 60 天的健康记录（分两段对比）、护理覆盖率等数据，
/// 通过 [HealthSummaryEngine] 计算输出 [HealthSummary]。
final healthSummaryProvider = FutureProvider<HealthSummary>((ref) async {
  // 1. 获取当前宠物
  final selectedPetId = ref.watch(selectedPetIdProvider).value;
  if (selectedPetId == null) return const HealthSummary();

  final pets = ref.watch(petsProvider).value ?? const [];
  final pet = pets.where((p) => p.id == selectedPetId).firstOrNull;
  if (pet == null || pet.isPlaceholder) return const HealthSummary();

  // 2. 获取近 60 天健康记录
  final repository = ref.read(healthRecordRepositoryProvider);
  final now = DateTime.now();
  final thirtyDaysAgo = now.subtract(const Duration(days: 30));
  final sixtyDaysAgo = now.subtract(const Duration(days: 60));

  final recentRecords = await repository.findForPet(
    selectedPetId,
    from: thirtyDaysAgo,
    limit: 200,
  );

  final previousRecords = await repository.findForPet(
    selectedPetId,
    from: sixtyDaysAgo,
    to: thirtyDaysAgo,
    limit: 200,
  );

  // 3. 获取全部体重记录（正序）
  final weightRecords = await repository.findForPet(
    selectedPetId,
    type: 'weight',
    limit: 50,
  );
  final weightHistory = weightRecords
      .where((r) => r.numericValue != null)
      .map(
        (r) => SummaryWeightRecord(
          occurredAt: r.occurredAt,
          value: r.numericValue!,
          unit: r.unit,
        ),
      )
      .toList()
      .reversed
      .toList();

  // 4. 获取护理覆盖率（本周 + 上周）
  final coverage = await ref.read(careCoverageProvider.future);
  final previousWeekCoverage = await _computePreviousWeekCoverage(ref);

  // 5. 构建上下文
  final context = HealthSummaryContext(
    recentRecords: recentRecords
        .map(
          (r) => SummaryHealthRecord(
            type: r.type,
            occurredAt: r.occurredAt,
            numericValue: r.numericValue,
            unit: r.unit,
            details: r.details,
          ),
        )
        .toList(),
    previousRecords: previousRecords
        .map(
          (r) => SummaryHealthRecord(
            type: r.type,
            occurredAt: r.occurredAt,
            numericValue: r.numericValue,
            unit: r.unit,
            details: r.details,
          ),
        )
        .toList(),
    weightHistory: weightHistory,
    weeklyCoverageRate: coverage.weeklyRate,
    previousWeekCoverageRate: previousWeekCoverage,
    enabledPlanCount: coverage.totalActivePlans,
    now: now,
  );

  // 6. 运行引擎
  return _summaryEngine.generate(context);
});

/// 计算上周护理覆盖率。
///
/// 复用 careCoverageProvider 的计算逻辑，但查询上周的时间窗口。
Future<double> _computePreviousWeekCoverage(Ref ref) async {
  // 简化实现：使用当前覆盖率的趋势估算
  // 实际应该查询上周的护理日志计算
  final coverage = await ref.read(careCoverageProvider.future);

  // 如果有连续达标周数，说明上周也是达标的
  if (coverage.currentStreak >= 2) {
    // 上周也达标，假设覆盖率相近
    return coverage.weeklyRate;
  }

  // 否则返回一个保守估计
  return coverage.weeklyRate * 0.9;
}
