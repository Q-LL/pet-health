import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_health/core/db/pet_health_database.dart' hide PetPresets;
import 'package:pet_health/features/entries/data/entries_repository.dart';
import 'package:pet_health/features/entries/domain/entry.dart';
import 'package:pet_health/features/entries/domain/entry_codes.dart';
import 'package:pet_health/features/entries/domain/entry_details.dart';
import 'package:pet_health/features/pets/data/pets_repository.dart';
import 'package:pet_health/features/pets/domain/pet.dart';
import 'package:pet_health/features/plans/data/plans_repository.dart';
import 'package:pet_health/features/plans/domain/plan.dart';
import 'package:pet_health/features/plans/domain/plan_codes.dart';
import 'package:pet_health/features/plans/domain/plan_schedule.dart';

void main() {
  late PetHealthDatabase db;
  late PlansRepository plans;
  late EntriesRepository entries;
  late DateTime now;
  late String petId;

  setUp(() async {
    db = PetHealthDatabase(NativeDatabase.memory());
    // 2026-10-14 是周三。
    now = DateTime(2026, 10, 14, 9);
    plans = PlansRepository(db, clock: () => now);
    entries = EntriesRepository(db, clock: () => now);
    // 混种：默认计划为梳毛、洗澡、体重。测试里先清掉，只看自己建的。
    petId = (await PetsRepository(
      db,
      clock: () => now,
    ).create(const PetDraft(name: 'Lucky'))).id;
    await db.delete(db.plans).go();
  });

  tearDown(() => db.close());

  PlanDraft draft(
    EntryType type,
    PlanSchedule schedule, {
    String? kind,
    String? title,
  }) => PlanDraft(
    petId: petId,
    entryType: type,
    schedule: schedule,
    entryKind: kind,
    title: title,
  );

  Future<Entry> log(EntryType type, DateTime at, {EntryDetails? details}) =>
      entries.create(
        EntryDraft(
          petId: petId,
          type: type,
          occurredAt: at,
          details: details,
          amount: type == EntryType.weight ? 30 : null,
        ),
      );

  Future<PlanStatus> statusOf(String planId) async =>
      (await plans.statusesFor(petId)).singleWhere((s) => s.plan.id == planId);

  group('增删改', () {
    test('新建为用户计划，读回排期', () async {
      final plan = await plans.create(
        draft(
          EntryType.brushing,
          OnWeekdays(Weekdays.forTimesPerWeek(3)),
        ).copyWithNotify(20 * 60),
      );
      expect(plan.source, PlanSource.user);
      expect(plan.schedule, OnWeekdays(Weekdays.forTimesPerWeek(3)));
      expect(plan.notifyMinute, 1200);
    });

    test('一次性事项的时间往返', () async {
      final vet = await plans.create(
        draft(
          EntryType.custom,
          Once(DateTime(2026, 10, 20, 15, 30)),
          title: ' 看医生 ',
        ),
      );
      expect(vet.schedule, Once(DateTime(2026, 10, 20, 15, 30)));
      expect(vet.title, '看医生');
    });

    test('修改后变为用户计划，并清除稍后提醒', () async {
      final plan = await plans.create(
        draft(EntryType.bath, const EveryNDays(35)),
      );
      await db
          .update(db.plans)
          .write(const PlansCompanion(source: Value(PlanSource.breedDefault)));
      await plans.snooze(plan.id, now.add(const Duration(hours: 2)));

      final updated = await plans.update(
        plan.id,
        draft(EntryType.bath, const EveryNDays(28)),
      );
      expect(updated.source, PlanSource.user);
      expect(updated.snoozedUntil, isNull);
      expect(updated.schedule, const EveryNDays(28));
    });

    test('从每 N 天改成星期几时清空旧的排期列', () async {
      final plan = await plans.create(
        draft(EntryType.bath, const EveryNDays(35)),
      );
      await plans.update(
        plan.id,
        draft(EntryType.bath, OnWeekdays(Weekdays.forTimesPerWeek(1))),
      );
      final row = await db.select(db.plans).getSingle();
      expect(row.intervalDays, isNull);
      expect(row.weekdays, Weekdays.forTimesPerWeek(1));
    });

    test('暂停、删除', () async {
      final plan = await plans.create(
        draft(EntryType.bath, const EveryNDays(35)),
      );
      await plans.setPaused(plan.id, paused: true);
      expect((await plans.getById(plan.id))!.paused, isTrue);
      expect(await plans.delete(plan.id), isTrue);
      expect(await plans.delete(plan.id), isFalse);
      expect(
        () => plans.setPaused(plan.id, paused: false),
        throwsArgumentError,
      );
    });

    test('校验', () {
      for (final bad in [
        draft(EntryType.bath, const EveryNDays(0)),
        draft(EntryType.bath, const EveryNDays(400)),
        draft(EntryType.brushing, const OnWeekdays(0)),
        draft(EntryType.brushing, const OnWeekdays(128)),
        draft(EntryType.custom, Once(now), title: '  '),
        draft(EntryType.bath, const EveryNDays(7), kind: 'nails'),
        draft(EntryType.otherCare, const EveryNDays(7), kind: 'wings'),
        draft(EntryType.bath, const EveryNDays(7)).copyWithNotify(1440),
      ]) {
        expect(() => plans.create(bad), throwsArgumentError);
      }
    });

    test('稍后提醒的时间必须在将来', () async {
      final plan = await plans.create(
        draft(EntryType.bath, const EveryNDays(35)),
      );
      expect(() => plans.snooze(plan.id, now), throwsArgumentError);
    });
  });

  group('驱虫与检查', () {
    Future<Entry> dose(DateTime at, Set<ParasiteCoverage> coverage) =>
        entries.create(
          EntryDraft(
            petId: petId,
            type: EntryType.parasitePrevention,
            occurredAt: at,
            details: ParasitePreventionDetails(coverage: coverage),
          ),
        );

    test('按覆盖范围匹配：复方药同时算作它覆盖的每一类', () async {
      final heartworm = await plans.create(
        draft(
          EntryType.parasitePrevention,
          const EveryNMonths(1),
          kind: ParasiteCoverage.heartworm.code,
        ),
      );
      final fleas = await plans.create(
        draft(
          EntryType.parasitePrevention,
          const EveryNDays(84),
          kind: ParasiteCoverage.fleasTicks.code,
        ),
      );

      // 只防跳蚤蜱虫的药，不算心丝虫预防。
      await dose(DateTime(2026, 9, 20), {ParasiteCoverage.fleasTicks});
      expect((await statusOf(heartworm.id)).lastDoneAt, isNull);
      expect((await statusOf(fleas.id)).lastDoneAt, DateTime(2026, 9, 20));

      // 复方药同时覆盖两类。
      await dose(DateTime(2026, 10, 1), {
        ParasiteCoverage.heartworm,
        ParasiteCoverage.fleasTicks,
        ParasiteCoverage.intestinal,
      });
      final heartwormStatus = await statusOf(heartworm.id);
      expect(heartwormStatus.lastDoneAt, DateTime(2026, 10, 1));
      expect(heartwormStatus.due.dueDay, DateTime(2026, 11, 1));
      expect(heartwormStatus.due.daysSinceLast, 13);
      expect((await statusOf(fleas.id)).lastDoneAt, DateTime(2026, 10, 1));
    });

    test('不指定覆盖范围的驱虫计划，任何一次驱虫都算', () async {
      final any = await plans.create(
        draft(EntryType.parasitePrevention, const EveryNMonths(3)),
      );
      await dose(DateTime(2026, 10, 2), {ParasiteCoverage.intestinal});
      expect((await statusOf(any.id)).lastDoneAt, DateTime(2026, 10, 2));
    });

    test('检查计划按检查项目匹配', () async {
      final fecal = await plans.create(
        draft(
          EntryType.vetTest,
          const EveryNMonths(6),
          kind: VetTestKind.fecal.code,
        ),
      );
      await entries.create(
        EntryDraft(
          petId: petId,
          type: EntryType.vetTest,
          occurredAt: DateTime(2026, 4, 10),
          details: const VetTestDetails(
            kind: VetTestKind.heartworm,
            result: VetTestResult.negative,
          ),
        ),
      );
      expect((await statusOf(fecal.id)).due.state, PlanState.notStarted);

      await entries.create(
        EntryDraft(
          petId: petId,
          type: EntryType.vetTest,
          occurredAt: DateTime(2026, 4, 12),
          details: const VetTestDetails(
            kind: VetTestKind.fecal,
            result: VetTestResult.negative,
          ),
        ),
      );
      final status = await statusOf(fecal.id);
      expect(status.due.state, PlanState.due);
      expect(status.due.dueDay, DateTime(2026, 10, 12));
    });

    test('每 N 个月的排期往返，校验月数和细分项', () async {
      final plan = await plans.create(
        draft(EntryType.vetTest, const EveryNMonths(12), kind: 'heartworm'),
      );
      expect(plan.schedule, const EveryNMonths(12));
      for (final bad in [
        draft(EntryType.vetTest, const EveryNMonths(0)),
        draft(EntryType.vetTest, const EveryNMonths(25)),
        draft(
          EntryType.parasitePrevention,
          const EveryNMonths(1),
          kind: 'wings',
        ),
        draft(EntryType.bath, const EveryNMonths(1), kind: 'heartworm'),
      ]) {
        expect(() => plans.create(bad), throwsArgumentError);
      }
    });
  });

  group('状态', () {
    test('每 N 天：没记录时未开始，记了之后按最近一次推算', () async {
      final bath = await plans.create(
        draft(EntryType.bath, const EveryNDays(35)),
      );
      expect((await statusOf(bath.id)).due.state, PlanState.notStarted);

      await log(EntryType.bath, DateTime(2026, 9, 1, 18));
      await log(EntryType.bath, DateTime(2026, 9, 20, 18));
      final status = await statusOf(bath.id);
      expect(status.lastDoneAt, DateTime(2026, 9, 20, 18));
      expect(status.due.state, PlanState.upcoming);
      expect(status.due.dueDay, DateTime(2026, 10, 25));
    });

    test('只算这只狗、不晚于现在的记录', () async {
      final other = await PetsRepository(
        db,
        clock: () => now,
      ).create(const PetDraft(name: 'Mochi'));
      final bath = await plans.create(
        draft(EntryType.bath, const EveryNDays(35)),
      );
      await entries.create(
        EntryDraft(petId: other.id, type: EntryType.bath, occurredAt: now),
      );
      // 记在未来的记录不算已完成。
      await log(EntryType.bath, now.add(const Duration(days: 2)));
      expect((await statusOf(bath.id)).due.state, PlanState.notStarted);
    });

    test('细分到 kind 的计划只算对应的记录', () async {
      final nails = await plans.create(
        draft(EntryType.otherCare, const EveryNDays(14), kind: 'nails'),
      );
      final anyCare = await plans.create(
        draft(EntryType.otherCare, const EveryNDays(14)),
      );
      await log(
        EntryType.otherCare,
        DateTime(2026, 10, 10),
        details: const OtherCareDetails(kind: OtherCareKind.teeth),
      );
      expect((await statusOf(nails.id)).lastDoneAt, isNull);
      expect((await statusOf(anyCare.id)).lastDoneAt, DateTime(2026, 10, 10));
    });

    test('星期几：周二提前做过，周三不提醒', () async {
      final brushing = await plans.create(
        draft(EntryType.brushing, OnWeekdays(Weekdays.maskOf(const [1, 3, 5]))),
      );
      expect((await statusOf(brushing.id)).due.state, PlanState.due);
      await log(EntryType.brushing, DateTime(2026, 10, 13, 20));
      final status = await statusOf(brushing.id);
      expect(status.due.state, PlanState.upcoming);
      expect(status.due.dueDay, DateTime(2026, 10, 16));
    });

    test('一次性事项只算关联到它的记录', () async {
      final vet = await plans.create(
        draft(EntryType.custom, Once(DateTime(2026, 10, 14, 15)), title: '复查'),
      );
      await entries.create(
        EntryDraft(
          petId: petId,
          type: EntryType.custom,
          occurredAt: DateTime(2026, 10, 14, 8),
          label: '别的事',
        ),
      );
      expect((await statusOf(vet.id)).due.state, PlanState.due);

      await entries.create(
        EntryDraft(
          petId: petId,
          type: EntryType.custom,
          occurredAt: DateTime(2026, 10, 14, 8, 30),
          label: '复查',
          planId: vet.id,
        ),
      );
      expect((await statusOf(vet.id)).due.state, PlanState.completed);
    });

    test('稍后提醒，做过一次后作废', () async {
      final brushing = await plans.create(
        draft(EntryType.brushing, const OnWeekdays(Weekdays.all)),
      );
      await plans.snooze(brushing.id, now.add(const Duration(hours: 3)));
      expect((await statusOf(brushing.id)).due.state, PlanState.snoozed);

      await log(EntryType.brushing, now);
      final status = await statusOf(brushing.id);
      expect(status.plan.snoozedUntil, isNull);
      expect(status.due.state, PlanState.upcoming);
    });

    test('排序：该做了、稍后、即将到来、未开始、已完成，暂停的在最后', () async {
      final paused = await plans.create(
        draft(EntryType.earCheck, const OnWeekdays(Weekdays.all)),
      );
      await plans.setPaused(paused.id, paused: true);
      final notStarted = await plans.create(
        draft(EntryType.bath, const EveryNDays(35)),
      );
      final later = await plans.create(
        draft(EntryType.weight, const EveryNDays(30)),
      );
      final sooner = await plans.create(
        draft(EntryType.grooming, const EveryNDays(30)),
      );
      final done = await plans.create(
        draft(EntryType.custom, Once(DateTime(2026, 10, 1)), title: '复查'),
      );
      final snoozed = await plans.create(
        draft(EntryType.potty, const OnWeekdays(Weekdays.all)),
      );
      final due = await plans.create(
        draft(EntryType.brushing, const OnWeekdays(Weekdays.all)),
      );
      await log(EntryType.weight, DateTime(2026, 10, 10));
      await log(EntryType.grooming, DateTime(2026, 10, 1));
      await entries.create(
        EntryDraft(
          petId: petId,
          type: EntryType.custom,
          occurredAt: DateTime(2026, 10, 1),
          label: '复查',
          planId: done.id,
        ),
      );
      await plans.snooze(snoozed.id, now.add(const Duration(hours: 1)));

      final order = (await plans.statusesFor(petId)).map((s) => s.plan.id);
      expect(order, [
        due.id,
        snoozed.id,
        sooner.id,
        later.id,
        notStarted.id,
        done.id,
        paused.id,
      ]);
    });

    test('实时状态在记录写入后更新', () async {
      final bath = await plans.create(
        draft(EntryType.bath, const EveryNDays(35)),
      );
      final states = <PlanState>[];
      final subscription = plans.watchStatuses(petId).listen((list) {
        if (list.isNotEmpty) states.add(list.single.due.state);
      });
      await pumpEventQueue();
      await log(EntryType.bath, DateTime(2026, 10, 1));
      await pumpEventQueue();
      await plans.delete(bath.id);
      await pumpEventQueue();
      await subscription.cancel();
      expect(states, [PlanState.notStarted, PlanState.upcoming]);
    });
  });
}

extension on PlanDraft {
  PlanDraft copyWithNotify(int minute) => PlanDraft(
    petId: petId,
    entryType: entryType,
    schedule: schedule,
    entryKind: entryKind,
    title: title,
    notifyMinute: minute,
    paused: paused,
  );
}
