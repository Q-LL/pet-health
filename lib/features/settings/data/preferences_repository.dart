import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/codes/coded_enum.dart';
import '../../../core/db/database_provider.dart';
import '../../../core/db/pet_health_database.dart';
import '../../../core/format/date_display.dart';
import '../../../core/units/unit_preferences.dart';
import '../../../core/units/units.dart';
import '../../cards/domain/card_codes.dart';
import '../domain/app_preferences.dart';

final preferencesRepositoryProvider = Provider<PreferencesRepository>((ref) {
  return PreferencesRepository(
    ref.watch(petHealthDatabaseProvider),
    clock: ref.watch(clockProvider),
  );
});

final appPreferencesProvider = StreamProvider<AppPreferences>((ref) {
  return ref.watch(preferencesRepositoryProvider).watch();
});

/// `app_settings` 表里的键。
abstract final class PreferenceKeys {
  static const selectedPetId = 'selectedPetId';
  static const language = 'locale';
  static const dateFormat = 'dateFormat';
  static const unitSystem = 'unitSystem';
  static const weightUnit = 'unit.weight';
  static const waterUnit = 'unit.water';
  static const distanceUnit = 'unit.distance';
  static const temperatureUnit = 'unit.temperature';
  static const foodUnit = 'unit.food';
  static const weather = 'weather';
  static String cards(CardCategory category) => 'cards.${category.code}';
}

/// 写一个设置；[value] 为空时删除这个键，回到默认值。
///
/// 给需要在同一事务里改设置的 Repository 使用，比如新建或删除狗狗时切换当前狗狗。
Future<void> putPreference(
  PetHealthDatabase db,
  String key,
  String? value, {
  required DateTime now,
}) async {
  if (value == null) {
    await (db.delete(db.appSettings)..where((t) => t.key.equals(key))).go();
  } else {
    await db
        .into(db.appSettings)
        .insertOnConflictUpdate(
          AppSettingsCompanion.insert(
            key: key,
            value: value,
            updatedAt: now.toUtc(),
          ),
        );
  }
}

class PreferencesRepository {
  PreferencesRepository(this._db, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final PetHealthDatabase _db;
  final DateTime Function() _clock;

  Stream<AppPreferences> watch() =>
      _db.select(_db.appSettings).watch().map(_fromRows);

  Future<AppPreferences> get() =>
      _db.select(_db.appSettings).get().then(_fromRows);

  Future<void> setSelectedPet(String? petId) =>
      _put(PreferenceKeys.selectedPetId, petId);

  Future<void> setLanguage(AppLanguage language) => _put(
    PreferenceKeys.language,
    language == AppLanguage.system ? null : language.code,
  );

  Future<void> setDateFormat(DateDisplayFormat format) => _put(
    PreferenceKeys.dateFormat,
    format == DateDisplayFormat.auto ? null : format.code,
  );

  /// 整体保存单位设置；没有单独设置的项删除，跟随单位制。
  Future<void> setUnits(UnitPreferences units) => _db.transaction(() async {
    await _put(
      PreferenceKeys.unitSystem,
      units.system == UnitSystem.auto ? null : units.system.code,
    );
    await _put(PreferenceKeys.weightUnit, units.weight?.code);
    await _put(PreferenceKeys.waterUnit, units.water?.code);
    await _put(PreferenceKeys.distanceUnit, units.distance?.code);
    await _put(PreferenceKeys.temperatureUnit, units.temperature?.code);
    await _put(PreferenceKeys.foodUnit, units.food?.code);
  });

  Future<void> setCardFrequency(
    CardCategory category,
    CardFrequency frequency,
  ) => _put(
    PreferenceKeys.cards(category),
    frequency == CardFrequency.normal ? null : frequency.code,
  );

  /// 卡片上的"少看这类"：降一档，返回降档后的频率。
  Future<CardFrequency> lowerCardFrequency(CardCategory category) async {
    final lowered = (await get()).cardFrequency(category).lowered;
    await setCardFrequency(category, lowered);
    return lowered;
  }

  /// 为空时清除城市，不再出天气卡片；同时清空天气缓存。
  Future<void> setWeather(WeatherLocation? location) =>
      _db.transaction(() async {
        await _put(
          PreferenceKeys.weather,
          location == null
              ? null
              : jsonEncode({
                  'city': location.city,
                  'lat': location.latitude,
                  'lon': location.longitude,
                  'tz': location.timezone,
                }),
        );
        await _db.delete(_db.weatherDays).go();
      });

  Future<void> _put(String key, String? value) =>
      putPreference(_db, key, value, now: _clock());

  static AppPreferences _fromRows(List<SettingRow> rows) {
    final values = {for (final row in rows) row.key: row.value};
    T? code<T extends CodedEnum>(List<T> all, String key) =>
        decodeCode(all, values[key]);

    return AppPreferences(
      selectedPetId: values[PreferenceKeys.selectedPetId],
      language:
          code(AppLanguage.values, PreferenceKeys.language) ??
          AppLanguage.system,
      dateFormat:
          code(DateDisplayFormat.values, PreferenceKeys.dateFormat) ??
          DateDisplayFormat.auto,
      units: UnitPreferences(
        system:
            code(UnitSystem.values, PreferenceKeys.unitSystem) ??
            UnitSystem.auto,
        weight: code(WeightUnit.values, PreferenceKeys.weightUnit),
        water: code(VolumeUnit.values, PreferenceKeys.waterUnit),
        distance: code(DistanceUnit.values, PreferenceKeys.distanceUnit),
        temperature: code(
          TemperatureUnit.values,
          PreferenceKeys.temperatureUnit,
        ),
        food: switch (code(PortionUnit.values, PreferenceKeys.foodUnit)) {
          final unit? when PortionUnit.food.contains(unit) => unit,
          _ => null,
        },
      ),
      cardFrequencies: {
        for (final category in CardCategory.values)
          category: ?code(CardFrequency.values, PreferenceKeys.cards(category)),
      },
      weather: _decodeWeather(values[PreferenceKeys.weather]),
    );
  }

  static WeatherLocation? _decodeWeather(String? raw) {
    if (raw == null) return null;
    try {
      final json = jsonDecode(raw);
      if (json case {
        'city': final String city,
        'lat': final num lat,
        'lon': final num lon,
        'tz': final String tz,
      }) {
        return WeatherLocation(
          city: city,
          latitude: lat.toDouble(),
          longitude: lon.toDouble(),
          timezone: tz,
        );
      }
    } on FormatException {
      // 损坏的值按没填城市处理。
    }
    return null;
  }
}
