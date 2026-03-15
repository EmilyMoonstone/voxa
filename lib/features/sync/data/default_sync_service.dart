import 'dart:io';

import 'package:http/http.dart' as http;

import '../../goal_setting/domain/voice_target_repository.dart';
import '../../practice/domain/pitch_training_mode.dart';
import '../../practice/domain/resonance_feedback.dart';
import '../../record/domain/practice_session.dart';
import '../../record/domain/practice_session_repository.dart';
import '../../settings/domain/app_preferences_repository.dart';
import '../../settings/domain/app_settings.dart';
import '../domain/cloud_sync_repository.dart';
import '../domain/sync_merge_engine.dart';
import '../domain/sync_metadata_repository.dart';
import '../domain/sync_models.dart';
import '../domain/sync_service.dart';
import '../domain/sync_snapshot_codec.dart';

class DefaultSyncService implements SyncService {
  DefaultSyncService({
    required AppPreferencesRepository appPreferencesRepository,
    required VoiceTargetRepository voiceTargetRepository,
    required PracticeSessionRepository practiceSessionRepository,
    required SyncMetadataRepository syncMetadataRepository,
    required CloudSyncRepository cloudSyncRepository,
    required SyncSnapshotCodec syncSnapshotCodec,
    SyncMergeEngine mergeEngine = const SyncMergeEngine(),
  }) : _appPreferencesRepository = appPreferencesRepository,
       _voiceTargetRepository = voiceTargetRepository,
       _practiceSessionRepository = practiceSessionRepository,
       _syncMetadataRepository = syncMetadataRepository,
       _cloudSyncRepository = cloudSyncRepository,
       _syncSnapshotCodec = syncSnapshotCodec,
       _mergeEngine = mergeEngine;

  final AppPreferencesRepository _appPreferencesRepository;
  final VoiceTargetRepository _voiceTargetRepository;
  final PracticeSessionRepository _practiceSessionRepository;
  final SyncMetadataRepository _syncMetadataRepository;
  final CloudSyncRepository _cloudSyncRepository;
  final SyncSnapshotCodec _syncSnapshotCodec;
  final SyncMergeEngine _mergeEngine;

  @override
  Future<SyncExecutionResult> synchronize({
    required GoogleAccountIdentity account,
    required http.Client client,
    String? remoteFileId,
  }) async {
    final localSnapshot = await _loadLocalSnapshot(account.id);
    final remoteDocument = await _cloudSyncRepository.downloadSnapshot(
      client: client,
    );
    final remoteSnapshot = remoteDocument == null
        ? SyncSnapshot(
            schemaVersion: localSnapshot.schemaVersion,
            updatedAt: DateTime.fromMillisecondsSinceEpoch(0),
            accountId: account.id,
            settings: AppSettings.defaults,
            activeTarget: null,
            sessions: const [],
            tombstones: const [],
          )
        : _syncSnapshotCodec.decode(remoteDocument.content);

    final merged = _mergeEngine.merge(
      local: localSnapshot,
      remote: remoteSnapshot,
    );
    await _applyMergedSnapshot(merged);
    final uploaded = await _cloudSyncRepository.uploadSnapshot(
      client: client,
      content: _syncSnapshotCodec.encode(
        merged.copyWith(
          updatedAt: DateTime.now().toUtc(),
          accountId: account.id,
        ),
      ),
      fileId: remoteDocument?.fileId ?? remoteFileId,
    );
    return SyncExecutionResult(
      completedAt: DateTime.now().toUtc(),
      fileId: uploaded.fileId,
      revision: uploaded.revision,
    );
  }

  Future<SyncSnapshot> _loadLocalSnapshot(String accountId) async {
    final settings = _appPreferencesRepository.load();
    final target = await _voiceTargetRepository.getCurrentTarget();
    final sessions = await _practiceSessionRepository.getSessions();
    final latestUpdatedAt =
        <DateTime>[
          settings.updatedAt,
          if (target != null) target.updatedAt,
          ...sessions.map((session) => session.updatedAt),
          ..._syncMetadataRepository.loadTombstones().map((t) => t.deletedAt),
        ].fold<DateTime>(
          DateTime.fromMillisecondsSinceEpoch(0),
          (latest, current) => latest.isAfter(current) ? latest : current,
        );

    return SyncSnapshot(
      schemaVersion: 1,
      updatedAt: latestUpdatedAt.toUtc(),
      accountId: accountId,
      settings: settings,
      activeTarget: target,
      sessions: sessions
          .map(SyncPracticeSession.fromDomain)
          .toList(growable: false),
      tombstones: _syncMetadataRepository.loadTombstones(),
    );
  }

  Future<void> _applyMergedSnapshot(SyncSnapshot snapshot) async {
    await _appPreferencesRepository.save(snapshot.settings);

    final currentTarget = await _voiceTargetRepository.getCurrentTarget();
    final targetDeleted = snapshot.tombstones.any(
      (tombstone) =>
          tombstone.entityType == SyncEntityType.target &&
          tombstone.entityId == 'current-target',
    );
    if (snapshot.activeTarget != null) {
      await _voiceTargetRepository.saveTarget(snapshot.activeTarget!);
    } else if (currentTarget != null || targetDeleted) {
      await _voiceTargetRepository.clear();
    }

    final existingSessions = await _practiceSessionRepository.getSessions();
    final existingById = {
      for (final session in existingSessions) session.id: session,
    };
    final tombstonedSessionIds = snapshot.tombstones
        .where((tombstone) => tombstone.entityType == SyncEntityType.session)
        .map((tombstone) => tombstone.entityId)
        .toSet();

    for (final sessionId in tombstonedSessionIds) {
      final existing = existingById[sessionId];
      if (existing?.audioFilePath case final path?) {
        final file = File(path);
        if (await file.exists()) {
          await file.delete();
        }
      }
      await _practiceSessionRepository.deleteSession(sessionId);
    }

    for (final syncSession in snapshot.sessions) {
      final local = existingById[syncSession.id];
      await _practiceSessionRepository.saveSession(
        PracticeSession(
          id: syncSession.id,
          startedAt: syncSession.startedAt,
          endedAt: syncSession.endedAt,
          updatedAt: syncSession.updatedAt,
          mode: syncSession.mode,
          trackingMode: PitchTrainingMode.fromStorage(syncSession.trackingMode),
          targetSnapshot: syncSession.targetSnapshot,
          targetToleranceHz: syncSession.targetToleranceHz,
          targetVolumeToleranceDb: syncSession.targetVolumeToleranceDb,
          averagePitchHz: syncSession.averagePitchHz,
          minPitchHz: syncSession.minPitchHz,
          maxPitchHz: syncSession.maxPitchHz,
          timeAtTargetMs: syncSession.timeAtTargetMs,
          totalTrackedTimeMs: syncSession.totalTrackedTimeMs,
          audioFilePath: local?.audioFilePath,
          chartPoints: syncSession.chartPoints,
          practiceTextId: syncSession.practiceTextId,
          resonanceState: syncSession.resonanceStateName == null
              ? null
              : ResonanceState.values.byName(syncSession.resonanceStateName!),
          resonanceBalancedPercent: syncSession.resonanceBalancedPercent,
          resonanceAverageConfidence: syncSession.resonanceAverageConfidence,
        ),
      );
    }

    await _syncMetadataRepository.saveTombstones(snapshot.tombstones);
  }
}

extension on SyncSnapshot {
  SyncSnapshot copyWith({DateTime? updatedAt, String? accountId}) {
    return SyncSnapshot(
      schemaVersion: schemaVersion,
      updatedAt: updatedAt ?? this.updatedAt,
      accountId: accountId ?? this.accountId,
      settings: settings,
      activeTarget: activeTarget,
      sessions: sessions,
      tombstones: tombstones,
    );
  }
}
