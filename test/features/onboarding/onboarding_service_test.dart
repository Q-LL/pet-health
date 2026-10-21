import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_health/core/db/pet_health_database.dart' hide PetPresets;
import 'package:pet_health/core/units/units.dart';
import 'package:pet_health/features/entries/domain/entry_codes.dart';
import 'package:pet_health/features/onboarding/application/onboarding_service.dart';
import 'package:pet_health/features/onboarding/domain/onboarding_draft.dart';
import 'package:pet_health/features/pets/data/pets_repository.dart';
import 'package:pet_health/features/pets/domain/breed_catalog.dart';
import 'package:pet_health/features/pets/domain/pet_codes.dart';
import 'package:pet_health/features/plans/data/plans_repository.dart';
import 'package:pet_health/features/plans/domain/plan_codes.dart';
import 'package:pet_health/features/plans/domain/plan_schedule.dart';

void main() {
  late PetHealthDatabase db;
  late PetsRepository pets;
  late PlansRepository plans;
  late OnboardingService onboarding;

  setUp(() {
    db = PetHealthDatabase(NativeDatabase.memory());
    pets = PetsRepository(db);
    plans = PlansRepository(db);
    onboarding = OnboardingService(db, pets, plans);
  });

  tearDown(() => db.close());

  test('写入档案、预设、犬种计划和选的驱虫计划', () async {
    final pet = await onboarding.finish(
      OnboardingDraft(
        name: 'Lucky',
        breedCode: 'golden_retriever',
        homeDate: DateTime(2025, 6, 1),
        mealAmount: 2,
        mealUnit: PortionUnit.scoop,
        mealsPerDay: 2,
        bowlMl: 750,
        parasites: const {
          ParasiteCoverage.heartworm: ParasiteChoice(
            ParasiteMode.scheduled,
            EveryNMonths(1),
          ),
          ParasiteCoverage.intestinal: ParasiteChoice(
            ParasiteMode.tests,
            EveryNMonths(6),
          ),
        },
      ),
    );
    expect(pet.breedGroup, BreedGroup.largeDouble);

    final presets = await pets.watchPresets(pet.id).first;
    expect(presets!.mealAmount, 2);
    expect(presets.mealUnit, PortionUnit.scoop);
    expect(presets.bowlMl, 750);

    final all = (await plans.statusesFor(pet.id)).map((s) => s.plan).toList();
    final defaults = all.where((p) => p.source == PlanSource.breedDefault);
    expect(defaults, hasLength(defaultPlansFor(BreedGroup.largeDouble).length));

    final heartworm = all.singleWhere(
      (p) => p.entryType == EntryType.parasitePrevention,
    );
    expect(heartworm.entryKind, 'heartworm');
    expect(heartworm.schedule, const EveryNMonths(1));
    expect(heartworm.source, PlanSource.user);

    final fecal = all.singleWhere((p) => p.entryType == EntryType.vetTest);
    expect(fecal.entryKind, 'fecal');
    expect(fecal.schedule, const EveryNMonths(6));
  });

  test('只填名字也能完成；先不设置的驱虫不生成计划', () async {
    final pet = await onboarding.finish(const OnboardingDraft(name: 'Mochi'));
    final all = (await plans.statusesFor(pet.id)).map((s) => s.plan);
    expect(all.every((p) => p.source == PlanSource.breedDefault), isTrue);
    final presets = await pets.watchPresets(pet.id).first;
    expect(presets!.mealAmount, isNull);
  });

  test('中途失败时什么都不留下', () async {
    await expectLater(
      onboarding.finish(const OnboardingDraft(name: 'Bean', mealsPerDay: 0)),
      throwsArgumentError,
    );
    expect(await pets.getAll(), isEmpty);
    expect(await db.select(db.plans).get(), isEmpty);
  });

  test('每类驱虫的选项', () {
    expect(
      ParasiteOptions.modesFor(ParasiteCoverage.fleasTicks),
      isNot(contains(ParasiteMode.tests)),
    );
    expect(
      ParasiteOptions.defaultFor(
        ParasiteCoverage.fleasTicks,
        ParasiteMode.scheduled,
      ),
      const ParasiteChoice(ParasiteMode.scheduled, EveryNMonths(1)),
    );
    expect(
      ParasiteOptions.schedulesFor(
        ParasiteCoverage.fleasTicks,
        ParasiteMode.scheduled,
      ),
      contains(const EveryNDays(84)),
    );
    expect(
      OnboardingService.parasitePlanFor(
        'p',
        ParasiteCoverage.heartworm,
        const ParasiteChoice(ParasiteMode.tests, EveryNMonths(12)),
      )?.entryKind,
      VetTestKind.heartworm.code,
    );
  });
}
