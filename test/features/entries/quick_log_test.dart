import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_health/core/db/pet_health_database.dart' hide PetPresets;
import 'package:pet_health/core/units/units.dart';
import 'package:pet_health/features/entries/application/quick_log.dart';
import 'package:pet_health/features/entries/data/entries_repository.dart';
import 'package:pet_health/features/entries/domain/entry_codes.dart';
import 'package:pet_health/features/entries/domain/entry_details.dart';
import 'package:pet_health/features/pets/data/pets_repository.dart';
import 'package:pet_health/features/pets/domain/pet.dart';

void main() {
  final now = DateTime(2026, 10, 26, 9);
  const presets = PetPresets(
    petId: 'p',
    quickTypes: [],
    mealAmount: 2,
    mealUnit: PortionUnit.scoop,
    bowlMl: 750,
  );

  group('默认内容', () {
    test('饮食用预设份量，饮水用水碗容量', () {
      final meal = QuickLog.draftFor(
        petId: 'p',
        type: EntryType.meal,
        at: now,
        presets: presets,
      );
      expect(meal.amount, 2);
      expect(meal.unit, PortionUnit.scoop);
      expect(meal.details, const MealDetails(appetite: Appetite.finished));

      final water = QuickLog.draftFor(
        petId: 'p',
        type: EntryType.water,
        at: now,
        presets: presets,
      );
      expect(water.amount, 750);
      expect(water.unit, isNull);
    });

    test('没有预设份量时只记一次，不带数量', () {
      final meal = QuickLog.draftFor(petId: 'p', type: EntryType.meal, at: now);
      expect(meal.amount, isNull);
      expect(meal.unit, isNull);
    });

    test('排泄默认便便正常；计划卡片带上细分项', () {
      expect(
        QuickLog.draftFor(petId: 'p', type: EntryType.potty, at: now).details,
        const PottyDetails(kind: PottyKind.poop, stool: StoolStatus.normal),
      );
      final heartworm = QuickLog.draftFor(
        petId: 'p',
        type: EntryType.parasitePrevention,
        at: now,
        planId: 'plan',
        kind: 'heartworm',
      );
      expect(heartworm.planId, 'plan');
      expect(
        heartworm.details,
        const ParasitePreventionDetails(coverage: {ParasiteCoverage.heartworm}),
      );
    });

    test('哪些类型点一下就能记', () {
      for (final type in [
        EntryType.meal,
        EntryType.water,
        EntryType.potty,
        EntryType.brushing,
        EntryType.bath,
        EntryType.earCheck,
      ]) {
        expect(QuickLog.canLogInstantly(type), isTrue, reason: type.code);
      }
      for (final type in [
        EntryType.weight,
        EntryType.symptom,
        EntryType.vetTest,
        EntryType.custom,
      ]) {
        expect(QuickLog.canLogInstantly(type), isFalse, reason: type.code);
      }
      expect(QuickLog.canLogInstantly(EntryType.otherCare), isFalse);
      expect(
        QuickLog.canLogInstantly(EntryType.otherCare, kind: 'nails'),
        isTrue,
      );
      expect(QuickLog.canLogInstantly(EntryType.parasitePrevention), isFalse);
    });
  });

  group('写入', () {
    late PetHealthDatabase db;
    late QuickLog quickLog;
    late String petId;

    setUp(() async {
      db = PetHealthDatabase(NativeDatabase.memory());
      quickLog = QuickLog(
        EntriesRepository(db, clock: () => now),
        clock: () => now,
      );
      petId = (await PetsRepository(
        db,
      ).create(const PetDraft(name: 'Lucky'))).id;
    });

    tearDown(() => db.close());

    test('点一下就写入一条记录', () async {
      final result = await quickLog.log(
        petId: petId,
        type: EntryType.meal,
        presets: presets,
      );
      expect(result, isA<Logged>());
      final entry = (result as Logged).entry;
      expect(entry.occurredAt, now);
      expect(entry.amount, 2);
    });

    test('需要填内容的类型不写入，交给补充面板', () async {
      final result = await quickLog.log(petId: petId, type: EntryType.weight);
      expect(result, isA<NeedsDetails>());
      expect(await EntriesRepository(db).findForPet(petId), isEmpty);
    });

    test('遛狗点一下开始，再点一下结束', () async {
      expect(
        await quickLog.log(petId: petId, type: EntryType.walk),
        isA<WalkStarted>(),
      );
      expect(
        await quickLog.log(petId: petId, type: EntryType.walk),
        isA<WalkFinished>(),
      );
      expect(await EntriesRepository(db).findForPet(petId), hasLength(1));
    });
  });
}
