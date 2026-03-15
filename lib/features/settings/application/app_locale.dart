import 'dart:ui';

import '../domain/app_settings.dart';

const _supportedLocaleCodes = {'en', 'de'};

String resolveEffectiveLocaleCode(String localeCode) {
  if (localeCode != AppSettings.systemLocaleCode &&
      _supportedLocaleCodes.contains(localeCode)) {
    return localeCode;
  }

  final systemLanguageCode =
      PlatformDispatcher.instance.locale.languageCode.toLowerCase();
  if (_supportedLocaleCodes.contains(systemLanguageCode)) {
    return systemLanguageCode;
  }

  return 'en';
}
