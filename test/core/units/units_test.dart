import 'package:flutter_test/flutter_test.dart';
import 'package:pet_health/core/units/unit_preferences.dart';
import 'package:pet_health/core/units/units.dart';

void main() {
  group('换算', () {
    test('体重：kg、lb、斤', () {
      expect(WeightUnit.lb.fromKg(1), closeTo(2.20462, 1e-5));
      expect(WeightUnit.jin.fromKg(31.2), closeTo(62.4, 1e-9));
      expect(WeightUnit.lb.fromKg(29.8), closeTo(65.7, 0.05));
    });

    test('体积：ml、美制液量盎司、杯', () {
      expect(VolumeUnit.oz.fromMl(750), closeTo(25.36, 0.01));
      expect(VolumeUnit.cup.toMl(1), closeTo(236.588, 1e-3));
    });

    test('距离：km、mi', () {
      expect(DistanceUnit.mi.fromMeters(538000), closeTo(334.3, 0.05));
      expect(DistanceUnit.km.toMeters(1.5), 1500);
    });

    test('温度：°C、°F', () {
      expect(TemperatureUnit.f.fromCelsius(33), closeTo(91.4, 1e-9));
      expect(TemperatureUnit.f.toCelsius(32), 0);
      expect(TemperatureUnit.c.fromCelsius(21.5), 21.5);
    });

    test('往返不丢精度', () {
      for (final unit in WeightUnit.values) {
        expect(unit.toKg(unit.fromKg(28.35)), closeTo(28.35, 1e-9));
      }
      for (final unit in VolumeUnit.values) {
        expect(unit.toMl(unit.fromMl(750)), closeTo(750, 1e-9));
      }
      for (final unit in DistanceUnit.values) {
        expect(unit.toMeters(unit.fromMeters(4321)), closeTo(4321, 1e-9));
      }
      for (final unit in TemperatureUnit.values) {
        expect(unit.toCelsius(unit.fromCelsius(-7.5)), closeTo(-7.5, 1e-9));
      }
    });
  });

  group('单位优先级', () {
    test('自动：美国用英制，其他地区用公制', () {
      const prefs = UnitPreferences();
      final us = prefs.resolve(countryCode: 'us');
      expect(us.weight, WeightUnit.lb);
      expect(us.water, VolumeUnit.oz);
      expect(us.distance, DistanceUnit.mi);
      expect(us.temperature, TemperatureUnit.f);
      expect(us.food, PortionUnit.cup);

      final cn = prefs.resolve(countryCode: 'CN');
      expect(cn.weight, WeightUnit.kg);
      expect(cn.water, VolumeUnit.ml);
      expect(cn.food, PortionUnit.g);
    });

    test('不知道地区时用公制', () {
      expect(const UnitPreferences().resolve().weight, WeightUnit.kg);
    });

    test('单位制开关优先于地区', () {
      const prefs = UnitPreferences(system: UnitSystem.metric);
      expect(prefs.resolve(countryCode: 'US').weight, WeightUnit.kg);
      const imperial = UnitPreferences(system: UnitSystem.imperial);
      expect(imperial.resolve(countryCode: 'CN').distance, DistanceUnit.mi);
    });

    test('单独设置优先于单位制', () {
      const prefs = UnitPreferences(
        system: UnitSystem.imperial,
        weight: WeightUnit.kg,
        food: PortionUnit.scoop,
      );
      final units = prefs.resolve(countryCode: 'US');
      expect(units.weight, WeightUnit.kg);
      expect(units.food, PortionUnit.scoop);
      expect(units.water, VolumeUnit.oz);
    });
  });
}
