import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/format/date_display.dart';
import '../../../core/l10n/app_locale.dart';
import '../../../core/units/unit_preferences.dart';
import '../data/preferences_repository.dart';

/// 系统语言列表；测试里覆盖它来模拟不同地区。
final systemLocalesProvider = Provider<List<Locale>>(
  (ref) => WidgetsBinding.instance.platformDispatcher.locales,
);

/// 按设置和系统地区决定的显示单位。
final displayUnitsProvider = Provider<ResolvedUnits>((ref) {
  final prefs = ref.watch(appPreferencesProvider).value;
  return (prefs?.units ?? const UnitPreferences()).resolve(
    countryCode: systemRegion(ref.watch(systemLocalesProvider)),
  );
});

/// 按设置和系统地区决定的日期顺序（已经不会是 auto）。
final displayDateFormatProvider = Provider<DateDisplayFormat>((ref) {
  final prefs = ref.watch(appPreferencesProvider).value;
  final locales = ref.watch(systemLocalesProvider);
  return (prefs?.dateFormat ?? DateDisplayFormat.auto).resolve(
    countryCode: systemRegion(locales),
    languageCode: locales.firstOrNull?.languageCode,
  );
});
