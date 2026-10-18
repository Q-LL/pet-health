import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_health/core/db/pet_health_database.dart';
import 'package:pet_health/core/format/date_display.dart';
import 'package:pet_health/core/units/unit_preferences.dart';
import 'package:pet_health/core/units/units.dart';
import 'package:pet_health/features/cards/domain/card_codes.dart';
import 'package:pet_health/features/settings/data/preferences_repository.dart';
import 'package:pet_health/features/settings/domain/app_preferences.dart';

void main() {
  late PetHealthDatabase db;
  late PreferencesRepository preferences;

  setUp(() {
    db = PetHealthDatabase(NativeDatabase.memory());
    preferences = PreferencesRepository(
      db,
      clock: () => DateTime(2026, 10, 18),
    );
  });

  tearDown(() => db.close());

  test('什么都没设置时全部为默认值', () async {
    final prefs = await preferences.get();
    expect(prefs.selectedPetId, isNull);
    expect(prefs.language, AppLanguage.system);
    expect(prefs.dateFormat, DateDisplayFormat.auto);
    expect(prefs.units, const UnitPreferences());
    expect(prefs.cardFrequency(CardCategory.tip), CardFrequency.normal);
    expect(prefs.weather, isNull);
  });

  test('语言、日期格式和单位往返；设回默认值时删除对应的键', () async {
    await preferences.setLanguage(AppLanguage.en);
    await preferences.setDateFormat(DateDisplayFormat.mdy);
    const units = UnitPreferences(
      system: UnitSystem.imperial,
      weight: WeightUnit.kg,
      food: PortionUnit.scoop,
    );
    await preferences.setUnits(units);

    final prefs = await preferences.get();
    expect(prefs.language, AppLanguage.en);
    expect(prefs.dateFormat, DateDisplayFormat.mdy);
    expect(prefs.units, units);

    await preferences.setLanguage(AppLanguage.system);
    await preferences.setDateFormat(DateDisplayFormat.auto);
    await preferences.setUnits(const UnitPreferences());
    expect(await db.select(db.appSettings).get(), isEmpty);
  });

  test('卡片频率：少看这类每次降一档，最低为关闭', () async {
    expect(
      await preferences.lowerCardFrequency(CardCategory.tip),
      CardFrequency.less,
    );
    expect(
      await preferences.lowerCardFrequency(CardCategory.tip),
      CardFrequency.off,
    );
    expect(
      await preferences.lowerCardFrequency(CardCategory.tip),
      CardFrequency.off,
    );
    final prefs = await preferences.get();
    expect(prefs.cardFrequency(CardCategory.tip), CardFrequency.off);
    expect(prefs.cardFrequency(CardCategory.moment), CardFrequency.normal);
  });

  test('天气城市往返；清除城市时清空天气缓存', () async {
    const sanJose = WeatherLocation(
      city: 'San Jose',
      latitude: 37.33939,
      longitude: -121.89496,
      timezone: 'America/Los_Angeles',
    );
    await preferences.setWeather(sanJose);
    expect((await preferences.get()).weather, sanJose);

    await db
        .into(db.weatherDays)
        .insert(
          WeatherDaysCompanion.insert(
            day: DateTime(2026, 10, 18),
            maxC: 21,
            minC: 12,
            precipProb: 0,
            uvMax: 5,
            fetchedAt: DateTime.utc(2026, 10, 18),
          ),
        );
    await preferences.setWeather(null);
    expect((await preferences.get()).weather, isNull);
    expect(await db.select(db.weatherDays).get(), isEmpty);
  });

  test('无效或损坏的值按默认值处理', () async {
    Future<void> raw(String key, String value) => db
        .into(db.appSettings)
        .insert(
          AppSettingsCompanion.insert(
            key: key,
            value: value,
            updatedAt: DateTime.utc(2026),
          ),
        );
    await raw(PreferenceKeys.language, 'klingon');
    await raw(PreferenceKeys.weightUnit, 'stone');
    // 用药单位不能当作食物单位。
    await raw(PreferenceKeys.foodUnit, 'tablet');
    await raw(PreferenceKeys.weather, '{not json');

    final prefs = await preferences.get();
    expect(prefs.language, AppLanguage.system);
    expect(prefs.units.weight, isNull);
    expect(prefs.units.food, isNull);
    expect(prefs.weather, isNull);
  });

  test('实时读取在修改后更新', () async {
    final languages = <AppLanguage>[];
    final subscription = preferences.watch().listen(
      (prefs) => languages.add(prefs.language),
    );
    await pumpEventQueue();
    await preferences.setLanguage(AppLanguage.zh);
    await pumpEventQueue();
    await subscription.cancel();
    expect(languages, [AppLanguage.system, AppLanguage.zh]);
  });
}
