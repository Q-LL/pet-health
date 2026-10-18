import 'package:flutter/foundation.dart';

import '../../../core/codes/coded_enum.dart';

enum PlanScheduleKind implements CodedEnum {
  everyNDays('every_n_days'),
  weekdays('weekdays'),
  once('once');

  const PlanScheduleKind(this.code);

  @override
  final String code;
}

/// 计划的排期方式。
@immutable
sealed class PlanSchedule {
  const PlanSchedule();

  PlanScheduleKind get kind;
}

/// 从上一次实际完成往后推 [days] 天。
final class EveryNDays extends PlanSchedule {
  const EveryNDays(this.days);

  final int days;

  @override
  PlanScheduleKind get kind => PlanScheduleKind.everyNDays;

  @override
  bool operator ==(Object other) => other is EveryNDays && days == other.days;

  @override
  int get hashCode => days.hashCode;
}

/// 每周固定的几天，[mask] 见 [Weekdays]。
final class OnWeekdays extends PlanSchedule {
  const OnWeekdays(this.mask);

  final int mask;

  @override
  PlanScheduleKind get kind => PlanScheduleKind.weekdays;

  @override
  bool operator ==(Object other) => other is OnWeekdays && mask == other.mask;

  @override
  int get hashCode => mask.hashCode;
}

/// 一次性事项，比如看医生的预约。
final class Once extends PlanSchedule {
  const Once(this.dueAt);

  /// 本地时间。
  final DateTime dueAt;

  @override
  PlanScheduleKind get kind => PlanScheduleKind.once;

  @override
  bool operator ==(Object other) => other is Once && dueAt == other.dueAt;

  @override
  int get hashCode => dueAt.hashCode;
}

/// 星期几的位掩码，周一 = 1、周二 = 2、周三 = 4 … 周日 = 64。
///
/// 星期几的取值与 [DateTime.weekday] 一致：1 是周一，7 是周日。
abstract final class Weekdays {
  static const all = 0x7f;

  static int bit(int weekday) {
    assert(weekday >= DateTime.monday && weekday <= DateTime.sunday);
    return 1 << (weekday - 1);
  }

  static int maskOf(Iterable<int> weekdays) =>
      weekdays.fold(0, (mask, weekday) => mask | bit(weekday));

  static bool contains(int mask, int weekday) => mask & bit(weekday) != 0;

  static List<int> toList(int mask) => [
    for (var weekday = DateTime.monday; weekday <= DateTime.sunday; weekday++)
      if (contains(mask, weekday)) weekday,
  ];

  /// 犬种默认值"每周 N 次"对应的星期几。
  static int forTimesPerWeek(int times) => switch (times) {
    <= 0 => 0,
    1 => maskOf(const [DateTime.saturday]),
    2 => maskOf(const [DateTime.monday, DateTime.thursday]),
    3 => maskOf(const [DateTime.monday, DateTime.wednesday, DateTime.friday]),
    4 => maskOf(const [
      DateTime.monday,
      DateTime.wednesday,
      DateTime.friday,
      DateTime.sunday,
    ]),
    5 => maskOf(const [1, 2, 3, 4, 5]),
    6 => maskOf(const [1, 2, 3, 4, 5, 6]),
    _ => all,
  };
}

enum PlanState {
  /// 每 N 天的计划还没有任何记录，不知道从哪天算起，不催促。
  notStarted,

  /// 还没到时间。
  upcoming,

  /// 今天该做了（每 N 天的计划也可能已经过了几天）。
  due,

  /// 该做了，但用户点了"稍后提醒"。
  snoozed,

  /// 一次性事项已经完成。
  completed,
}

/// 某一时刻计划的状态。
@immutable
class PlanDue {
  const PlanDue(this.state, {this.dueDay, this.daysSinceLast});

  final PlanState state;

  /// 该做的那一天（本地日期的零点）；未开始或已完成时为 `null`。
  ///
  /// 每 N 天的计划过期后它会早于今天；页面用 [daysSinceLast] 描述，
  /// 不显示"逾期几天"。
  final DateTime? dueDay;

  /// 距离上一次完成过了几个自然日；没有记录时为 `null`。
  final int? daysSinceLast;

  @override
  bool operator ==(Object other) =>
      other is PlanDue &&
      state == other.state &&
      dueDay == other.dueDay &&
      daysSinceLast == other.daysSinceLast;

  @override
  int get hashCode => Object.hash(state, dueDay, daysSinceLast);

  @override
  String toString() =>
      'PlanDue($state, dueDay: $dueDay, since: $daysSinceLast)';
}

/// 计算计划在 [now] 的状态。所有时间都是本地时间。
///
/// [lastDoneAt] 是不晚于 [now] 的最近一条匹配记录：每 N 天和星期几的计划
/// 按记录类型匹配；一次性事项只算关联到这个计划的记录。
PlanDue evaluatePlan(
  PlanSchedule schedule, {
  required DateTime now,
  DateTime? lastDoneAt,
  DateTime? snoozedUntil,
}) {
  final today = _day(now);
  final lastDay = lastDoneAt == null ? null : _day(lastDoneAt);
  final since = lastDay == null ? null : _daysBetween(lastDay, today);

  PlanDue dueOn(DateTime day) {
    if (day.isAfter(today)) {
      return PlanDue(PlanState.upcoming, dueDay: day, daysSinceLast: since);
    }
    final snoozed = snoozedUntil != null && now.isBefore(snoozedUntil);
    return PlanDue(
      snoozed ? PlanState.snoozed : PlanState.due,
      dueDay: day,
      daysSinceLast: since,
    );
  }

  switch (schedule) {
    case EveryNDays(:final days):
      if (lastDay == null) return const PlanDue(PlanState.notStarted);
      return dueOn(_addDays(lastDay, days));

    case OnWeekdays(:final mask):
      if (mask & Weekdays.all == 0) {
        return PlanDue(PlanState.upcoming, daysSinceLast: since);
      }
      // 每个选中日负责从上一个选中日的第二天到当天；这段时间内做过就算完成。
      bool satisfied(DateTime slot) =>
          lastDay != null && !lastDay.isBefore(_windowStart(mask, slot));
      if (Weekdays.contains(mask, today.weekday) && !satisfied(today)) {
        return dueOn(today);
      }
      var next = _nextSelected(mask, today);
      // 提前做过的话，最近一个选中日已经完成；之后的选中日不可能被过去的记录满足。
      if (satisfied(next)) next = _nextSelected(mask, next);
      return dueOn(next);

    case Once(:final dueAt):
      if (lastDay != null) {
        return PlanDue(PlanState.completed, daysSinceLast: since);
      }
      return dueOn(_day(dueAt));
  }
}

DateTime _day(DateTime time) => DateTime(time.year, time.month, time.day);

/// 按日历加天数，不受夏令时影响。
DateTime _addDays(DateTime day, int days) =>
    DateTime(day.year, day.month, day.day + days);

int _daysBetween(DateTime from, DateTime to) => DateTime.utc(
  to.year,
  to.month,
  to.day,
).difference(DateTime.utc(from.year, from.month, from.day)).inDays;

/// [day] 之后（不含当天）的第一个选中日。
DateTime _nextSelected(int mask, DateTime day) {
  for (var offset = 1; offset <= 7; offset++) {
    final candidate = _addDays(day, offset);
    if (Weekdays.contains(mask, candidate.weekday)) return candidate;
  }
  throw StateError('weekday mask $mask selects no day');
}

/// 选中日 [slot] 负责的时间段的第一天：上一个选中日的第二天。
DateTime _windowStart(int mask, DateTime slot) {
  for (var offset = 1; offset <= 7; offset++) {
    final candidate = _addDays(slot, -offset);
    if (Weekdays.contains(mask, candidate.weekday)) {
      return _addDays(candidate, 1);
    }
  }
  throw StateError('weekday mask $mask selects no day');
}
