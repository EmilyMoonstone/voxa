import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voxa/core/data/local/app_database.dart';
import 'package:voxa/features/goal_setting/data/drift_voice_target_repository.dart';
import 'package:voxa/features/goal_setting/domain/voice_target.dart';
import 'package:voxa/features/practice/domain/pitch_training_mode.dart';
import 'package:voxa/features/practice/domain/resonance_feedback.dart';
import 'package:voxa/features/record/data/drift_practice_session_repository.dart';
import 'package:voxa/features/record/domain/practice_session.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('persists and reloads exact voice targets through drift', () async {
    final repository = DriftVoiceTargetRepository(database);
    final target = VoiceTarget(
      id: 'current-target',
      targetHz: 193,
      suggestionPreset: TargetPreset.feminine,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 2),
    );

    await repository.saveTarget(target);
    final loaded = await repository.getCurrentTarget();

    expect(loaded?.id, target.id);
    expect(loaded?.suggestionPreset, TargetPreset.feminine);
    expect(loaded?.formatWithTolerance(10), '193 Hz ± 10 Hz');
  });

  test('persists practice sessions with target snapshots and chart data', () async {
    final repository = DriftPracticeSessionRepository(database);
    final session = PracticeSession(
      id: 'session-1',
      startedAt: DateTime(2026, 1, 1, 12),
      endedAt: DateTime(2026, 1, 1, 12, 1),
      mode: PracticeSessionMode.recording,
      trackingMode: PitchTrainingMode.speech,
      targetSnapshot: VoiceTarget(
        id: 'snapshot',
        targetHz: 160,
        suggestionPreset: TargetPreset.androgynous,
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 1),
      ),
      targetToleranceHz: 10,
      targetVolumeToleranceDb: 6,
      averagePitchHz: 162.5,
      minPitchHz: 150,
      maxPitchHz: 180,
      timeAtTargetMs: 800,
      totalTrackedTimeMs: 1000,
      audioFilePath: '/tmp/sample.wav',
      chartPoints: const [
        ChartPoint(timestampMs: 0, frequencyHz: 150),
        ChartPoint(timestampMs: 50, frequencyHz: null),
        ChartPoint(timestampMs: 100, frequencyHz: 160),
      ],
      practiceTextId: 'warmup_en',
      resonanceState: ResonanceState.balanced,
      resonanceBalancedPercent: 62,
      resonanceAverageConfidence: 0.81,
    );

    await repository.saveSession(session);
    final loaded = await repository.getSessionById(session.id);

    expect(loaded?.audioFilePath, session.audioFilePath);
    expect(loaded?.chartPoints.length, 3);
    expect(loaded?.chartPoints[1].frequencyHz, isNull);
    expect(loaded?.targetSnapshot.suggestionPreset, TargetPreset.androgynous);
    expect(loaded?.trackingMode, PitchTrainingMode.speech);
    expect(loaded?.timeAtTargetPercent, 80);
    expect(loaded?.resonanceState, ResonanceState.balanced);
    expect(loaded?.resonanceBalancedPercent, 62);
  });
}
