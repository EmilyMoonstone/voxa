import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voxa/app/app_providers.dart';
import 'package:voxa/features/settings/domain/app_settings.dart';
import 'package:voxa/features/settings/presentation/settings_screen.dart';

import '../support/fakes.dart';
import '../support/test_app.dart';

void main() {
  testWidgets('persists locale and theme changes from settings', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final preferencesRepository = FakeAppPreferencesRepository(
      AppSettings.defaults,
    );

    await pumpLocalizedScope(
      tester,
      child: const SettingsLanguageScreen(),
      overrides: [
        practiceSessionRepositoryProvider.overrideWithValue(
          FakePracticeSessionRepository(),
        ),
        voiceTargetRepositoryProvider.overrideWithValue(
          FakeVoiceTargetRepository(),
        ),
        appPreferencesRepositoryProvider.overrideWithValue(
          preferencesRepository,
        ),
      ],
    );
    await tester.pump();

    await tester.tap(find.text('German'));
    await tester.pump();
    await tester.tap(find.text('Dark'));
    await tester.pump();

    await pumpLocalizedScope(
      tester,
      child: const SettingsAnalysisScreen(),
      overrides: [
        practiceSessionRepositoryProvider.overrideWithValue(
          FakePracticeSessionRepository(),
        ),
        voiceTargetRepositoryProvider.overrideWithValue(
          FakeVoiceTargetRepository(),
        ),
        appPreferencesRepositoryProvider.overrideWithValue(
          preferencesRepository,
        ),
      ],
    );
    await tester.pump();
    await tester.drag(find.byType(Slider).first, const Offset(200, 0));
    await tester.pump();

    expect(preferencesRepository.savedSettings.localeCode, 'de');
    expect(preferencesRepository.savedSettings.themeMode, ThemeMode.dark);
    expect(preferencesRepository.savedSettings.targetToleranceHz, isNot(10));
  });
}
