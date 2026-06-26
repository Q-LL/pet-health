import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../care/application/care_coverage.dart';
import '../../care/application/care_plan_controller.dart';
import '../../pets/data/pet_repository.dart';
import '../../records/data/health_record_repository.dart';
import '../domain/health_tip.dart';
import 'health_tips_engine.dart';

const _engine = HealthTipsEngine();

/// 健康动态建议 Provider。
///
/// 聚合宠物档案、健康记录、护理计划等数据，
/// 通过 [HealthTipsEngine] 计算输出个性化建议列表。
final healthTipsProvider = FutureProvider<List<HealthTip>>((ref) async {
  // 1. 获取当前宠物
  final selectedPetId = ref.watch(selectedPetIdProvider).value;
  if (selectedPetId == null) return const [];

  final pets = ref.watch(petsProvider).value ?? const [];
  final pet = pets.where((p) => p.id == selectedPetId).firstOrNull;
  if (pet == null || pet.isPlaceholder) return const [];

  // 2. 获取最近 30 天健康记录
  final repository = ref.read(healthRecordRepositoryProvider);
  final now = DateTime.now();
  final thirtyDaysAgo = now.subtract(const Duration(days: 30));

  final recentRecords = await repository.findForPet(
    selectedPetId,
    from: thirtyDaysAgo,
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
        (r) => TipsWeightRecord(
          occurredAt: r.occurredAt,
          value: r.numericValue!,
          unit: r.unit,
        ),
      )
      .toList()
      .reversed
      .toList();

  // 4. 获取护理计划状态
  final planState = ref.watch(carePlanControllerProvider);
  final enabledPlans = planState.enabledPlans.values.toList();
  final hasDewormingPlan = enabledPlans.any(
    (p) => p.careType == 'deworming' || p.candidateId.contains('deworm'),
  );

  // 5. 获取护理覆盖率
  final coverage = await ref.read(careCoverageProvider.future);

  // 6. 构建上下文
  final context = HealthTipsContext(
    pet: PetTipsProfile(
      id: pet.id,
      name: pet.name,
      species: pet.species,
      breed: pet.breed,
      birthday: pet.birthday,
      neutered: pet.neutered,
      allergies: pet.allergies,
      chronicConditions: pet.chronicConditions,
    ),
    recentRecords: recentRecords
        .map(
          (r) => TipsHealthRecord(
            type: r.type,
            occurredAt: r.occurredAt,
            title: r.title,
            note: r.note,
            numericValue: r.numericValue,
            unit: r.unit,
            severity: r.severity,
            details: r.details,
          ),
        )
        .toList(),
    weightHistory: weightHistory,
    enabledPlanCount: enabledPlans.length,
    hasEnabledDewormingPlan: hasDewormingPlan,
    coverageRate: coverage.weeklyRate,
    now: now,
  );

  // 7. 运行引擎
  return _engine.generate(context);
});
