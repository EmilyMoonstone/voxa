import 'dart:convert';

import 'package:flutter/material.dart';

import '../../goal_setting/domain/voice_target.dart';
import '../../practice/domain/pitch_training_mode.dart';
import '../../record/domain/practice_session.dart';
import '../../settings/domain/app_settings.dart';
import '../domain/sync_models.dart';
import '../domain/sync_snapshot_codec.dart';

class JsonSyncSnapshotCodec implements SyncSnapshotCodec {
  static const schemaVersion = 1;

  @override
  String encode(SyncSnapshot snapshot) {
    return jsonEncode({
      'schemaVersion': snapshot.schemaVersion,
      'updatedAt': snapshot.updatedAt.millisecondsSinceEpoch,
      'accountId': snapshot.accountId,
      'settings': _encodeSettings(snapshot.settings),
      'activeTarget': snapshot.activeTarget == null
          ? null
          : _encodeTarget(snapshot.activeTarget!),
      'sessions': snapshot.sessions.map(_encodeSession).toList(growable: false),
      'tombstones': snapshot.tombstones
          .map(
            (tombstone) => {
              'entityType': tombstone.entityType.name,
              'entityId': tombstone.entityId,
              'deletedAt': tombstone.deletedAt.millisecondsSinceEpoch,
            },
          )
          .toList(growable: false),
    });
  }

  @override
  SyncSnapshot decode(String content) {
    final decoded = jsonDecode(content) as Map<String, dynamic>;
    final version = decoded['schemaVersion'] as int? ?? 0;
    if (version != schemaVersion) {
      throw const FormatException('Unsupported sync snapshot version');
    }
    return SyncSnapshot(
      schemaVersion: version,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        decoded['updatedAt'] as int,
      ),
      accountId: decoded['accountId'] as String? ?? '',
      settings: _decodeSettings(decoded['settings'] as Map<String, dynamic>),
      activeTarget: decoded['activeTarget'] == null
          ? null
          : _decodeTarget(decoded['activeTarget'] as Map<String, dynamic>),
      sessions: (decoded['sessions'] as List<dynamic>)
          .map((entry) => _decodeSession(entry as Map<String, dynamic>))
          .toList(growable: false),
      tombstones: (decoded['tombstones'] as List<dynamic>)
          .map(
            (entry) => DeletedEntityTombstone(
              entityType: SyncEntityType.values.byName(
                entry['entityType'] as String,
              ),
              entityId: entry['entityId'] as String,
              deletedAt: DateTime.fromMillisecondsSinceEpoch(
                entry['deletedAt'] as int,
              ),
            ),
          )
          .toList(growable: false),
    );
  }

  Map<String, dynamic> _encodeSettings(AppSettings settings) {
    return {
      'localeCode': settings.localeCode,
      'themeMode': settings.themeMode.name,
      'smoothingWindowMs': settings.smoothingWindowMs,
      'targetToleranceHz': settings.targetToleranceHz,
      'targetVolumeToleranceDb': settings.targetVolumeToleranceDb,
      'lastPitchTrainingMode': settings.lastPitchTrainingMode.storageValue,
      'showLiveFeedbackDuringRecording':
          settings.showLiveFeedbackDuringRecording,
      'updatedAt': settings.updatedAt.millisecondsSinceEpoch,
    };
  }

  AppSettings _decodeSettings(Map<String, dynamic> json) {
    return AppSettings(
      localeCode: json['localeCode'] as String,
      themeMode: switch (json['themeMode'] as String?) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      },
      smoothingWindowMs: json['smoothingWindowMs'] as int,
      targetToleranceHz: json['targetToleranceHz'] as int,
      targetVolumeToleranceDb:
          json['targetVolumeToleranceDb'] as int? ??
          AppSettings.defaults.targetVolumeToleranceDb,
      lastPitchTrainingMode: PitchTrainingMode.fromStorage(
        json['lastPitchTrainingMode'] as String,
      ),
      showLiveFeedbackDuringRecording:
          json['showLiveFeedbackDuringRecording'] as bool,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt'] as int),
    );
  }

  Map<String, dynamic> _encodeTarget(VoiceTarget target) {
    return {
      'id': target.id,
      'targetHz': target.targetHz,
      'targetVolumeDbfs': target.targetVolumeDbfs,
      'suggestionPreset': target.suggestionPreset.storageValue,
      'createdAt': target.createdAt.millisecondsSinceEpoch,
      'updatedAt': target.updatedAt.millisecondsSinceEpoch,
    };
  }

  VoiceTarget _decodeTarget(Map<String, dynamic> json) {
    return VoiceTarget(
      id: json['id'] as String,
      targetHz: (json['targetHz'] as num).toDouble(),
      targetVolumeDbfs: (json['targetVolumeDbfs'] as num?)?.toDouble(),
      suggestionPreset: TargetPreset.fromStorage(
        json['suggestionPreset'] as String,
      ),
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt'] as int),
    );
  }

  Map<String, dynamic> _encodeSession(SyncPracticeSession session) {
    return {
      'id': session.id,
      'startedAt': session.startedAt.millisecondsSinceEpoch,
      'endedAt': session.endedAt.millisecondsSinceEpoch,
      'updatedAt': session.updatedAt.millisecondsSinceEpoch,
      'mode': session.mode.name,
      'trackingMode': session.trackingMode,
      'targetSnapshot': _encodeTarget(session.targetSnapshot),
      'targetToleranceHz': session.targetToleranceHz,
      'targetVolumeToleranceDb': session.targetVolumeToleranceDb,
      'averagePitchHz': session.averagePitchHz,
      'minPitchHz': session.minPitchHz,
      'maxPitchHz': session.maxPitchHz,
      'timeAtTargetMs': session.timeAtTargetMs,
      'totalTrackedTimeMs': session.totalTrackedTimeMs,
      'chartPoints': session.chartPoints
          .map(
            (point) => {
              'timestampMs': point.timestampMs,
              'frequencyHz': point.frequencyHz,
            },
          )
          .toList(growable: false),
      'practiceTextId': session.practiceTextId,
      'resonanceStateName': session.resonanceStateName,
      'resonanceBalancedPercent': session.resonanceBalancedPercent,
      'resonanceAverageConfidence': session.resonanceAverageConfidence,
    };
  }

  SyncPracticeSession _decodeSession(Map<String, dynamic> json) {
    return SyncPracticeSession(
      id: json['id'] as String,
      startedAt: DateTime.fromMillisecondsSinceEpoch(json['startedAt'] as int),
      endedAt: DateTime.fromMillisecondsSinceEpoch(json['endedAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt'] as int),
      mode: PracticeSessionMode.values.byName(json['mode'] as String),
      trackingMode: json['trackingMode'] as String,
      targetSnapshot: _decodeTarget(
        json['targetSnapshot'] as Map<String, dynamic>,
      ),
      targetToleranceHz: json['targetToleranceHz'] as int,
      targetVolumeToleranceDb:
          json['targetVolumeToleranceDb'] as int? ??
          AppSettings.defaults.targetVolumeToleranceDb,
      averagePitchHz: (json['averagePitchHz'] as num?)?.toDouble(),
      minPitchHz: (json['minPitchHz'] as num?)?.toDouble(),
      maxPitchHz: (json['maxPitchHz'] as num?)?.toDouble(),
      timeAtTargetMs: json['timeAtTargetMs'] as int,
      totalTrackedTimeMs: json['totalTrackedTimeMs'] as int,
      chartPoints: (json['chartPoints'] as List<dynamic>)
          .map(
            (entry) => ChartPoint(
              timestampMs: entry['timestampMs'] as int,
              frequencyHz: (entry['frequencyHz'] as num?)?.toDouble(),
            ),
          )
          .toList(growable: false),
      practiceTextId: json['practiceTextId'] as String?,
      resonanceStateName: json['resonanceStateName'] as String?,
      resonanceBalancedPercent: (json['resonanceBalancedPercent'] as num?)
          ?.toDouble(),
      resonanceAverageConfidence: (json['resonanceAverageConfidence'] as num?)
          ?.toDouble(),
    );
  }
}
