import 'package:flutter/material.dart';

import '../../practice/domain/pitch_training_mode.dart';

class AppSettings {
  static const systemLocaleCode = 'system';

  AppSettings({
    required this.localeCode,
    required this.themeMode,
    required this.smoothingWindowMs,
    required this.targetToleranceHz,
    required this.targetVolumeToleranceDb,
    required this.lastPitchTrainingMode,
    required this.showLiveFeedbackDuringRecording,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);

  final String localeCode;
  final ThemeMode themeMode;
  final int smoothingWindowMs;
  final int targetToleranceHz;
  final int targetVolumeToleranceDb;
  final PitchTrainingMode lastPitchTrainingMode;
  final bool showLiveFeedbackDuringRecording;
  final DateTime updatedAt;

  static final defaults = AppSettings(
    localeCode: systemLocaleCode,
    themeMode: ThemeMode.system,
    smoothingWindowMs: 300,
    targetToleranceHz: 10,
    targetVolumeToleranceDb: 6,
    lastPitchTrainingMode: PitchTrainingMode.speech,
    showLiveFeedbackDuringRecording: true,
    updatedAt: DateTime.fromMillisecondsSinceEpoch(0),
  );

  AppSettings copyWith({
    String? localeCode,
    ThemeMode? themeMode,
    int? smoothingWindowMs,
    int? targetToleranceHz,
    int? targetVolumeToleranceDb,
    PitchTrainingMode? lastPitchTrainingMode,
    bool? showLiveFeedbackDuringRecording,
    DateTime? updatedAt,
  }) {
    return AppSettings(
      localeCode: localeCode ?? this.localeCode,
      themeMode: themeMode ?? this.themeMode,
      smoothingWindowMs: smoothingWindowMs ?? this.smoothingWindowMs,
      targetToleranceHz: targetToleranceHz ?? this.targetToleranceHz,
      targetVolumeToleranceDb:
          targetVolumeToleranceDb ?? this.targetVolumeToleranceDb,
      lastPitchTrainingMode:
          lastPitchTrainingMode ?? this.lastPitchTrainingMode,
      showLiveFeedbackDuringRecording:
          showLiveFeedbackDuringRecording ??
          this.showLiveFeedbackDuringRecording,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
