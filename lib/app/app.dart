import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voxa/l10n/app_localizations.dart';

import '../core/theme/voxa_theme.dart';
import '../features/settings/application/app_locale.dart';
import '../features/settings/application/app_settings_controller.dart';
import '../features/settings/domain/app_settings.dart';
import '../features/sync/application/sync_controller.dart';
import 'router/app_router.dart';

class VoxaApp extends ConsumerWidget {
  const VoxaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsControllerProvider);
    final router = ref.watch(appRouterProvider);
    ref.watch(syncControllerProvider);

    return MaterialApp.router(
      title: 'Voxa',
      debugShowCheckedModeBanner: false,
      theme: VoxaTheme.dark(),
      darkTheme: VoxaTheme.dark(),
      themeMode: settings.themeMode,
      locale: settings.localeCode == AppSettings.systemLocaleCode
          ? null
          : Locale(resolveEffectiveLocaleCode(settings.localeCode)),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router,
    );
  }
}
