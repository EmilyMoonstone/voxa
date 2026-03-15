import '../../goal_setting/domain/voice_target.dart';
import '../../settings/domain/app_settings.dart';
import 'sync_models.dart';

class SyncMergeEngine {
  const SyncMergeEngine();

  SyncSnapshot merge({
    required SyncSnapshot local,
    required SyncSnapshot remote,
  }) {
    final mergedSettings = _mergeSettings(local.settings, remote.settings);
    final mergedTarget = _mergeTarget(local: local, remote: remote);
    final mergedSessions = _mergeSessions(local: local, remote: remote);
    final mergedTombstones = _mergeTombstones(
      local: local,
      remote: remote,
      activeTarget: mergedTarget,
      activeSessions: mergedSessions,
    );

    return SyncSnapshot(
      schemaVersion: local.schemaVersion,
      updatedAt: _later(local.updatedAt, remote.updatedAt),
      accountId: remote.accountId.isNotEmpty
          ? remote.accountId
          : local.accountId,
      settings: mergedSettings,
      activeTarget: mergedTarget,
      sessions: mergedSessions,
      tombstones: mergedTombstones,
    );
  }

  AppSettings _mergeSettings(AppSettings local, AppSettings remote) {
    return local.updatedAt.isAfter(remote.updatedAt) ? local : remote;
  }

  VoiceTarget? _mergeTarget({
    required SyncSnapshot local,
    required SyncSnapshot remote,
  }) {
    final localTarget = local.activeTarget;
    final remoteTarget = remote.activeTarget;
    final localDeletedAt = _latestTombstoneTime(
      local.tombstones,
      SyncEntityType.target,
      'current-target',
    );
    final remoteDeletedAt = _latestTombstoneTime(
      remote.tombstones,
      SyncEntityType.target,
      'current-target',
    );

    var winnerTarget = localTarget;
    if (winnerTarget == null ||
        (remoteTarget != null &&
            remoteTarget.updatedAt.isAfter(winnerTarget.updatedAt))) {
      winnerTarget = remoteTarget;
    }

    final deletedAt = _laterNullable(localDeletedAt, remoteDeletedAt);
    if (deletedAt == null) {
      return winnerTarget;
    }
    if (winnerTarget == null) {
      return null;
    }
    return deletedAt.isAfter(winnerTarget.updatedAt) ||
            deletedAt.isAtSameMomentAs(winnerTarget.updatedAt)
        ? null
        : winnerTarget;
  }

  List<SyncPracticeSession> _mergeSessions({
    required SyncSnapshot local,
    required SyncSnapshot remote,
  }) {
    final localById = {
      for (final session in local.sessions) session.id: session,
    };
    final remoteById = {
      for (final session in remote.sessions) session.id: session,
    };
    final merged = <SyncPracticeSession>[];
    final allIds = {...localById.keys, ...remoteById.keys};
    for (final id in allIds) {
      final localSession = localById[id];
      final remoteSession = remoteById[id];
      final localDeletedAt = _latestTombstoneTime(
        local.tombstones,
        SyncEntityType.session,
        id,
      );
      final remoteDeletedAt = _latestTombstoneTime(
        remote.tombstones,
        SyncEntityType.session,
        id,
      );
      final deletedAt = _laterNullable(localDeletedAt, remoteDeletedAt);
      final liveWinner = _newerSession(localSession, remoteSession);
      if (liveWinner == null) {
        continue;
      }
      if (deletedAt != null &&
          (deletedAt.isAfter(liveWinner.updatedAt) ||
              deletedAt.isAtSameMomentAs(liveWinner.updatedAt))) {
        continue;
      }
      merged.add(liveWinner);
    }
    merged.sort((a, b) => b.startedAt.compareTo(a.startedAt));
    return merged;
  }

  List<DeletedEntityTombstone> _mergeTombstones({
    required SyncSnapshot local,
    required SyncSnapshot remote,
    required VoiceTarget? activeTarget,
    required List<SyncPracticeSession> activeSessions,
  }) {
    final tombstonesByKey = <String, DeletedEntityTombstone>{};
    for (final tombstone in [...local.tombstones, ...remote.tombstones]) {
      final key = '${tombstone.entityType.name}:${tombstone.entityId}';
      final current = tombstonesByKey[key];
      if (current == null || tombstone.deletedAt.isAfter(current.deletedAt)) {
        tombstonesByKey[key] = tombstone;
      }
    }

    final activeSessionIds = {for (final session in activeSessions) session.id};
    tombstonesByKey.removeWhere((key, tombstone) {
      if (tombstone.entityType == SyncEntityType.target) {
        return activeTarget != null &&
            activeTarget.id == tombstone.entityId &&
            !tombstone.deletedAt.isAfter(activeTarget.updatedAt);
      }
      final sessionId = tombstone.entityId;
      SyncPracticeSession? activeSession;
      for (final session in activeSessions) {
        if (session.id == sessionId) {
          activeSession = session;
          break;
        }
      }
      return activeSessionIds.contains(sessionId) &&
          activeSession != null &&
          !tombstone.deletedAt.isAfter(activeSession.updatedAt);
    });

    return tombstonesByKey.values.toList(growable: false)
      ..sort((a, b) => a.deletedAt.compareTo(b.deletedAt));
  }

  DateTime? _latestTombstoneTime(
    List<DeletedEntityTombstone> tombstones,
    SyncEntityType entityType,
    String entityId,
  ) {
    DateTime? latest;
    for (final tombstone in tombstones) {
      if (tombstone.entityType != entityType ||
          tombstone.entityId != entityId) {
        continue;
      }
      latest = _laterNullable(latest, tombstone.deletedAt);
    }
    return latest;
  }

  SyncPracticeSession? _newerSession(
    SyncPracticeSession? local,
    SyncPracticeSession? remote,
  ) {
    if (local == null) {
      return remote;
    }
    if (remote == null) {
      return local;
    }
    return local.updatedAt.isAfter(remote.updatedAt) ? local : remote;
  }

  DateTime _later(DateTime a, DateTime b) => a.isAfter(b) ? a : b;

  DateTime? _laterNullable(DateTime? a, DateTime? b) {
    if (a == null) {
      return b;
    }
    if (b == null) {
      return a;
    }
    return _later(a, b);
  }
}
