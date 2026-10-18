import 'package:flutter/foundation.dart';

import '../../../core/codes/coded_enum.dart';
import '../../../core/format/date_display.dart';
import '../../../core/units/unit_preferences.dart';
import '../../cards/domain/card_codes.dart';

/// 界面语言。
enum AppLanguage implements CodedEnum {
  /// 跟随系统。
  system('system'),
  zh('zh'),
  en('en');

  const AppLanguage(this.code);

  @override
  final String code;
}

/// 天气使用的城市，由用户输入城市名后查到，不读取 GPS。
@immutable
class WeatherLocation {
  const WeatherLocation({
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.timezone,
  });

  final String city;
  final double latitude;
  final double longitude;

  /// IANA 时区名，如 `America/Los_Angeles`。
  final String timezone;

  @override
  bool operator ==(Object other) =>
      other is WeatherLocation &&
      city == other.city &&
      latitude == other.latitude &&
      longitude == other.longitude &&
      timezone == other.timezone;

  @override
  int get hashCode => Object.hash(city, latitude, longitude, timezone);
}

/// 用户在设置里的全部选择。读到无效的值时使用默认值。
@immutable
class AppPreferences {
  const AppPreferences({
    this.selectedPetId,
    this.language = AppLanguage.system,
    this.units = const UnitPreferences(),
    this.dateFormat = DateDisplayFormat.auto,
    this.cardFrequencies = const {},
    this.weather,
  });

  final String? selectedPetId;
  final AppLanguage language;
  final UnitPreferences units;
  final DateDisplayFormat dateFormat;

  /// 没有设置的类别为 [CardFrequency.normal]，见 [cardFrequency]。
  final Map<CardCategory, CardFrequency> cardFrequencies;

  /// 为空表示没填城市，不出天气卡片。
  final WeatherLocation? weather;

  CardFrequency cardFrequency(CardCategory category) =>
      cardFrequencies[category] ?? CardFrequency.normal;
}
