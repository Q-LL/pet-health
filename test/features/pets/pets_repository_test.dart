import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_health/core/db/pet_health_database.dart' hide PetPresets;
import 'package:pet_health/core/units/units.dart';
import 'package:pet_health/features/entries/domain/entry_codes.dart';
import 'package:pet_health/features/pets/data/pets_repository.dart';
import 'package:pet_health/features/pets/domain/breed_catalog.dart';
import 'package:pet_health/features/pets/domain/pet.dart';
import 'package:pet_health/features/pets/domain/pet_codes.dart';
import 'package:pet_health/features/plans/data/plan_columns.dart';
import 'package:pet_health/features/plans/domain/plan_codes.dart';
import 'package:pet_health/features/plans/domain/plan_schedule.dart';
import 'package:pet_health/features/settings/data/preferences_repository.dart';

void main() {
  late PetHealthDatabase db;
  late PetsRepository pets;
  late PreferencesRepository preferences;
  late DateTime now;

  setUp(() {
    db = PetHealthDatabase(NativeDatabase.memory());
    now = DateTime(2026, 10, 18, 9);
    pets = PetsRepository(db, clock: () => now);
    preferences = PreferencesRepository(db, clock: () => now);
  });

  tearDown(() => db.close());

  Future<List<PlanRow>> plansOf(String petId) =>
      (db.select(db.plans)..where((t) => t.petId.equals(petId))).get();

  group('犬种目录', () {
    test('预设犬种按分组归类，未知犬种为混种', () {
      expect(breedGroupFor('golden_retriever'), BreedGroup.largeDouble);
      expect(
        breedGroupFor('cavalier_king_charles_spaniel'),
        BreedGroup.smallSilky,
      );
      expect(breedGroupFor('poodle'), BreedGroup.curly);
      expect(breedGroupFor('something_else'), BreedGroup.mixed);
      expect(breedGroupFor(null), BreedGroup.mixed);
    });

    test('犬种 code 为小写下划线格式，每个分组都有犬种（混种除外）', () {
      final format = RegExp(r'^[a-z]+(_[a-z]+)*$');
      expect(breedCatalog.keys.every(format.hasMatch), isTrue);
      for (final group in BreedGroup.values) {
        if (group == BreedGroup.mixed) continue;
        expect(breedCatalog.values, contains(group));
      }
    });

    test('每个分组的默认计划：都有梳毛、洗澡、体重，不自动生成驱虫', () {
      for (final group in BreedGroup.values) {
        final types = defaultPlansFor(group).map((p) => p.entryType).toSet();
        expect(
          types,
          containsAll([EntryType.brushing, EntryType.bath, EntryType.weight]),
        );
        expect(types, isNot(contains(EntryType.dewormer)));
        expect(types, isNot(contains(EntryType.heartworm)));
      }
    });

    test('金毛：每周梳毛 4 次、42 天洗澡、每周检查耳朵', () {
      final plans = defaultPlansFor(BreedGroup.largeDouble);
      PlanSchedule scheduleOf(EntryType type) =>
          plans.firstWhere((p) => p.entryType == type).schedule;
      expect(
        Weekdays.toList((scheduleOf(EntryType.brushing) as OnWeekdays).mask),
        [1, 3, 5, 7],
      );
      expect(scheduleOf(EntryType.bath), const EveryNDays(42));
      expect(scheduleOf(EntryType.earCheck), isA<OnWeekdays>());
    });

    test('泰迪有美容修剪，骑士查理王有眼部护理', () {
      expect(
        defaultPlansFor(BreedGroup.curly).map((p) => p.entryType),
        contains(EntryType.grooming),
      );
      expect(
        defaultPlansFor(
          BreedGroup.smallSilky,
        ).where((p) => p.entryType == EntryType.otherCare).single.entryKind,
        OtherCareKind.eyes.code,
      );
    });
  });

  group('档案', () {
    test('新建时写入档案、默认预设和犬种计划，并自动选中', () async {
      final lucky = await pets.create(
        PetDraft(
          name: '  Lucky ',
          breedCode: 'golden_retriever',
          birthDate: DateTime(2022, 5, 17),
          birthPrecision: BirthPrecision.month,
          homeDate: DateTime(2022, 8, 9),
        ),
      );
      expect(lucky.name, 'Lucky');
      expect(lucky.breedGroup, BreedGroup.largeDouble);
      // 只知道年月时存当月 1 日。
      expect(lucky.birthDate, DateTime(2022, 5, 1));

      final presets = await pets.watchPresets(lucky.id).first;
      expect(presets!.quickTypes, PetsRepository.defaultQuickTypes);

      final plans = await plansOf(lucky.id);
      expect(
        plans.map((p) => p.entryType).toSet(),
        defaultPlansFor(BreedGroup.largeDouble).map((p) => p.entryType).toSet(),
      );
      expect(plans.every((p) => p.source == PlanSource.breedDefault), isTrue);
      expect(plans.every((p) => p.notifyMinute == null), isTrue);

      expect((await preferences.get()).selectedPetId, lucky.id);
    });

    test('已经选中别的狗狗时不改变选择', () async {
      final lucky = await pets.create(const PetDraft(name: 'Lucky'));
      await pets.create(const PetDraft(name: 'Mochi', breedCode: 'poodle'));
      expect((await preferences.get()).selectedPetId, lucky.id);
    });

    test('手动指定分组优先于犬种', () async {
      final pet = await pets.create(
        const PetDraft(
          name: 'Bean',
          breedName: '中华田园犬',
          breedGroup: BreedGroup.mediumDouble,
        ),
      );
      expect(pet.breedGroup, BreedGroup.mediumDouble);
      expect(pet.breedCode, isNull);
      expect(pet.breedName, '中华田园犬');
    });

    test('名字不能为空，日期不能在未来', () {
      expect(
        () => pets.create(const PetDraft(name: '  ')),
        throwsArgumentError,
      );
      expect(
        () =>
            pets.create(PetDraft(name: 'A', homeDate: DateTime(2026, 10, 19))),
        throwsArgumentError,
      );
      // 今天到家是可以的。
      expect(
        pets.create(PetDraft(name: 'A', homeDate: DateTime(2026, 10, 18))),
        completes,
      );
    });

    test('在一起的第几天：到家当天是第 1 天', () async {
      final pet = await pets.create(
        PetDraft(name: 'Lucky', homeDate: DateTime(2025, 6, 1)),
      );
      expect(pet.dayTogether(DateTime(2025, 6, 1, 22)), 1);
      expect(pet.dayTogether(DateTime(2026, 10, 13)), 500);
      expect(pet.dayTogether(DateTime(2025, 5, 31)), isNull);
      expect(
        (await pets.create(const PetDraft(name: 'B'))).dayTogether(now),
        isNull,
      );
    });

    test('修改档案不会替换计划；重新套用默认值只替换自动生成的计划', () async {
      final pet = await pets.create(
        const PetDraft(name: 'Mochi', breedCode: 'poodle'),
      );
      // 用户自己建的计划。
      await db
          .into(db.plans)
          .insert(
            scheduleColumns(const EveryNDays(30)).copyWith(
              id: const Value('mine'),
              petId: Value(pet.id),
              entryType: const Value(EntryType.dewormer),
              createdAt: Value(now.toUtc()),
              updatedAt: Value(now.toUtc()),
            ),
          );

      await pets.update(
        pet.id,
        const PetDraft(name: 'Mochi', breedCode: 'golden_retriever'),
      );
      expect(
        (await plansOf(pet.id)).map((p) => p.entryType),
        contains(EntryType.grooming),
      );

      await pets.applyBreedDefaults(pet.id);
      final plans = await plansOf(pet.id);
      final types = plans.map((p) => p.entryType).toList();
      expect(types, isNot(contains(EntryType.grooming)));
      expect(types, contains(EntryType.dewormer));
      expect(
        plans.where((p) => p.source == PlanSource.breedDefault),
        hasLength(defaultPlansFor(BreedGroup.largeDouble).length),
      );
    });

    test('删除当前狗狗时改选最早建的另一只；全部删完后清空选择', () async {
      final lucky = await pets.create(const PetDraft(name: 'Lucky'));
      now = now.add(const Duration(minutes: 1));
      final mochi = await pets.create(const PetDraft(name: 'Mochi'));
      now = now.add(const Duration(minutes: 1));
      final bean = await pets.create(const PetDraft(name: 'Bean'));

      await preferences.setSelectedPet(bean.id);
      expect(await pets.delete(mochi.id), isTrue);
      expect((await preferences.get()).selectedPetId, bean.id);

      expect(await pets.delete(bean.id), isTrue);
      expect((await preferences.get()).selectedPetId, lucky.id);

      expect(await pets.delete(lucky.id), isTrue);
      expect((await preferences.get()).selectedPetId, isNull);
      expect(await pets.delete(lucky.id), isFalse);
      expect(await db.select(db.plans).get(), isEmpty);
    });

    test('按创建顺序列出', () async {
      await pets.create(const PetDraft(name: 'A'));
      now = now.add(const Duration(seconds: 1));
      await pets.create(const PetDraft(name: 'B'));
      expect((await pets.getAll()).map((p) => p.name), ['A', 'B']);
    });
  });

  group('预设', () {
    test('保存并读回', () async {
      final pet = await pets.create(const PetDraft(name: 'Lucky'));
      final saved = await pets.savePresets(
        pet.id,
        const PetPresetsDraft(
          mealAmount: 2,
          mealUnit: PortionUnit.scoop,
          mealsPerDay: 2,
          bowlMl: 750,
          quickTypes: [EntryType.potty, EntryType.meal, EntryType.walk],
        ),
      );
      expect(saved.mealUnit, PortionUnit.scoop);
      expect(saved.bowlMl, 750);
      expect(saved.quickTypes, [
        EntryType.potty,
        EntryType.meal,
        EntryType.walk,
      ]);
    });

    test('校验份量、单位与一键记录', () async {
      final pet = await pets.create(const PetDraft(name: 'Lucky'));
      for (final draft in [
        const PetPresetsDraft(mealAmount: 0, quickTypes: []),
        const PetPresetsDraft(bowlMl: -1, quickTypes: []),
        const PetPresetsDraft(mealsPerDay: 0, quickTypes: []),
        const PetPresetsDraft(mealUnit: PortionUnit.tablet, quickTypes: []),
        const PetPresetsDraft(quickTypes: [EntryType.meal, EntryType.meal]),
        const PetPresetsDraft(quickTypes: [EntryType.custom]),
      ]) {
        expect(() => pets.savePresets(pet.id, draft), throwsArgumentError);
      }
    });
  });
}
