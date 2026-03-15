import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voxa/app/app_providers.dart';
import 'package:voxa/features/goal_setting/domain/voice_target.dart';
import 'package:voxa/features/goal_setting/presentation/goal_setting_screen.dart';
import 'package:voxa/features/settings/domain/app_settings.dart';

import '../support/fakes.dart';
import '../support/test_app.dart';

void main() {
  testWidgets('saves an exact target from the goal setting flow', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final repository = FakeVoiceTargetRepository(
      VoiceTarget(
        id: 'current-target',
        targetHz: 160,
        suggestionPreset: TargetPreset.androgynous,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      ),
    );

    await pumpLocalizedScope(
      tester,
      initialSettings: AppSettings.defaults.copyWith(targetToleranceHz: 10),
      child: const GoalSettingScreen(),
      overrides: [voiceTargetRepositoryProvider.overrideWithValue(repository)],
    );

    await tester.tap(find.text('Custom'));
    await tester.pump();
    await tester.tap(find.text('More options'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(TextFormField));
    await tester.pump();
    await tester.enterText(find.byType(TextFormField), '185');
    final pageScrollable = find.byType(Scrollable).first;
    await tester.dragUntilVisible(
      find.text('Save target'),
      pageScrollable,
      const Offset(0, -300),
    );
    await tester.tap(find.text('Save target'));
    await tester.pumpAndSettle();

    expect(repository.currentTarget?.targetHz, 185);
    expect(find.text('Target updated'), findsOneWidget);
  });
}
