import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voxa/features/goal_setting/domain/voice_target.dart';
import 'package:voxa/features/practice/domain/pitch_training_mode.dart';
import 'package:voxa/features/record/domain/practice_session.dart';
import 'package:voxa/features/settings/domain/app_settings.dart';
import 'package:voxa/features/sync/domain/sync_merge_engine.dart';
import 'package:voxa/features/sync/domain/sync_models.dart';

void main() {
  test('keeps newer remote session over older local session', () {
    final engine = SyncMergeEngine();
    final merged = engine.merge(
      local: _snapshot(
        sessions: [
          _session('session-1', updatedAt: DateTime.utc(2026, 3, 10, 10)),
        ],
      ),
      remote: _snapshot(
        sessions: [
          _session('session-1', updatedAt: DateTime.utc(2026, 3, 12, 10)),
        ],
      ),
    );

    expect(merged.sessions, hasLength(1));
    expect(
      merged.sessions.single.updatedAt,
      DateTime.utc(2026, 3, 12, 10),
    );
  });

  test('keeps local target when newer than remote', () {
    final engine = SyncMergeEngine();
    final merged = engine.merge(
      local: _snapshot(
        activeTarget: VoiceTarget(
          id: 'current-target',
          targetHz: 185,
          suggestionPreset: TargetPreset.feminine,
          createdAt: DateTime.utc(2026, 3, 10),
          updatedAt: DateTime.utc(2026, 3, 13, 9),
        ),
      ),
      remote: _snapshot(
        activeTarget: VoiceTarget(
          id: 'current-target',
          targetHz: 160,
          suggestionPreset: TargetPreset.androgynous,
          createdAt: DateTime.utc(2026, 3, 10),
          updatedAt: DateTime.utc(2026, 3, 12, 9),
        ),
      ),
    );

    expect(merged.activeTarget?.targetHz, 185);
  });

  test('target tombstone beats older live target', () {
    final engine = SyncMergeEngine();
    final merged = engine.merge(
      local: _snapshot(
        activeTarget: VoiceTarget(
          id: 'current-target',
          targetHz: 185,
          suggestionPreset: TargetPreset.feminine,
          createdAt: DateTime.utc(2026, 3, 10),
          updatedAt: DateTime.utc(2026, 3, 12, 9),
        ),
      ),
      remote: _snapshot(
        tombstones: [
          DeletedEntityTombstone(
            entityType: SyncEntityType.target,
            entityId: 'current-target',
            deletedAt: DateTime.utc(2026, 3, 13, 9),
          ),
        ],
      ),
    );

    expect(merged.activeTarget, isNull);
    expect(
      merged.tombstones.singleWhere(
        (entry) => entry.entityType == SyncEntityType.target,
      ).entityId,
      'current-target',
    );
  });

  test('session tombstone beats older live session', () {
    final engine = SyncMergeEngine();
    final merged = engine.merge(
      local: _snapshot(
        sessions: [
          _session('session-1', updatedAt: DateTime.utc(2026, 3, 12, 9)),
        ],
      ),
      remote: _snapshot(
        tombstones: [
          DeletedEntityTombstone(
            entityType: SyncEntityType.session,
            entityId: 'session-1',
            deletedAt: DateTime.utc(2026, 3, 13, 9),
          ),
        ],
      ),
    );

    expect(merged.sessions, isEmpty);
    expect(
      merged.tombstones.singleWhere(
        (entry) => entry.entityType == SyncEntityType.session,
      ).entityId,
      'session-1',
    );
  });
}

SyncSnapshot _snapshot({
  VoiceTarget? activeTarget,
  List<SyncPracticeSession> sessions = const [],
  List<DeletedEntityTombstone> tombstones = const [],
}) {
  return SyncSnapshot(
    schemaVersion: 1,
    updatedAt: DateTime.utc(2026, 3, 13),
    accountId: 'account-1',
    settings: AppSettings(
      localeCode: 'en',
      themeMode: ThemeMode.dark,
      smoothingWindowMs: 300,
      targetToleranceHz: 10,
      targetVolumeToleranceDb: 6,
      lastPitchTrainingMode: PitchTrainingMode.speech,
      showLiveFeedbackDuringRecording: true,
      updatedAt: DateTime.utc(2026, 3, 13),
    ),
    activeTarget: activeTarget,
    sessions: sessions,
    tombstones: tombstones,
  );
}

SyncPracticeSession _session(String id, {required DateTime updatedAt}) {
  return SyncPracticeSession(
    id: id,
    startedAt: DateTime.utc(2026, 3, 12, 18),
    endedAt: DateTime.utc(2026, 3, 12, 18, 5),
    updatedAt: updatedAt,
    mode: PracticeSessionMode.recording,
    trackingMode: PitchTrainingMode.speech.storageValue,
    targetSnapshot: VoiceTarget(
      id: 'current-target',
      targetHz: 160,
      suggestionPreset: TargetPreset.androgynous,
      createdAt: DateTime.utc(2026, 3, 10),
      updatedAt: DateTime.utc(2026, 3, 12, 18),
    ),
    targetToleranceHz: 10,
    targetVolumeToleranceDb: 6,
    averagePitchHz: 160,
    minPitchHz: 150,
    maxPitchHz: 170,
    timeAtTargetMs: 1200,
    totalTrackedTimeMs: 1600,
    chartPoints: const [],
    practiceTextId: null,
    resonanceStateName: null,
    resonanceBalancedPercent: null,
    resonanceAverageConfidence: null,
  );
}
