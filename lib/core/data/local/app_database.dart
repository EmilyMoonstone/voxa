import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../../features/goal_setting/domain/voice_target.dart';
import '../../../features/practice/domain/pitch_training_mode.dart';
import '../../../features/practice/domain/resonance_feedback.dart';
import '../../../features/record/domain/practice_session.dart';

part 'app_database.g.dart';

class VoiceTargetEntries extends Table {
  TextColumn get id => text()();
  RealColumn get targetHz => real()();
  RealColumn get targetVolumeDbfs => real().nullable()();
  TextColumn get suggestionPreset => text()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  IntColumn get deletedAt => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class PracticeSessionEntries extends Table {
  TextColumn get id => text()();
  IntColumn get startedAt => integer()();
  IntColumn get endedAt => integer()();
  IntColumn get updatedAt => integer()();
  TextColumn get mode => text()();
  TextColumn get trackingMode => text()();
  RealColumn get targetHz => real()();
  RealColumn get targetVolumeDbfs => real().nullable()();
  IntColumn get targetToleranceHz => integer()();
  IntColumn get targetVolumeToleranceDb => integer()();
  TextColumn get targetSuggestionPreset => text()();
  RealColumn get averagePitchHz => real().nullable()();
  RealColumn get minPitchHz => real().nullable()();
  RealColumn get maxPitchHz => real().nullable()();
  IntColumn get timeAtTargetMs => integer()();
  IntColumn get totalTrackedTimeMs => integer()();
  TextColumn get audioFilePath => text().nullable()();
  TextColumn get chartPointsJson => text()();
  TextColumn get practiceTextId => text().nullable()();
  TextColumn get resonanceState => text().nullable()();
  RealColumn get resonanceBalancedPercent => real().nullable()();
  RealColumn get resonanceAverageConfidence => real().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(tables: [VoiceTargetEntries, PracticeSessionEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'voxa_app'));

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      await migrator.deleteTable('voice_target_entries');
      await migrator.deleteTable('practice_session_entries');
      await migrator.createAll();
    },
  );
}

extension VoiceTargetEntryMapping on VoiceTargetEntry {
  VoiceTarget toDomain() {
    return VoiceTarget(
      id: id,
      targetHz: targetHz,
      targetVolumeDbfs: targetVolumeDbfs,
      suggestionPreset: TargetPreset.fromStorage(suggestionPreset),
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(updatedAt),
      deletedAt: deletedAt == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(deletedAt!),
    );
  }
}

extension VoiceTargetCompanionMapping on VoiceTarget {
  VoiceTargetEntriesCompanion toCompanion() {
    return VoiceTargetEntriesCompanion.insert(
      id: id,
      targetHz: targetHz,
      targetVolumeDbfs: Value(targetVolumeDbfs),
      suggestionPreset: suggestionPreset.storageValue,
      createdAt: createdAt.millisecondsSinceEpoch,
      updatedAt: updatedAt.millisecondsSinceEpoch,
      deletedAt: Value(deletedAt?.millisecondsSinceEpoch),
    );
  }
}

extension PracticeSessionEntryMapping on PracticeSessionEntry {
  PracticeSession toDomain() {
    final chart = (jsonDecode(chartPointsJson) as List<dynamic>)
        .map(
          (entry) => ChartPoint(
            timestampMs: entry['timestampMs'] as int,
            frequencyHz: entry['frequencyHz'] == null
                ? null
                : (entry['frequencyHz'] as num).toDouble(),
          ),
        )
        .toList(growable: false);

    return PracticeSession(
      id: id,
      startedAt: DateTime.fromMillisecondsSinceEpoch(startedAt),
      endedAt: DateTime.fromMillisecondsSinceEpoch(endedAt),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(updatedAt),
      mode: mode == PracticeSessionMode.practice.name
          ? PracticeSessionMode.practice
          : PracticeSessionMode.recording,
      trackingMode: PitchTrainingMode.fromStorage(trackingMode),
      targetSnapshot: VoiceTarget(
        id: 'snapshot-$id',
        targetHz: targetHz,
        targetVolumeDbfs: targetVolumeDbfs,
        suggestionPreset: TargetPreset.fromStorage(targetSuggestionPreset),
        createdAt: DateTime.fromMillisecondsSinceEpoch(startedAt),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(endedAt),
      ),
      targetToleranceHz: targetToleranceHz,
      targetVolumeToleranceDb: targetVolumeToleranceDb,
      averagePitchHz: averagePitchHz,
      minPitchHz: minPitchHz,
      maxPitchHz: maxPitchHz,
      timeAtTargetMs: timeAtTargetMs,
      totalTrackedTimeMs: totalTrackedTimeMs,
      audioFilePath: audioFilePath,
      chartPoints: chart,
      practiceTextId: practiceTextId,
      resonanceState: resonanceState == null
          ? null
          : ResonanceState.values.byName(resonanceState!),
      resonanceBalancedPercent: resonanceBalancedPercent,
      resonanceAverageConfidence: resonanceAverageConfidence,
    );
  }
}

extension PracticeSessionCompanionMapping on PracticeSession {
  PracticeSessionEntriesCompanion toCompanion() {
    return PracticeSessionEntriesCompanion.insert(
      id: id,
      startedAt: startedAt.millisecondsSinceEpoch,
      endedAt: endedAt.millisecondsSinceEpoch,
      updatedAt: updatedAt.millisecondsSinceEpoch,
      mode: mode.name,
      trackingMode: trackingMode.storageValue,
      targetHz: targetSnapshot.targetHz,
      targetVolumeDbfs: Value(targetSnapshot.targetVolumeDbfs),
      targetToleranceHz: targetToleranceHz,
      targetVolumeToleranceDb: targetVolumeToleranceDb,
      targetSuggestionPreset: targetSnapshot.suggestionPreset.storageValue,
      averagePitchHz: Value(averagePitchHz),
      minPitchHz: Value(minPitchHz),
      maxPitchHz: Value(maxPitchHz),
      timeAtTargetMs: timeAtTargetMs,
      totalTrackedTimeMs: totalTrackedTimeMs,
      audioFilePath: Value(audioFilePath),
      chartPointsJson: jsonEncode(
        chartPoints
            .map(
              (point) => {
                'timestampMs': point.timestampMs,
                'frequencyHz': point.frequencyHz,
              },
            )
            .toList(growable: false),
      ),
      practiceTextId: Value(practiceTextId),
      resonanceState: Value(resonanceState?.name),
      resonanceBalancedPercent: Value(resonanceBalancedPercent),
      resonanceAverageConfidence: Value(resonanceAverageConfidence),
    );
  }
}
