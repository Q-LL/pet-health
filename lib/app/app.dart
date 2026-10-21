import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/design/design.dart';
import '../core/l10n/app_locale.dart';
import '../features/settings/application/display_settings.dart';
import '../features/settings/data/preferences_repository.dart';
import '../features/settings/domain/app_preferences.dart';
import 'router.dart';

class PawApp extends ConsumerWidget {
  const PawApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language =
        ref.watch(appPreferencesProvider).value?.language ?? AppLanguage.system;
    final locale = resolveAppLocale(language, ref.watch(systemLocalesProvider));
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appName,
      debugShowCheckedModeBanner: false,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      theme: buildPawTheme(locale),
      routerConfig: ref.watch(routerProvider),
    );
  }
}
