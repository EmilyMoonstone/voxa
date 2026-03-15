import '../../goal_setting/domain/voice_target.dart';
import '../../practice/domain/pitch_training_mode.dart';
import '../../practice/domain/resonance_feedback.dart';

enum PracticeSessionMode { practice, recording }

class ChartPoint {
  const ChartPoint({required this.timestampMs, required this.frequencyHz});

  final int timestampMs;
  final double? frequencyHz;
}

class PracticeSession {
  const PracticeSession({
    required this.id,
    required this.startedAt,
    required this.endedAt,
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
    required this.audioFilePath,
    required this.chartPoints,
    required this.practiceTextId,
    DateTime? updatedAt,
    this.resonanceState,
    this.resonanceBalancedPercent,
    this.resonanceAverageConfidence,
  }) : updatedAt = updatedAt ?? endedAt;

  final String id;
  final DateTime startedAt;
  final DateTime endedAt;
  final DateTime updatedAt;
  final PracticeSessionMode mode;
  final PitchTrainingMode trackingMode;
  final VoiceTarget targetSnapshot;
  final int targetToleranceHz;
  final int targetVolumeToleranceDb;
  final double? averagePitchHz;
  final double? minPitchHz;
  final double? maxPitchHz;
  final int timeAtTargetMs;
  final int totalTrackedTimeMs;
  final String? audioFilePath;
  final List<ChartPoint> chartPoints;
  final String? practiceTextId;
  final ResonanceState? resonanceState;
  final double? resonanceBalancedPercent;
  final double? resonanceAverageConfidence;

  double get timeAtTargetPercent {
    if (totalTrackedTimeMs == 0) {
      return 0;
    }
    return (timeAtTargetMs / totalTrackedTimeMs) * 100;
  }

  String targetLabel() => targetSnapshot.formatWithTolerance(targetToleranceHz);
}
