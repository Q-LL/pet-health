import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_health/core/db/pet_health_database.dart';
import 'package:pet_health/core/units/units.dart';
import 'package:pet_health/features/entries/data/entries_repository.dart';
import 'package:pet_health/features/entries/domain/entry.dart';
import 'package:pet_health/features/entries/domain/entry_codes.dart';
import 'package:pet_health/features/entries/domain/entry_details.dart';

void main() {
  late PetHealthDatabase db;
  late EntriesRepository entries;
  late DateTime now;

  setUp(() async {
    db = PetHealthDatabase(NativeDatabase.memory());
    now = DateTime(2026, 10, 18, 9);
    entries = EntriesRepository(db, clock: () => now);
    for (final id in ['lucky', 'mochi']) {
      await db
          .into(db.pets)
          .insert(
            PetsCompanion.insert(
              id: id,
              name: id,
              createdAt: now.toUtc(),
              updatedAt: now.toUtc(),
            ),
          );
    }
  });

  tearDown(() => db.close());

  EntryDraft potty(String petId, DateTime at) => EntryDraft(
    petId: petId,
    type: EntryType.potty,
    occurredAt: at,
    details: const PottyDetails(
      kind: PottyKind.poop,
      stool: StoolStatus.normal,
    ),
  );

  group('增删改查', () {
    test('新建后能按原样读回，时间为本地时间', () async {
      final created = await entries.create(
        EntryDraft(
          petId: 'lucky',
          type: EntryType.meal,
          occurredAt: DateTime(2026, 10, 18, 7, 30),
          amount: 2,
          unit: PortionUnit.scoop,
          details: const MealDetails(appetite: Appetite.leftSome),
          note: '  换了新粮  ',
        ),
      );
      expect(created.occurredAt, DateTime(2026, 10, 18, 7, 30));
      expect(created.occurredAt.isUtc, isFalse);
      expect(created.amount, 2);
      expect(created.unit, PortionUnit.scoop);
      expect(created.details, const MealDetails(appetite: Appetite.leftSome));
      expect(created.note, '换了新粮');
      expect(await entries.getById(created.id), isNotNull);
    });

    test('不填细节时按类型存空细节', () async {
      final created = await entries.create(
        EntryDraft(petId: 'lucky', type: EntryType.brushing, occurredAt: now),
      );
      expect(created.details, const BrushingDetails());
    });

    test('按狗、类型和时间段查询，按时间倒序', () async {
      await entries.create(potty('lucky', DateTime(2026, 10, 17, 8)));
      await entries.create(potty('lucky', DateTime(2026, 10, 18, 8)));
      await entries.create(potty('lucky', DateTime(2026, 10, 18, 20)));
      await entries.create(potty('mochi', DateTime(2026, 10, 18, 9)));
      await entries.create(
        EntryDraft(
          petId: 'lucky',
          type: EntryType.water,
          occurredAt: DateTime(2026, 10, 18, 10),
          amount: 750,
        ),
      );

      final today = await entries.findForPet(
        'lucky',
        types: {EntryType.potty},
        from: DateTime(2026, 10, 18),
        to: DateTime(2026, 10, 19),
      );
      expect(today.map((e) => e.occurredAt.hour), [20, 8]);
      expect(today.every((e) => e.petId == 'lucky'), isTrue);

      expect(await entries.findForPet('lucky'), hasLength(4));
      expect(await entries.findForPet('mochi'), hasLength(1));
      expect(await entries.findForPet('lucky', limit: 1), hasLength(1));
    });

    test('实时查询在写入后更新', () async {
      final stream = entries.watchForPet('lucky');
      final emissions = <int>[];
      final subscription = stream.listen((list) => emissions.add(list.length));
      await pumpEventQueue();
      await entries.create(potty('lucky', now));
      await pumpEventQueue();
      await subscription.cancel();
      expect(emissions, [0, 1]);
    });

    test('修改内容，保留创建时间', () async {
      final created = await entries.create(potty('lucky', now));
      now = now.add(const Duration(hours: 1));
      final updated = await entries.update(
        created.id,
        EntryDraft(
          petId: 'lucky',
          type: EntryType.potty,
          occurredAt: created.occurredAt,
          details: const PottyDetails(
            kind: PottyKind.poop,
            stool: StoolStatus.soft,
          ),
        ),
      );
      expect(
        updated.details,
        const PottyDetails(kind: PottyKind.poop, stool: StoolStatus.soft),
      );
      expect(updated.createdAt, created.createdAt);
      expect(updated.updatedAt, now);
    });

    test('不能把记录改到另一只狗或另一种类型', () async {
      final created = await entries.create(potty('lucky', now));
      expect(
        () => entries.update(created.id, potty('mochi', now)),
        throwsArgumentError,
      );
      expect(
        () => entries.update(
          created.id,
          EntryDraft(petId: 'lucky', type: EntryType.water, occurredAt: now),
        ),
        throwsArgumentError,
      );
    });

    test('删除', () async {
      final created = await entries.create(potty('lucky', now));
      expect(await entries.delete(created.id), isTrue);
      expect(await entries.delete(created.id), isFalse);
      expect(await entries.getById(created.id), isNull);
    });
  });

  group('校验', () {
    test('细节必须和类型对应', () {
      expect(
        () => entries.create(
          EntryDraft(
            petId: 'lucky',
            type: EntryType.meal,
            occurredAt: now,
            details: const WaterDetails(intake: WaterIntake.more),
          ),
        ),
        throwsArgumentError,
      );
    });

    test('体重必须是正数', () {
      for (final amount in [null, 0.0, -1.0, double.nan]) {
        expect(
          () => entries.create(
            EntryDraft(
              petId: 'lucky',
              type: EntryType.weight,
              occurredAt: now,
              amount: amount,
            ),
          ),
          throwsArgumentError,
          reason: '$amount',
        );
      }
    });

    test('只有饮食和用药带单位，并且数量和单位要同时填', () {
      expect(
        () => entries.create(
          EntryDraft(
            petId: 'lucky',
            type: EntryType.water,
            occurredAt: now,
            amount: 1,
            unit: PortionUnit.cup,
          ),
        ),
        throwsArgumentError,
      );
      expect(
        () => entries.create(
          EntryDraft(
            petId: 'lucky',
            type: EntryType.meal,
            occurredAt: now,
            amount: 2,
          ),
        ),
        throwsArgumentError,
      );
      expect(
        () => entries.create(
          EntryDraft(
            petId: 'lucky',
            type: EntryType.medication,
            occurredAt: now,
            amount: 1,
            unit: PortionUnit.scoop,
          ),
        ),
        throwsArgumentError,
      );
    });

    test('自定义记录必须有名称', () {
      expect(
        () => entries.create(
          EntryDraft(
            petId: 'lucky',
            type: EntryType.custom,
            occurredAt: now,
            label: '   ',
          ),
        ),
        throwsArgumentError,
      );
    });

    test('只有遛狗有开始、结束和距离', () {
      expect(
        () => entries.create(
          EntryDraft(
            petId: 'lucky',
            type: EntryType.bath,
            occurredAt: now,
            distanceM: 100,
          ),
        ),
        throwsArgumentError,
      );
    });
  });

  group('遛狗', () {
    test('开始即入库，结束时算出时长', () async {
      final started = await entries.startWalk('lucky');
      expect(started.isActiveWalk, isTrue);
      expect(started.startedAt, now);

      now = now.add(const Duration(minutes: 42));
      final finished = await entries.finishWalk('lucky', distanceM: 2400);
      expect(finished!.id, started.id);
      expect(finished.isActiveWalk, isFalse);
      expect(finished.durationSec, 42 * 60);
      expect(finished.distanceM, 2400);
    });

    test('已经在遛时不能再开始，另一只狗不受影响', () async {
      await entries.startWalk('lucky');
      await expectLater(
        entries.startWalk('lucky'),
        throwsA(isA<ActiveWalkExists>()),
      );
      await entries.startWalk('mochi');
      expect(await entries.watchActiveWalk('lucky').first, isNotNull);
    });

    test('重复结束不会产生新记录', () async {
      await entries.startWalk('lucky');
      now = now.add(const Duration(minutes: 10));
      expect(await entries.finishWalk('lucky'), isNotNull);
      expect(await entries.finishWalk('lucky'), isNull);
      expect(await entries.findForPet('lucky'), hasLength(1));
    });

    test('结束时间早于开始时间时按零时长处理', () async {
      await entries.startWalk('lucky');
      final finished = await entries.finishWalk(
        'lucky',
        at: now.subtract(const Duration(minutes: 5)),
      );
      expect(finished!.durationSec, 0);
    });

    test('补记一次已经结束的遛狗', () async {
      final walk = await entries.create(
        EntryDraft(
          petId: 'lucky',
          type: EntryType.walk,
          occurredAt: now,
          startedAt: DateTime(2026, 10, 17, 18),
          endedAt: DateTime(2026, 10, 17, 18, 30),
        ),
      );
      expect(walk.occurredAt, DateTime(2026, 10, 17, 18));
      expect(walk.durationSec, 1800);
      expect(
        () => entries.create(
          EntryDraft(petId: 'lucky', type: EntryType.walk, occurredAt: now),
        ),
        throwsArgumentError,
      );
    });

    test('正在进行的遛狗不能用普通修改', () async {
      final started = await entries.startWalk('lucky');
      expect(
        () => entries.update(
          started.id,
          EntryDraft(
            petId: 'lucky',
            type: EntryType.walk,
            occurredAt: now,
            startedAt: now,
            endedAt: now,
          ),
        ),
        throwsArgumentError,
      );
    });
  });
}
