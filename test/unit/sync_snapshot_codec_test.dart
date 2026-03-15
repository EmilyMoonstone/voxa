import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voxa/features/goal_setting/domain/voice_target.dart';
import 'package:voxa/features/practice/domain/pitch_training_mode.dart';
import 'package:voxa/features/practice/domain/resonance_feedback.dart';
import 'package:voxa/features/record/domain/practice_session.dart';
import 'package:voxa/features/settings/domain/app_settings.dart';
import 'package:voxa/features/sync/data/json_sync_snapshot_codec.dart';
import 'package:voxa/features/sync/domain/sync_models.dart';

void main() {
  test('encodes and decodes sync snapshots round-trip', () {
    final codec = JsonSyncSnapshotCodec();
    final snapshot = SyncSnapshot(
      schemaVersion: JsonSyncSnapshotCodec.schemaVersion,
      updatedAt: DateTime.utc(2026, 3, 13, 10, 15),
      accountId: 'account-1',
      settings: AppSettings(
        localeCode: 'de',
        themeMode: ThemeMode.dark,
        smoothingWindowMs: 420,
        targetToleranceHz: 12,
        targetVolumeToleranceDb: 7,
        lastPitchTrainingMode: PitchTrainingMode.sound,
        showLiveFeedbackDuringRecording: false,
        updatedAt: DateTime.utc(2026, 3, 13, 10, 10),
      ),
      activeTarget: VoiceTarget(
        id: 'current-target',
        targetHz: 185,
        targetVolumeDbfs: -18,
        suggestionPreset: TargetPreset.feminine,
        createdAt: DateTime.utc(2026, 3, 10),
        updatedAt: DateTime.utc(2026, 3, 13, 9),
      ),
      sessions: [
        SyncPracticeSession(
          id: 'session-1',
          startedAt: DateTime.utc(2026, 3, 12, 18),
          endedAt: DateTime.utc(2026, 3, 12, 18, 5),
          updatedAt: DateTime.utc(2026, 3, 12, 18, 5),
          mode: PracticeSessionMode.recording,
          trackingMode: PitchTrainingMode.speech.storageValue,
          targetSnapshot: VoiceTarget(
            id: 'current-target',
            targetHz: 185,
            targetVolumeDbfs: -18,
            suggestionPreset: TargetPreset.feminine,
            createdAt: DateTime.utc(2026, 3, 10),
            updatedAt: DateTime.utc(2026, 3, 12, 18),
          ),
          targetToleranceHz: 10,
          targetVolumeToleranceDb: 6,
          averagePitchHz: 183,
          minPitchHz: 170,
          maxPitchHz: 195,
          timeAtTargetMs: 1200,
          totalTrackedTimeMs: 1800,
          chartPoints: const [
            ChartPoint(timestampMs: 0, frequencyHz: 180),
            ChartPoint(timestampMs: 500, frequencyHz: null),
          ],
          practiceTextId: 'warmup',
          resonanceStateName: ResonanceState.balanced.name,
          resonanceBalancedPercent: 68,
          resonanceAverageConfidence: 0.81,
        ),
      ],
      tombstones: [
        DeletedEntityTombstone(
          entityType: SyncEntityType.session,
          entityId: 'deleted-session',
          deletedAt: DateTime.utc(2026, 3, 11, 8),
        ),
      ],
    );

    final encoded = codec.encode(snapshot);
    final decoded = codec.decode(encoded);

    expect(decoded.accountId, snapshot.accountId);
    expect(decoded.settings.localeCode, 'de');
    expect(decoded.settings.themeMode, ThemeMode.dark);
    expect(decoded.settings.targetVolumeToleranceDb, 7);
    expect(decoded.activeTarget?.targetHz, 185);
    expect(decoded.activeTarget?.targetVolumeDbfs, -18);
    expect(decoded.sessions, hasLength(1));
    expect(decoded.sessions.first.chartPoints.last.frequencyHz, isNull);
    expect(decoded.tombstones.single.entityId, 'deleted-session');
  });
}
