import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../care/application/care_coverage.dart';
import '../../care/application/care_plan_controller.dart';
import '../../pets/data/pet_repository.dart';
import '../../records/data/health_record_repository.dart';
import '../domain/health_dynamics.dart';
import '../domain/health_summary.dart';
import '../domain/health_tip.dart';
import 'health_dynamics_engine.dart';
import 'health_summary_engine.dart';
import 'health_tips_engine.dart';

const _dynamicsEngine = HealthDynamicsEngine();
const _summaryEngine = HealthSummaryEngine();
const _tipsEngine = HealthTipsEngine();

final healthDynamicsProvider = FutureProvider<HealthDynamics>((ref) async {
  final selectedPetId = ref.watch(selectedPetIdProvider).value;
  if (selectedPetId == null) {
    return HealthDynamics(petName: '', generatedAt: DateTime.now());
  }

  final pets = ref.watch(petsProvider).value ?? const [];
  final pet = pets.where((p) => p.id == selectedPetId).firstOrNull;
  if (pet == null || pet.isPlaceholder) {
    return HealthDynamics(petName: '', generatedAt: DateTime.now());
  }

  final repository = ref.read(healthRecordRepositoryProvider);
  final now = DateTime.now();
  final thirtyDaysAgo = now.subtract(const Duration(days: 30));
  final sixtyDaysAgo = now.subtract(const Duration(days: 60));
  final ninetyDaysAgo = now.subtract(const Duration(days: 90));

  final recentRecords = await repository.findForPet(
    selectedPetId,
    from: ninetyDaysAgo,
    limit: 400,
  );
  final previousRecords = await repository.findForPet(
    selectedPetId,
    from: sixtyDaysAgo,
    to: thirtyDaysAgo,
    limit: 200,
  );
  final weightRecords = await repository.findForPet(
    selectedPetId,
    type: 'weight',
    limit: 80,
  );

  final weightHistory = weightRecords
      .where((record) => record.numericValue != null)
      .map(
        (record) => TipsWeightRecord(
          occurredAt: record.occurredAt,
          value: record.numericValue!,
          unit: record.unit,
        ),
      )
      .toList()
      .reversed
      .toList();

  final planState = ref.watch(carePlanControllerProvider);
  final enabledPlans = planState.enabledPlans.values.toList();
  final hasDewormingPlan = enabledPlans.any(
    (plan) =>
        plan.careType == 'deworming' || plan.candidateId.contains('deworm'),
  );
  final coverage = await ref.read(careCoverageProvider.future);

  final petProfile = PetTipsProfile(
    id: pet.id,
    name: pet.name,
    species: pet.species,
    breed: pet.breed,
    birthday: pet.birthday,
    neutered: pet.neutered,
    allergies: pet.allergies,
    chronicConditions: pet.chronicConditions,
  );

  final tipsRecords = recentRecords
      .map(
        (record) => TipsHealthRecord(
          type: record.type,
          occurredAt: record.occurredAt,
          title: record.title,
          note: record.note,
          numericValue: record.numericValue,
          unit: record.unit,
          severity: record.severity,
          details: record.details,
        ),
      )
      .toList();

  final tipsContext = HealthTipsContext(
    pet: petProfile,
    recentRecords: tipsRecords,
    weightHistory: weightHistory,
    enabledPlanCount: enabledPlans.length,
    hasEnabledDewormingPlan: hasDewormingPlan,
    coverageRate: coverage.weeklyRate,
    now: now,
  );

  final summaryContext = HealthSummaryContext(
    recentRecords: recentRecords
        .where((record) => !record.occurredAt.isBefore(thirtyDaysAgo))
        .map(
          (record) => SummaryHealthRecord(
            type: record.type,
            occurredAt: record.occurredAt,
            numericValue: record.numericValue,
            unit: record.unit,
            details: record.details,
          ),
        )
        .toList(),
    previousRecords: previousRecords
        .map(
          (record) => SummaryHealthRecord(
            type: record.type,
            occurredAt: record.occurredAt,
            numericValue: record.numericValue,
            unit: record.unit,
            details: record.details,
          ),
        )
        .toList(),
    weightHistory: weightHistory
        .map(
          (record) => SummaryWeightRecord(
            occurredAt: record.occurredAt,
            value: record.value,
            unit: record.unit,
          ),
        )
        .toList(),
    weeklyCoverageRate: coverage.weeklyRate,
    previousWeekCoverageRate: coverage.currentStreak >= 2
        ? coverage.weeklyRate
        : coverage.weeklyRate * 0.9,
    enabledPlanCount: coverage.totalActivePlans,
    now: now,
  );

  final summary = _summaryEngine.generate(summaryContext);
  final recommendations = _tipsEngine.generate(tipsContext, maxTips: 12);

  return _dynamicsEngine.generate(
    tipsContext: tipsContext,
    summary: summary,
    recommendations: recommendations,
  );
});
