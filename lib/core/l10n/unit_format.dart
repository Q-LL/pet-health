import '../../features/plans/domain/plan_schedule.dart';
import '../format/date_display.dart';
import '../units/units.dart';
import 'generated/app_localizations.dart';

/// 带单位的数量和排期的显示文字。
///
/// 传入的都是标准单位（体重 kg、水量 ml、距离 m、温度 °C），
/// 在这里换算成用户设置的单位并按单位四舍五入。
extension UnitFormat on AppLocalizations {
  /// 体重保留 1 位小数。
  String weight(double kg, WeightUnit unit) {
    final value = _round(unit.fromKg(kg), 1);
    return switch (unit) {
      WeightUnit.kg => weightKg(value),
      WeightUnit.lb => weightLb(value),
      WeightUnit.jin => weightJin(value),
    };
  }

  /// ml 和 oz 取整，杯保留 1 位小数。
  String water(double ml, VolumeUnit unit) => switch (unit) {
    VolumeUnit.ml => volumeMl(_round(ml, 0)),
    VolumeUnit.oz => volumeOz(_round(unit.fromMl(ml), 0)),
    VolumeUnit.cup => volumeCup(_round(unit.fromMl(ml), 1)),
  };

  /// 距离保留 1 位小数。
  String distance(double meters, DistanceUnit unit) {
    final value = _round(unit.fromMeters(meters), 1);
    return switch (unit) {
      DistanceUnit.km => distanceKm(value),
      DistanceUnit.mi => distanceMi(value),
    };
  }

  /// 温度取整。
  String temperature(double celsius, TemperatureUnit unit) {
    final value = _round(unit.fromCelsius(celsius), 0);
    return switch (unit) {
      TemperatureUnit.c => temperatureC(value),
      TemperatureUnit.f => temperatureF(value),
    };
  }

  /// 份量原样显示，最多 2 位小数（如 0.25 杯）。
  String portion(double amount, PortionUnit unit) {
    final value = _round(amount, 2);
    return switch (unit) {
      PortionUnit.scoop => portionScoop(value),
      PortionUnit.cup => portionCup(value),
      PortionUnit.g => portionG(value),
      PortionUnit.can => portionCan(value),
      PortionUnit.pouch => portionPouch(value),
      PortionUnit.piece => portionPiece(value),
      PortionUnit.tablet => portionTablet(value),
      PortionUnit.ml => portionMl(value),
      PortionUnit.mg => portionMg(value),
      PortionUnit.drop => portionDrop(value),
    };
  }

  /// 排期的描述，比如"每 35 天""每周一、三、五""每月"。
  ///
  /// [dateFormat] 用于一次性事项的日期，应先经过 [DateDisplayFormat.resolve]。
  String schedule(
    PlanSchedule value, {
    required DateDisplayFormat dateFormat,
  }) => switch (value) {
    // 整周的间隔按周说："每 6 周"比"每 42 天"好懂。
    EveryNDays(:final days) when days % 7 == 0 =>
      days == 7 ? scheduleEveryWeek : scheduleEveryNWeeks(days ~/ 7),
    EveryNDays(:final days) => scheduleEveryNDays(days),
    EveryNMonths(:final months) =>
      months == 12 ? scheduleEveryYear : scheduleEveryNMonths(months),
    OnWeekdays(:final mask) =>
      mask & Weekdays.all == Weekdays.all
          ? scheduleEveryDay
          : scheduleWeekdays(
              Weekdays.toList(
                mask,
              ).map(weekdayShort).join(weekdayListSeparator),
            ),
    Once(:final dueAt) => scheduleOnce(formatDisplayDate(dueAt, dateFormat)),
  };

  /// 星期几的简称，1 是周一。
  String weekdayShort(int weekday) => switch (weekday) {
    DateTime.monday => weekdayShort1,
    DateTime.tuesday => weekdayShort2,
    DateTime.wednesday => weekdayShort3,
    DateTime.thursday => weekdayShort4,
    DateTime.friday => weekdayShort5,
    DateTime.saturday => weekdayShort6,
    _ => weekdayShort7,
  };
}

/// 四舍五入到 [digits] 位小数；避免显示 "-0"。
double _round(double value, int digits) {
  final factor = switch (digits) {
    0 => 1,
    1 => 10,
    _ => 100,
  };
  final rounded = (value * factor).round() / factor;
  return rounded == 0 ? 0 : rounded;
}
