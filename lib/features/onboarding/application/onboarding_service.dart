import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database_provider.dart';
import '../../../core/db/pet_health_database.dart';
import '../../entries/domain/entry_codes.dart';
import '../../pets/data/pets_repository.dart';
import '../../pets/domain/pet.dart';
import '../../plans/data/plans_repository.dart';
import '../../plans/domain/plan.dart';
import '../domain/onboarding_draft.dart';

final onboardingServiceProvider = Provider<OnboardingService>((ref) {
  return OnboardingService(
    ref.watch(petHealthDatabaseProvider),
    ref.watch(petsRepositoryProvider),
    ref.watch(plansRepositoryProvider),
  );
});

/// 完成引导：建档案、写预设、按犬种生成默认计划，再加上选的驱虫计划。
///
/// 全部在一个事务里完成，中途失败时什么都不留下。
class OnboardingService {
  OnboardingService(this._db, this._pets, this._plans);

  final PetHealthDatabase _db;
  final PetsRepository _pets;
  final PlansRepository _plans;

  Future<Pet> finish(OnboardingDraft draft) => _db.transaction(() async {
    final pet = await _pets.create(
      PetDraft(
        name: draft.name,
        sex: draft.sex,
        breedCode: draft.breedCode,
        breedName: draft.breedName,
        breedGroup: draft.breedGroup,
        birthDate: draft.birthDate,
        birthPrecision: draft.birthPrecision,
        homeDate: draft.homeDate,
      ),
    );
    await _pets.savePresets(
      pet.id,
      PetPresetsDraft(
        quickTypes: PetsRepository.defaultQuickTypes,
        mealAmount: draft.mealUnit == null ? null : draft.mealAmount,
        mealUnit: draft.mealAmount == null ? null : draft.mealUnit,
        mealsPerDay: draft.mealsPerDay,
        bowlMl: draft.bowlMl,
      ),
    );
    for (final coverage in ParasiteCoverage.values) {
      final plan = parasitePlanFor(pet.id, coverage, draft.parasite(coverage));
      if (plan != null) await _plans.create(plan);
    }
    return pet;
  });

  /// 一类驱虫的选择对应的计划，见 [parasitePlanDraft]。
  static PlanDraft? parasitePlanFor(
    String petId,
    ParasiteCoverage coverage,
    ParasiteChoice choice,
  ) => parasitePlanDraft(petId, coverage, choice);
}
