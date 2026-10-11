import 'package:flutter/foundation.dart';

import '../codes/coded_enum.dart';
import 'units.dart';

/// 单位制总开关。
enum UnitSystem implements CodedEnum {
  auto('auto'),
  metric('metric'),
  imperial('imperial');

  const UnitSystem(this.code);

  @override
  final String code;
}

/// 用户的单位设置。各项单独设置时优先，否则跟随 [system]。
@immutable
class UnitPreferences {
  const UnitPreferences({
    this.system = UnitSystem.auto,
    this.weight,
    this.water,
    this.distance,
    this.temperature,
    this.food,
  });

  final UnitSystem system;
  final WeightUnit? weight;
  final VolumeUnit? water;
  final DistanceUnit? distance;
  final TemperatureUnit? temperature;
  final PortionUnit? food;

  /// 按"单独设置 > 单位制 > 系统地区"决定实际使用的单位。
  ///
  /// [countryCode] 是系统地区的 ISO 3166 代码，如 `US`、`CN`。
  ResolvedUnits resolve({String? countryCode}) {
    final imperial = switch (system) {
      UnitSystem.metric => false,
      UnitSystem.imperial => true,
      UnitSystem.auto => _imperialRegions.contains(countryCode?.toUpperCase()),
    };
    return ResolvedUnits(
      weight: weight ?? (imperial ? WeightUnit.lb : WeightUnit.kg),
      water: water ?? (imperial ? VolumeUnit.oz : VolumeUnit.ml),
      distance: distance ?? (imperial ? DistanceUnit.mi : DistanceUnit.km),
      temperature:
          temperature ?? (imperial ? TemperatureUnit.f : TemperatureUnit.c),
      food: food ?? (imperial ? PortionUnit.cup : PortionUnit.g),
    );
  }

  /// 日常使用英制单位的地区。
  static const _imperialRegions = {'US', 'LR', 'MM'};

  @override
  bool operator ==(Object other) =>
      other is UnitPreferences &&
      system == other.system &&
      weight == other.weight &&
      water == other.water &&
      distance == other.distance &&
      temperature == other.temperature &&
      food == other.food;

  @override
  int get hashCode =>
      Object.hash(system, weight, water, distance, temperature, food);
}

/// 已经决定好的显示单位。
@immutable
class ResolvedUnits {
  const ResolvedUnits({
    required this.weight,
    required this.water,
    required this.distance,
    required this.temperature,
    required this.food,
  });

  final WeightUnit weight;
  final VolumeUnit water;
  final DistanceUnit distance;
  final TemperatureUnit temperature;
  final PortionUnit food;
}
