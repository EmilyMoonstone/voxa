import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:voxa/features/goal_setting/domain/voice_target.dart';
import 'package:voxa/features/practice/domain/pitch_training_mode.dart';
import 'package:voxa/features/record/domain/practice_session.dart';
import 'package:voxa/features/settings/application/reset_local_data_use_case.dart';

import '../support/fakes.dart';

void main() {
  test('clears repositories and deletes saved recording files', () async {
    final tempDirectory = await Directory.systemTemp.createTemp('voxa_test');
    final audioFile = File('${tempDirectory.path}/session.wav');
    await audioFile.writeAsString('fake');

    final sessionRepository = FakePracticeSessionRepository([
      PracticeSession(
        id: 'session',
        startedAt: DateTime(2026),
        endedAt: DateTime(2026),
        mode: PracticeSessionMode.recording,
        trackingMode: PitchTrainingMode.speech,
        targetSnapshot: VoiceTarget(
          id: 'target',
          targetHz: 160,
          suggestionPreset: TargetPreset.androgynous,
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
        ),
        targetToleranceHz: 10,
        targetVolumeToleranceDb: 6,
        averagePitchHz: 160,
        minPitchHz: 150,
        maxPitchHz: 170,
        timeAtTargetMs: 500,
        totalTrackedTimeMs: 600,
        audioFilePath: audioFile.path,
        chartPoints: const [],
        practiceTextId: null,
      ),
    ]);
    final targetRepository = FakeVoiceTargetRepository(
      VoiceTarget(
        id: 'target',
        targetHz: 160,
        suggestionPreset: TargetPreset.androgynous,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      ),
    );
    final preferencesRepository = FakeAppPreferencesRepository();

    final useCase = ResetLocalDataUseCase(
      practiceSessionRepository: sessionRepository,
      voiceTargetRepository: targetRepository,
      appPreferencesRepository: preferencesRepository,
      syncMetadataRepository: FakeSyncMetadataRepository(),
      scheduleSync: () {},
    );

    await useCase.execute();

    expect(await audioFile.exists(), isFalse);
    expect(await sessionRepository.getSessions(), isEmpty);
    expect(await targetRepository.getCurrentTarget(), isNull);
    expect(preferencesRepository.savedSettings.targetToleranceHz, 10);
  });
}
