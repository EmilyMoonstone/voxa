import 'package:flutter_test/flutter_test.dart';
import 'package:voxa/app/app_providers.dart';
import 'package:voxa/features/goal_setting/domain/voice_target.dart';
import 'package:voxa/features/history/presentation/history_screen.dart';
import 'package:voxa/features/practice/domain/pitch_training_mode.dart';
import 'package:voxa/features/record/domain/practice_session.dart';

import '../support/fakes.dart';
import '../support/test_app.dart';

void main() {
  testWidgets('shows the calm empty state when there are no sessions', (
    tester,
  ) async {
    await pumpLocalizedScope(
      tester,
      child: const HistoryScreen(),
      overrides: [
        practiceSessionRepositoryProvider.overrideWithValue(
          FakePracticeSessionRepository(),
        ),
      ],
    );
    await tester.pump();

    expect(find.text('No sessions yet'), findsOneWidget);
    expect(find.textContaining('progress locally'), findsOneWidget);
  });

  testWidgets('shows saved sessions with exact target labels', (tester) async {
    await pumpLocalizedScope(
      tester,
      child: const HistoryScreen(),
      overrides: [
        practiceSessionRepositoryProvider.overrideWithValue(
          FakePracticeSessionRepository([
            PracticeSession(
              id: 'session',
              startedAt: DateTime(2026, 1, 2),
              endedAt: DateTime(2026, 1, 2, 0, 1),
              mode: PracticeSessionMode.recording,
              trackingMode: PitchTrainingMode.speech,
              targetSnapshot: VoiceTarget(
                id: 'target',
                targetHz: 185,
                suggestionPreset: TargetPreset.feminine,
                createdAt: DateTime(2026, 1, 1),
                updatedAt: DateTime(2026, 1, 1),
              ),
              targetToleranceHz: 10,
              targetVolumeToleranceDb: 6,
              averagePitchHz: 182,
              minPitchHz: 176,
              maxPitchHz: 192,
              timeAtTargetMs: 750,
              totalTrackedTimeMs: 1000,
              audioFilePath: null,
              chartPoints: const [],
              practiceTextId: null,
            ),
          ]),
        ),
      ],
    );
    await tester.pump();

    expect(find.text('Recorded sample'), findsOneWidget);
    expect(find.text('182 Hz'), findsOneWidget);
    expect(find.text('75%'), findsWidgets);
  });
}
