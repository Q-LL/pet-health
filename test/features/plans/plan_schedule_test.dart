import 'package:flutter_test/flutter_test.dart';
import 'package:pet_health/features/plans/domain/plan_schedule.dart';

// 2026-10-12 是周一。
DateTime _d(int day, [int hour = 9]) => DateTime(2026, 10, day, hour);
DateTime _day(int day) => DateTime(2026, 10, day);

final _monWedFri = OnWeekdays(
  Weekdays.maskOf(const [DateTime.monday, DateTime.wednesday, DateTime.friday]),
);

void main() {
  group('Weekdays', () {
    test('位掩码与文档一致', () {
      expect(Weekdays.bit(DateTime.monday), 1);
      expect(Weekdays.bit(DateTime.wednesday), 4);
      expect(Weekdays.bit(DateTime.sunday), 64);
      expect(Weekdays.toList(Weekdays.maskOf(const [5, 1, 3])), [1, 3, 5]);
    });

    test('犬种默认的每周次数', () {
      expect(Weekdays.toList(Weekdays.forTimesPerWeek(2)), [1, 4]);
      expect(Weekdays.toList(Weekdays.forTimesPerWeek(3)), [1, 3, 5]);
      expect(Weekdays.toList(Weekdays.forTimesPerWeek(4)), [1, 3, 5, 7]);
      expect(Weekdays.forTimesPerWeek(7), Weekdays.all);
      for (var times = 1; times <= 7; times++) {
        expect(
          Weekdays.toList(Weekdays.forTimesPerWeek(times)),
          hasLength(times),
        );
      }
    });
  });

  group('每 N 天', () {
    const bath = EveryNDays(35);

    test('没有记录时不催促', () {
      expect(
        evaluatePlan(bath, now: _d(12)),
        const PlanDue(PlanState.notStarted),
      );
    });

    test('从上一次实际完成往后推', () {
      final result = evaluatePlan(bath, now: _d(12), lastDoneAt: _d(1, 20));
      expect(result.state, PlanState.upcoming);
      expect(result.dueDay, DateTime(2026, 11, 5));
      expect(result.daysSinceLast, 11);
    });

    test('到期当天和过了几天都算该做了', () {
      const every3 = EveryNDays(3);
      expect(
        evaluatePlan(every3, now: _d(15), lastDoneAt: _d(12)),
        PlanDue(PlanState.due, dueDay: _day(15), daysSinceLast: 3),
      );
      expect(
        evaluatePlan(every3, now: _d(20), lastDoneAt: _d(12)),
        PlanDue(PlanState.due, dueDay: _day(15), daysSinceLast: 8),
      );
    });

    test('按自然日计算，与几点完成无关', () {
      const daily = EveryNDays(1);
      final result = evaluatePlan(
        daily,
        now: _d(13, 0),
        lastDoneAt: _d(12, 23),
      );
      expect(result.state, PlanState.due);
      expect(result.daysSinceLast, 1);
    });

    test('跨夏令时切换仍按日历天数', () {
      // 美国 2026-11-01 结束夏令时；本地日历加天数不受影响。
      const weekly = EveryNDays(7);
      final result = evaluatePlan(
        weekly,
        now: DateTime(2026, 11, 3, 12),
        lastDoneAt: DateTime(2026, 10, 29, 8),
      );
      expect(result.dueDay, DateTime(2026, 11, 5));
      expect(result.daysSinceLast, 5);
    });
  });

  group('星期几', () {
    test('选中日当天还没做，就该做了', () {
      expect(
        evaluatePlan(_monWedFri, now: _d(14), lastDoneAt: _d(12)),
        PlanDue(PlanState.due, dueDay: _day(14), daysSinceLast: 2),
      );
    });

    test('提前做过，下一个选中日不再提醒', () {
      // 周二梳过，周三负责周二到周三，已经完成；下一次是周五。
      final tuesday = evaluatePlan(
        _monWedFri,
        now: _d(13, 20),
        lastDoneAt: _d(13, 8),
      );
      expect(tuesday.state, PlanState.upcoming);
      expect(tuesday.dueDay, _day(16));

      final wednesday = evaluatePlan(
        _monWedFri,
        now: _d(14),
        lastDoneAt: _d(13),
      );
      expect(wednesday.state, PlanState.upcoming);
      expect(wednesday.dueDay, _day(16));
    });

    test('当天做完后显示下一个选中日', () {
      final result = evaluatePlan(
        _monWedFri,
        now: _d(14, 21),
        lastDoneAt: _d(14, 20),
      );
      expect(result.state, PlanState.upcoming);
      expect(result.dueDay, _day(16));
    });

    test('错过的选中日不累积', () {
      // 周三没做，周四不提醒，下一次是周五。
      final result = evaluatePlan(_monWedFri, now: _d(15), lastDoneAt: _d(12));
      expect(result.state, PlanState.upcoming);
      expect(result.dueDay, _day(16));
    });

    test('非选中日、没有记录时显示下一个选中日', () {
      final result = evaluatePlan(_monWedFri, now: _d(13));
      expect(result.state, PlanState.upcoming);
      expect(result.dueDay, _day(14));
      expect(result.daysSinceLast, isNull);
    });

    test('选中日、没有记录时就该做了', () {
      expect(evaluatePlan(_monWedFri, now: _d(12)).state, PlanState.due);
    });

    test('只选一天时负责整整一周', () {
      final saturday = OnWeekdays(Weekdays.maskOf(const [DateTime.saturday]));
      // 周日（10/11）做过，覆盖到周六（10/17）。
      expect(
        evaluatePlan(saturday, now: _d(17), lastDoneAt: _d(11)).state,
        PlanState.upcoming,
      );
      // 上周六（10/10）做的，不算这周。
      expect(
        evaluatePlan(saturday, now: _d(17), lastDoneAt: _d(10)).state,
        PlanState.due,
      );
    });

    test('每天的计划', () {
      const daily = OnWeekdays(Weekdays.all);
      expect(
        evaluatePlan(daily, now: _d(14), lastDoneAt: _d(13)).state,
        PlanState.due,
      );
      final done = evaluatePlan(daily, now: _d(14, 20), lastDoneAt: _d(14, 8));
      expect(done.state, PlanState.upcoming);
      expect(done.dueDay, _day(15));
    });

    test('一天都没选时不会到期', () {
      expect(
        evaluatePlan(const OnWeekdays(0), now: _d(14)).state,
        PlanState.upcoming,
      );
    });
  });

  group('一次性事项', () {
    final vet = Once(DateTime(2026, 10, 20, 15, 30));

    test('到日子前是 upcoming，当天起该做了', () {
      expect(evaluatePlan(vet, now: _d(18)).state, PlanState.upcoming);
      expect(evaluatePlan(vet, now: _d(20, 8)).state, PlanState.due);
      expect(evaluatePlan(vet, now: _d(22)).state, PlanState.due);
    });

    test('有关联记录就完成，不再提醒', () {
      expect(
        evaluatePlan(vet, now: _d(22), lastDoneAt: _d(20, 16)).state,
        PlanState.completed,
      );
    });
  });

  group('稍后提醒', () {
    test('该做的计划在稍后时间之前显示为 snoozed', () {
      const daily = OnWeekdays(Weekdays.all);
      final result = evaluatePlan(
        daily,
        now: _d(14, 9),
        lastDoneAt: _d(13),
        snoozedUntil: _d(14, 18),
      );
      expect(result.state, PlanState.snoozed);
      expect(result.dueDay, _day(14));
    });

    test('过了稍后时间恢复为该做了', () {
      const daily = OnWeekdays(Weekdays.all);
      expect(
        evaluatePlan(
          daily,
          now: _d(14, 19),
          lastDoneAt: _d(13),
          snoozedUntil: _d(14, 18),
        ).state,
        PlanState.due,
      );
    });

    test('还没到期的计划不受影响', () {
      expect(
        evaluatePlan(
          const EveryNDays(30),
          now: _d(14),
          lastDoneAt: _d(13),
          snoozedUntil: _d(15),
        ).state,
        PlanState.upcoming,
      );
    });
  });
}
