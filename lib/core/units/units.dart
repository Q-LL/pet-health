import '../codes/coded_enum.dart';

/// 体重单位。数据库一律存 kg。
enum WeightUnit implements CodedEnum {
  kg('kg', 1),
  lb('lb', 0.45359237),
  jin('jin', 0.5);

  const WeightUnit(this.code, this._kgPerUnit);

  @override
  final String code;
  final double _kgPerUnit;

  double toKg(double value) => value * _kgPerUnit;
  double fromKg(double kg) => kg / _kgPerUnit;
}

/// 液体体积单位，用于饮水。数据库一律存 ml。
///
/// `oz` 和 `cup` 均为美制液量单位。
enum VolumeUnit implements CodedEnum {
  ml('ml', 1),
  oz('oz', 29.5735295625),
  cup('cup', 236.5882365);

  const VolumeUnit(this.code, this._mlPerUnit);

  @override
  final String code;
  final double _mlPerUnit;

  double toMl(double value) => value * _mlPerUnit;
  double fromMl(double ml) => ml / _mlPerUnit;
}

/// 距离单位。数据库一律存 m。
enum DistanceUnit implements CodedEnum {
  km('km', 1000),
  mi('mi', 1609.344);

  const DistanceUnit(this.code, this._metersPerUnit);

  @override
  final String code;
  final double _metersPerUnit;

  double toMeters(double value) => value * _metersPerUnit;
  double fromMeters(double meters) => meters / _metersPerUnit;
}

/// 温度单位。数据库与天气缓存一律存 °C。
enum TemperatureUnit implements CodedEnum {
  c('c'),
  f('f');

  const TemperatureUnit(this.code);

  @override
  final String code;

  double toCelsius(double value) => this == c ? value : (value - 32) * 5 / 9;
  double fromCelsius(double celsius) =>
      this == c ? celsius : celsius * 9 / 5 + 32;
}

/// 份量单位：饮食和用药按用户选的单位原样存，不做换算。
///
/// 一勺或一杯狗粮有多少克取决于粮的密度，无法精确换算。
enum PortionUnit implements CodedEnum {
  scoop('scoop'),
  cup('cup'),
  g('g'),
  can('can'),
  pouch('pouch'),
  piece('piece'),
  tablet('tablet'),
  ml('ml'),
  mg('mg'),
  drop('drop');

  const PortionUnit(this.code);

  @override
  final String code;

  /// 可作为食物单位的值。
  static const food = [scoop, cup, g, can, pouch, piece];

  /// 可作为用药剂量单位的值。
  static const medication = [tablet, piece, ml, mg, drop];
}
