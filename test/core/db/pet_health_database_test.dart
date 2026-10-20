import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_health/core/db/converters.dart';
import 'package:pet_health/core/db/pet_health_database.dart';
import 'package:pet_health/core/units/units.dart';
import 'package:pet_health/features/cards/domain/card_codes.dart';
import 'package:pet_health/features/entries/domain/entry_codes.dart';
import 'package:pet_health/features/pets/domain/pet_codes.dart';
import 'package:pet_health/features/plans/domain/plan_schedule.dart';

final _now = DateTime.utc(2026, 10, 12, 9);

void main() {
  late PetHealthDatabase db;

  setUp(() => db = PetHealthDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  Future<void> addPet(String id) => db
      .into(db.pets)
      .insert(
        PetsCompanion.insert(
          id: id,
          name: id,
          createdAt: _now,
          updatedAt: _now,
        ),
      );

  EntriesCompanion entry(
    String id,
    String petId,
    EntryType type, {
    DateTime? endedAt,
    String? planId,
  }) => EntriesCompanion.insert(
    id: id,
    petId: petId,
    type: type,
    occurredAt: _now,
    startedAt: Value(type == EntryType.walk ? _now : null),
    endedAt: Value(endedAt),
    planId: Value(planId),
    createdAt: _now,
    updatedAt: _now,
  );

  PlansCompanion plan(String id, String petId) => PlansCompanion.insert(
    id: id,
    petId: petId,
    entryType: EntryType.bath,
    schedule: PlanScheduleKind.everyNDays,
    intervalDays: const Value(35),
    createdAt: _now,
    updatedAt: _now,
  );

  test('外键约束已开启', () async {
    final row = await db.customSelect('PRAGMA foreign_keys').getSingle();
    expect(row.read<int>('foreign_keys'), 1);
  });

  group('读写', () {
    test('档案：枚举存 code，日期存 yyyy-MM-dd，默认值正确', () async {
      await db
          .into(db.pets)
          .insert(
            PetsCompanion.insert(
              id: 'lucky',
              name: 'Lucky',
              sex: const Value(PetSex.male),
              birthDate: Value(DateTime(2022, 5, 1)),
              birthPrecision: const Value(BirthPrecision.month),
              homeDate: Value(DateTime(2022, 8, 9)),
              breedCode: const Value('golden_retriever'),
              breedGroup: const Value(BreedGroup.largeDouble),
              createdAt: _now,
              updatedAt: _now,
            ),
          );
      await addPet('mochi');

      final raw = await db
          .customSelect(
            "SELECT sex, birth_date, home_date, breed_group FROM pets WHERE id = 'lucky'",
          )
          .getSingle();
      expect(raw.data, {
        'sex': 'male',
        'birth_date': '2022-05-01',
        'home_date': '2022-08-09',
        'breed_group': 'large_double',
      });

      final lucky = await (db.select(
        db.pets,
      )..where((t) => t.id.equals('lucky'))).getSingle();
      expect(lucky.birthDate, DateTime(2022, 5, 1));
      expect(lucky.birthPrecision, BirthPrecision.month);

      final mochi = await (db.select(
        db.pets,
      )..where((t) => t.id.equals('mochi'))).getSingle();
      expect(mochi.breedGroup, BreedGroup.mixed);
      expect(mochi.birthPrecision, BirthPrecision.day);
      expect(mochi.sex, isNull);
    });

    test('预设：默认一键记录为饮食、饮水、排泄、梳毛', () async {
      await addPet('lucky');
      await db
          .into(db.petPresets)
          .insert(
            PetPresetsCompanion.insert(
              petId: 'lucky',
              mealAmount: const Value(2),
              mealUnit: const Value(PortionUnit.scoop),
              bowlMl: const Value(750),
            ),
          );
      final preset = await db.select(db.petPresets).getSingle();
      expect(preset.quickTypes, [
        EntryType.meal,
        EntryType.water,
        EntryType.potty,
        EntryType.brushing,
      ]);
      expect(preset.mealUnit, PortionUnit.scoop);
    });

    test('记录：类型、单位与 details 往返', () async {
      await addPet('lucky');
      await db
          .into(db.entries)
          .insert(
            EntriesCompanion.insert(
              id: 'e1',
              petId: 'lucky',
              type: EntryType.earCheck,
              occurredAt: _now,
              details: const Value({'ears': 'waxy'}),
              createdAt: _now,
              updatedAt: _now,
            ),
          );
      await db
          .into(db.entries)
          .insert(
            EntriesCompanion.insert(
              id: 'e2',
              petId: 'lucky',
              type: EntryType.meal,
              occurredAt: _now,
              amount: const Value(1.5),
              unit: const Value(PortionUnit.cup),
              createdAt: _now,
              updatedAt: _now,
            ),
          );

      final raw = await db
          .customSelect("SELECT type, details FROM entries WHERE id = 'e1'")
          .getSingle();
      expect(raw.data, {'type': 'ear_check', 'details': '{"ears":"waxy"}'});

      final meal = await (db.select(
        db.entries,
      )..where((t) => t.id.equals('e2'))).getSingle();
      expect(meal.unit, PortionUnit.cup);
      expect(meal.details, isEmpty);
      expect(meal.note, '');
    });

    test('非空列读到不认识的 code 时明确报错', () async {
      await addPet('lucky');
      await db.customStatement(
        "INSERT INTO entries (id, pet_id, type, occurred_at, created_at, updated_at) "
        "VALUES ('x', 'lucky', 'teleport', 0, 0, 0)",
      );
      expect(db.select(db.entries).get(), throwsFormatException);
    });
  });

  group('约束', () {
    test('每只狗最多一条进行中的遛狗', () async {
      await addPet('lucky');
      await addPet('mochi');
      await db.into(db.entries).insert(entry('w1', 'lucky', EntryType.walk));

      await expectLater(
        db.into(db.entries).insert(entry('w2', 'lucky', EntryType.walk)),
        throwsA(isA<Exception>()),
      );
      // 已结束的遛狗、另一只狗的遛狗都不受影响。
      await db
          .into(db.entries)
          .insert(entry('w3', 'lucky', EntryType.walk, endedAt: _now));
      await db.into(db.entries).insert(entry('w4', 'mochi', EntryType.walk));
      expect(await db.select(db.entries).get(), hasLength(3));
    });

    test('计划的排期字段必须完整', () async {
      await addPet('lucky');
      Future<int> insert(PlansCompanion companion) =>
          db.into(db.plans).insert(companion);

      await expectLater(
        insert(plan('p1', 'lucky').copyWith(intervalDays: const Value(null))),
        throwsA(isA<Exception>()),
      );
      await expectLater(
        insert(
          plan('p2', 'lucky').copyWith(
            schedule: const Value(PlanScheduleKind.weekdays),
            intervalDays: const Value(null),
          ),
        ),
        throwsA(isA<Exception>()),
      );
      await expectLater(
        insert(
          plan('p3', 'lucky').copyWith(
            schedule: const Value(PlanScheduleKind.once),
            intervalDays: const Value(null),
          ),
        ),
        throwsA(isA<Exception>()),
      );
      await expectLater(
        insert(plan('p4', 'lucky').copyWith(notifyMinute: const Value(1440))),
        throwsA(isA<Exception>()),
      );
      await expectLater(
        insert(
          plan('p5', 'lucky').copyWith(
            schedule: const Value(PlanScheduleKind.everyNMonths),
            intervalDays: const Value(null),
          ),
        ),
        throwsA(isA<Exception>()),
      );

      await insert(
        plan('ok', 'lucky').copyWith(
          schedule: const Value(PlanScheduleKind.weekdays),
          intervalDays: const Value(null),
          weekdays: Value(Weekdays.forTimesPerWeek(3)),
          notifyMinute: const Value(20 * 60),
        ),
      );
      expect(await db.select(db.plans).get(), hasLength(1));
    });

    test('同一只狗同一天同一张卡片只记一次', () async {
      await addPet('lucky');
      CardHistoryCompanion card(String id) => CardHistoryCompanion.insert(
        id: id,
        petId: 'lucky',
        day: DateTime(2026, 10, 12),
        cardKey: 'tip.hot_pavement',
        category: CardCategory.tip,
        createdAt: _now,
      );
      await db.into(db.cardHistory).insert(card('c1'));
      await expectLater(
        db.into(db.cardHistory).insert(card('c2')),
        throwsA(isA<Exception>()),
      );
    });

    test('删除计划后记录保留，只是不再关联', () async {
      await addPet('lucky');
      await db.into(db.plans).insert(plan('p1', 'lucky'));
      await db
          .into(db.entries)
          .insert(entry('e1', 'lucky', EntryType.bath, planId: 'p1'));

      await (db.delete(db.plans)..where((t) => t.id.equals('p1'))).go();

      final remaining = await db.select(db.entries).getSingle();
      expect(remaining.planId, isNull);
    });

    test('删除狗狗时级联删除它的全部数据，不影响其他狗', () async {
      await addPet('lucky');
      await addPet('mochi');
      for (final petId in ['lucky', 'mochi']) {
        await db
            .into(db.petPresets)
            .insert(PetPresetsCompanion.insert(petId: petId));
        await db.into(db.plans).insert(plan('plan-$petId', petId));
        await db
            .into(db.entries)
            .insert(entry('entry-$petId', petId, EntryType.potty));
        await db
            .into(db.cardHistory)
            .insert(
              CardHistoryCompanion.insert(
                id: 'card-$petId',
                petId: petId,
                day: DateTime(2026, 10, 12),
                cardKey: 'moment.quiet_day',
                category: CardCategory.moment,
                createdAt: _now,
              ),
            );
        await db
            .into(db.petPhotos)
            .insert(
              PetPhotosCompanion.insert(
                id: 'photo-$petId',
                petId: petId,
                originalName: 'a.jpg',
                mediaType: 'image/jpeg',
                createdAt: _now,
                updatedAt: _now,
              ),
            );
        await db
            .into(db.memoryEntries)
            .insert(
              MemoryEntriesCompanion.insert(
                id: 'memory-$petId',
                petId: petId,
                occurredAt: _now,
                createdAt: _now,
                updatedAt: _now,
              ),
            );
        await db
            .into(db.memoryMediaRefs)
            .insert(
              MemoryMediaRefsCompanion.insert(
                id: 'media-$petId',
                entryId: 'memory-$petId',
                kind: 'image',
                platformRef: 'ref',
                position: 0,
              ),
            );
      }

      await (db.delete(db.pets)..where((t) => t.id.equals('lucky'))).go();

      for (final table in <TableInfo>[
        db.petPresets,
        db.plans,
        db.entries,
        db.cardHistory,
        db.petPhotos,
        db.memoryEntries,
        db.memoryMediaRefs,
      ]) {
        final rows = await db.select(table).get();
        expect(rows, hasLength(1), reason: table.actualTableName);
      }
      final pets = await db.select(db.pets).get();
      expect(pets.single.id, 'mochi');
    });
  });

  group('转换器', () {
    test('本地日期补零，往返不受时区影响', () {
      const converter = LocalDateConverter();
      expect(converter.toSql(DateTime(2026, 3, 7, 23, 59)), '2026-03-07');
      expect(converter.fromSql('2026-03-07'), DateTime(2026, 3, 7));
      expect(() => converter.fromSql('2026/03/07'), throwsFormatException);
    });

    test('枚举列表跳过不认识的 code', () {
      const converter = CodedEnumListConverter(EntryType.values);
      expect(converter.fromSql('["meal","teleport","water"]'), [
        EntryType.meal,
        EntryType.water,
      ]);
      expect(converter.fromSql('{}'), isEmpty);
    });

    test('JSON 对象读到非对象时返回空', () {
      expect(const JsonMapConverter().fromSql('[1,2]'), isEmpty);
    });
  });
}
