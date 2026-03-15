import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voxa/app/app_providers.dart';
import 'package:voxa/features/goal_setting/domain/voice_target.dart';
import 'package:voxa/features/practice/application/live_practice_controller.dart';
import 'package:voxa/features/practice/domain/pitch_sample.dart';
import 'package:voxa/features/practice/domain/pitch_training_mode.dart';
import 'package:voxa/features/practice/domain/resonance_feedback.dart';
import 'package:voxa/features/practice/presentation/practice_screen.dart';
import 'package:voxa/features/settings/domain/app_settings.dart';

import '../support/fakes.dart';
import '../support/test_app.dart';

void main() {
  testWidgets('renders resonance card for balanced feedback', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final targetRepository = FakeVoiceTargetRepository(
      VoiceTarget(
        id: 'target',
        targetHz: 160,
        suggestionPreset: TargetPreset.androgynous,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      ),
    );

    await pumpLocalizedScope(
      tester,
      initialSettings: AppSettings.defaults.copyWith(
        localeCode: 'en',
        lastPitchTrainingMode: PitchTrainingMode.sound,
      ),
      child: const PracticeScreen(),
      overrides: [
        voiceTargetRepositoryProvider.overrideWithValue(targetRepository),
        livePracticeControllerProvider.overrideWith(
          _FakeLivePracticeController.new,
        ),
      ],
    );
    await tester.pump();

    expect(find.text('Volume'), findsOneWidget);
    expect(find.text('Resonance'), findsOneWidget);
    expect(find.text('Balanced'), findsOneWidget);
    expect(
      find.text('The resonance sounds balanced. Stay with that shape.'),
      findsWidgets,
    );
  });

  testWidgets('renders signal unclear resonance state', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final targetRepository = FakeVoiceTargetRepository(
      VoiceTarget(
        id: 'target',
        targetHz: 160,
        suggestionPreset: TargetPreset.androgynous,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      ),
    );

    await pumpLocalizedScope(
      tester,
      initialSettings: AppSettings.defaults.copyWith(
        localeCode: 'en',
        lastPitchTrainingMode: PitchTrainingMode.speech,
      ),
      child: const PracticeScreen(),
      overrides: [
        voiceTargetRepositoryProvider.overrideWithValue(targetRepository),
        livePracticeControllerProvider.overrideWith(
          _FakeSilentPracticeController.new,
        ),
      ],
    );
    await tester.pump();

    expect(find.text('Signal unclear'), findsOneWidget);
  });
}

class _FakeLivePracticeController extends LivePracticeController {
  @override
  LivePracticeState build() {
    return const LivePracticeState(
      status: PracticeSessionStatus.running,
      currentSample: PitchSample(
        timestampMs: 100,
        frequencyHz: 160,
        confidence: 0.92,
        rmsDbfs: -18,
        quality: PitchQuality.strong,
        resonanceFeedback: ResonanceFeedback(
          state: ResonanceState.balanced,
          confidence: 0.86,
          brightnessRatio: 0.62,
          spectralTiltDbPerOct: -6.1,
          timestampMs: 100,
        ),
        isVoiced: true,
        stateCategory: PitchStateCategory.atTarget,
      ),
      recentSamples: [
        PitchSample(
          timestampMs: 100,
          frequencyHz: 160,
          confidence: 0.92,
          rmsDbfs: -18,
          quality: PitchQuality.strong,
          resonanceFeedback: ResonanceFeedback(
            state: ResonanceState.balanced,
            confidence: 0.86,
            brightnessRatio: 0.62,
            spectralTiltDbPerOct: -6.1,
            timestampMs: 100,
          ),
          isVoiced: true,
          stateCategory: PitchStateCategory.atTarget,
        ),
      ],
      timeAtTargetPercent: 70,
      trackedTimeMs: 1000,
      averagePitchHz: 161,
    );
  }
}

class _FakeSilentPracticeController extends LivePracticeController {
  @override
  LivePracticeState build() {
    return const LivePracticeState(
      status: PracticeSessionStatus.running,
      currentSample: PitchSample(
        timestampMs: 100,
        frequencyHz: null,
        confidence: 0,
        rmsDbfs: -120,
        quality: PitchQuality.silent,
        resonanceFeedback: ResonanceFeedback(
          state: ResonanceState.insufficientSignal,
          confidence: 0,
          brightnessRatio: 0,
          spectralTiltDbPerOct: 0,
          timestampMs: 100,
        ),
        isVoiced: false,
        stateCategory: PitchStateCategory.unvoiced,
      ),
    );
  }
}
