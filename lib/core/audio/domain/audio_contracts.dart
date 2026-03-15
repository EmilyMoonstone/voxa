import 'dart:typed_data';

import '../../../features/goal_setting/domain/voice_target.dart';
import '../../../features/practice/domain/pitch_training_mode.dart';
import '../../../features/practice/domain/pitch_sample.dart';
import '../../../features/practice/domain/resonance_feedback.dart';
import '../../../features/record/domain/practice_session.dart';

enum AudioPermissionStatus { granted, denied, permanentlyDenied }

abstract interface class AudioPermissionService {
  Future<AudioPermissionStatus> checkStatus();
  Future<AudioPermissionStatus> requestPermission();
  Future<void> openAppSettings();
}

abstract interface class LivePitchEngine {
  Future<Stream<PitchSample>> start({
    required VoiceTarget target,
    required int toleranceHz,
    required PitchTrainingMode trainingMode,
    required int smoothingWindowMs,
  });

  Future<void> pause();
  Future<void> resume();
  Future<void> stop();
}

class RecordingChunk {
  const RecordingChunk({required this.sample, required this.bytes});

  final PitchSample sample;
  final List<int> bytes;
}

class RecordedAudioCapture {
  const RecordedAudioCapture({
    required this.filePath,
    required this.pcmBytes,
    required this.sampleRate,
    required this.channelCount,
  });

  final String filePath;
  final Uint8List pcmBytes;
  final int sampleRate;
  final int channelCount;
}

class ImportedPitchSuggestion {
  const ImportedPitchSuggestion({
    required this.targetHz,
    required this.voicedSampleCount,
  });

  final double targetHz;
  final int voicedSampleCount;
}

abstract interface class RecordingEngine {
  Future<Stream<RecordingChunk>> start({
    required VoiceTarget target,
    required int toleranceHz,
    required PitchTrainingMode trainingMode,
    required int smoothingWindowMs,
  });

  Future<void> pause();
  Future<void> resume();
  Future<RecordedAudioCapture?> stop({required String outputPath});
}

abstract interface class ImportedPitchAnalysisService {
  Future<ImportedPitchSuggestion> analyzeAudioFile({
    required String filePath,
    required PitchTrainingMode trainingMode,
    required int smoothingWindowMs,
  });
}

abstract interface class TargetVolumeCalibrationService {
  Future<double> captureTargetVolumeDbfs({
    required PitchTrainingMode trainingMode,
    required int smoothingWindowMs,
  });
}

class SessionAnalysis {
  const SessionAnalysis({
    required this.averagePitchHz,
    required this.minPitchHz,
    required this.maxPitchHz,
    required this.timeAtTargetMs,
    required this.totalTrackedTimeMs,
    required this.chartPoints,
    this.resonanceAnalysis,
  });

  final double? averagePitchHz;
  final double? minPitchHz;
  final double? maxPitchHz;
  final int timeAtTargetMs;
  final int totalTrackedTimeMs;
  final List<ChartPoint> chartPoints;
  final SessionResonanceAnalysis? resonanceAnalysis;
}

abstract interface class ResonanceAnalyzer {
  ResonanceFeedback analyzeLiveFrame(
    Uint8List pcmBytes, {
    required int sampleRate,
    required PitchTrainingMode mode,
    required bool isVoiced,
    required double? trackedPitchHz,
    required double pitchConfidence,
    required double rmsDbfs,
    required int timestampMs,
  });

  SessionResonanceAnalysis analyzeTrackedAudio({
    required Iterable<PitchSample> samples,
    required PitchTrainingMode mode,
  });
}

abstract interface class AnalysisService {
  PitchStateCategory classify({
    required double? frequencyHz,
    required bool isVoiced,
    required VoiceTarget target,
    required int toleranceHz,
  });

  SessionAnalysis analyzeTrackedSamples({
    required Iterable<PitchSample> samples,
    required VoiceTarget target,
    required int toleranceHz,
    required PitchTrainingMode trainingMode,
  });

  Future<SessionAnalysis> analyzeRecordedAudio({
    required Uint8List pcmBytes,
    required int sampleRate,
    required int channelCount,
    required VoiceTarget target,
    required int toleranceHz,
    required PitchTrainingMode trainingMode,
    required int smoothingWindowMs,
  });
}
