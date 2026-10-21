import 'package:flutter/widgets.dart';

import '../../features/settings/domain/app_preferences.dart';
import 'generated/app_localizations.dart';

export 'generated/app_localizations.dart';

/// 按用户设置和系统语言决定界面语言。
///
/// 跟随系统时，取系统语言列表里第一个受支持的语言；都不支持时用英文。
Locale resolveAppLocale(AppLanguage language, Iterable<Locale> systemLocales) =>
    switch (language) {
      AppLanguage.zh => const Locale('zh'),
      AppLanguage.en => const Locale('en'),
      AppLanguage.system => Locale(
        systemLocales
            .map((locale) => locale.languageCode)
            .firstWhere(_isSupported, orElse: () => 'en'),
      ),
    };

/// 系统地区代码（如 `US`、`CN`），用于决定默认单位和日期顺序。
///
/// 取系统首选语言的地区：用中文界面但身在美国的用户，仍按美国习惯显示。
String? systemRegion(Iterable<Locale> systemLocales) =>
    systemLocales.firstOrNull?.countryCode;

bool _isSupported(String languageCode) => AppLocalizations.supportedLocales.any(
  (locale) => locale.languageCode == languageCode,
);
