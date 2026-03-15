import 'package:flutter/foundation.dart';

import '../../goal_setting/domain/voice_target.dart';
import '../../record/domain/practice_session.dart';
import '../../settings/domain/app_settings.dart';

enum SyncEntityType { target, session }

@immutable
class DeletedEntityTombstone {
  const DeletedEntityTombstone({
    required this.entityType,
    required this.entityId,
    required this.deletedAt,
  });

  final SyncEntityType entityType;
  final String entityId;
  final DateTime deletedAt;
}

@immutable
class SyncPracticeSession {
  const SyncPracticeSession({
    required this.id,
    required this.startedAt,
    required this.endedAt,
    required this.updatedAt,
    required this.mode,
    required this.trackingMode,
    required this.targetSnapshot,
    required this.targetToleranceHz,
    required this.targetVolumeToleranceDb,
    required this.averagePitchHz,
    required this.minPitchHz,
    required this.maxPitchHz,
    required this.timeAtTargetMs,
    required this.totalTrackedTimeMs,
    required this.chartPoints,
    required this.practiceTextId,
    required this.resonanceStateName,
    required this.resonanceBalancedPercent,
    required this.resonanceAverageConfidence,
  });

  final String id;
  final DateTime startedAt;
  final DateTime endedAt;
  final DateTime updatedAt;
  final PracticeSessionMode mode;
  final String trackingMode;
  final VoiceTarget targetSnapshot;
  final int targetToleranceHz;
  final int targetVolumeToleranceDb;
  final double? averagePitchHz;
  final double? minPitchHz;
  final double? maxPitchHz;
  final int timeAtTargetMs;
  final int totalTrackedTimeMs;
  final List<ChartPoint> chartPoints;
  final String? practiceTextId;
  final String? resonanceStateName;
  final double? resonanceBalancedPercent;
  final double? resonanceAverageConfidence;

  factory SyncPracticeSession.fromDomain(PracticeSession session) {
    return SyncPracticeSession(
      id: session.id,
      startedAt: session.startedAt.toUtc(),
      endedAt: session.endedAt.toUtc(),
      updatedAt: session.updatedAt.toUtc(),
      mode: session.mode,
      trackingMode: session.trackingMode.storageValue,
      targetSnapshot: session.targetSnapshot,
      targetToleranceHz: session.targetToleranceHz,
      targetVolumeToleranceDb: session.targetVolumeToleranceDb,
      averagePitchHz: session.averagePitchHz,
      minPitchHz: session.minPitchHz,
      maxPitchHz: session.maxPitchHz,
      timeAtTargetMs: session.timeAtTargetMs,
      totalTrackedTimeMs: session.totalTrackedTimeMs,
      chartPoints: session.chartPoints,
      practiceTextId: session.practiceTextId,
      resonanceStateName: session.resonanceState?.name,
      resonanceBalancedPercent: session.resonanceBalancedPercent,
      resonanceAverageConfidence: session.resonanceAverageConfidence,
    );
  }
}

@immutable
class SyncSnapshot {
  const SyncSnapshot({
    required this.schemaVersion,
    required this.updatedAt,
    required this.accountId,
    required this.settings,
    required this.activeTarget,
    required this.sessions,
    required this.tombstones,
  });

  final int schemaVersion;
  final DateTime updatedAt;
  final String accountId;
  final AppSettings settings;
  final VoiceTarget? activeTarget;
  final List<SyncPracticeSession> sessions;
  final List<DeletedEntityTombstone> tombstones;
}

@immutable
class SyncStatus {
  const SyncStatus({
    required this.isAvailable,
    required this.isConnected,
    required this.isSyncing,
    this.accountEmail,
    this.accountId,
    this.lastSyncedAt,
    this.lastError,
    this.remoteFileId,
    this.remoteRevision,
  });

  final bool isAvailable;
  final bool isConnected;
  final bool isSyncing;
  final String? accountEmail;
  final String? accountId;
  final DateTime? lastSyncedAt;
  final String? lastError;
  final String? remoteFileId;
  final String? remoteRevision;

  static const disconnected = SyncStatus(
    isAvailable: true,
    isConnected: false,
    isSyncing: false,
  );

  SyncStatus copyWith({
    bool? isAvailable,
    bool? isConnected,
    bool? isSyncing,
    String? accountEmail,
    String? accountId,
    DateTime? lastSyncedAt,
    String? lastError,
    String? remoteFileId,
    String? remoteRevision,
    bool clearAccountEmail = false,
    bool clearAccountId = false,
    bool clearLastError = false,
    bool clearRemoteFileId = false,
    bool clearRemoteRevision = false,
  }) {
    return SyncStatus(
      isAvailable: isAvailable ?? this.isAvailable,
      isConnected: isConnected ?? this.isConnected,
      isSyncing: isSyncing ?? this.isSyncing,
      accountEmail: clearAccountEmail
          ? null
          : (accountEmail ?? this.accountEmail),
      accountId: clearAccountId ? null : (accountId ?? this.accountId),
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      lastError: clearLastError ? null : (lastError ?? this.lastError),
      remoteFileId: clearRemoteFileId
          ? null
          : (remoteFileId ?? this.remoteFileId),
      remoteRevision: clearRemoteRevision
          ? null
          : (remoteRevision ?? this.remoteRevision),
    );
  }
}

@immutable
class GoogleAccountIdentity {
  const GoogleAccountIdentity({
    required this.id,
    required this.email,
    this.displayName,
  });

  final String id;
  final String email;
  final String? displayName;
}

@immutable
class CloudSyncDocument {
  const CloudSyncDocument({
    required this.fileId,
    required this.content,
    this.revision,
  });

  final String fileId;
  final String content;
  final String? revision;
}

@immutable
class UploadedSyncDocument {
  const UploadedSyncDocument({required this.fileId, this.revision});

  final String fileId;
  final String? revision;
}

@immutable
class SyncExecutionResult {
  const SyncExecutionResult({
    required this.completedAt,
    required this.fileId,
    required this.revision,
  });

  final DateTime completedAt;
  final String fileId;
  final String? revision;
}
