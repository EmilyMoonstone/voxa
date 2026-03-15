import 'dart:math' as math;
import 'dart:typed_data';

import '../../../features/practice/domain/pitch_sample.dart';
import '../../../features/practice/domain/pitch_training_mode.dart';
import '../../../features/practice/domain/resonance_feedback.dart';
import '../domain/audio_contracts.dart';

class HeuristicResonanceAnalyzer implements ResonanceAnalyzer {
  HeuristicResonanceAnalyzer();

  static const _minimumRmsDbfs = -32.0;
  static const _minimumConfidence = 0.55;
  static const _lowBand = (300.0, 1200.0);
  static const _highBand = (1600.0, 3400.0);
  static const _analysisBandCenters = [500.0, 1000.0, 1800.0, 3000.0];

  final List<ResonanceFeedback> _recentVoicedFrames = <ResonanceFeedback>[];

  @override
  ResonanceFeedback analyzeLiveFrame(
    Uint8List pcmBytes, {
    required int sampleRate,
    required PitchTrainingMode mode,
    required bool isVoiced,
    required double? trackedPitchHz,
    required double pitchConfidence,
    required double rmsDbfs,
    required int timestampMs,
  }) {
    if (!isVoiced ||
        trackedPitchHz == null ||
        rmsDbfs < _minimumRmsDbfs ||
        pitchConfidence < _minimumConfidence) {
      return ResonanceFeedback(
        state: ResonanceState.insufficientSignal,
        confidence: 0,
        brightnessRatio: 0,
        spectralTiltDbPerOct: 0,
        timestampMs: timestampMs,
      );
    }

    final brightnessRatio = _bandEnergyRatio(
      pcmBytes,
      sampleRate: sampleRate,
      lowBand: _lowBand,
      highBand: _highBand,
    );
    final tilt = _spectralTiltDbPerOct(pcmBytes, sampleRate: sampleRate);
    final rawState = _classify(
      brightnessRatio: brightnessRatio,
      tiltDbPerOct: tilt,
    );
    final baseConfidence = _confidenceForFrame(
      rmsDbfs: rmsDbfs,
      pitchConfidence: pitchConfidence,
      brightnessRatio: brightnessRatio,
      tiltDbPerOct: tilt,
    );

    final frame = ResonanceFeedback(
      state: rawState,
      confidence: baseConfidence,
      brightnessRatio: brightnessRatio,
      spectralTiltDbPerOct: tilt,
      timestampMs: timestampMs,
    );
    _recentVoicedFrames.add(frame);
    final maxFrames = mode == PitchTrainingMode.sound ? 5 : 9;
    if (_recentVoicedFrames.length > maxFrames) {
      _recentVoicedFrames.removeAt(0);
    }

    final stableFrames = _recentVoicedFrames
        .where(
          (feedback) => feedback.state != ResonanceState.insufficientSignal,
        )
        .toList(growable: false);
    if (stableFrames.isEmpty) {
      return frame;
    }

    final unstable = _isUnstable(stableFrames);
    final dominantState = unstable
        ? ResonanceState.unstable
        : _dominantState(stableFrames);
    final averageBrightness =
        stableFrames
            .map((feedback) => feedback.brightnessRatio)
            .reduce((a, b) => a + b) /
        stableFrames.length;
    final averageTilt =
        stableFrames
            .map((feedback) => feedback.spectralTiltDbPerOct)
            .reduce((a, b) => a + b) /
        stableFrames.length;
    final averageConfidence =
        stableFrames
            .map((feedback) => feedback.confidence)
            .reduce((a, b) => a + b) /
        stableFrames.length;

    return ResonanceFeedback(
      state: dominantState,
      confidence: unstable ? averageConfidence * 0.65 : averageConfidence,
      brightnessRatio: averageBrightness,
      spectralTiltDbPerOct: averageTilt,
      timestampMs: timestampMs,
    );
  }

  @override
  SessionResonanceAnalysis analyzeTrackedAudio({
    required Iterable<PitchSample> samples,
    required PitchTrainingMode mode,
  }) {
    final resonanceFrames = samples
        .map((sample) => sample.resonanceFeedback)
        .whereType<ResonanceFeedback>()
        .where(
          (feedback) => feedback.state != ResonanceState.insufficientSignal,
        )
        .toList(growable: false);
    if (resonanceFrames.isEmpty) {
      return const SessionResonanceAnalysis(
        dominantState: ResonanceState.insufficientSignal,
        balancedTrackedPercent: 0,
        averageConfidence: 0,
      );
    }

    final dominantState = _dominantState(resonanceFrames);
    final balancedCount = resonanceFrames
        .where((feedback) => feedback.state == ResonanceState.balanced)
        .length;
    final averageConfidence =
        resonanceFrames
            .map((feedback) => feedback.confidence)
            .reduce((a, b) => a + b) /
        resonanceFrames.length;
    final balancedPercent = (balancedCount / resonanceFrames.length) * 100;

    return SessionResonanceAnalysis(
      dominantState: dominantState,
      balancedTrackedPercent: balancedPercent,
      averageConfidence: averageConfidence,
    );
  }

  bool _isUnstable(List<ResonanceFeedback> feedbacks) {
    if (feedbacks.length < 4) {
      return false;
    }
    var transitions = 0;
    for (var index = 0; index < feedbacks.length - 1; index++) {
      if (feedbacks[index].state != feedbacks[index + 1].state) {
        transitions += 1;
      }
    }
    return transitions >= (feedbacks.length / 2).ceil();
  }

  ResonanceState _dominantState(List<ResonanceFeedback> feedbacks) {
    final counts = <ResonanceState, int>{};
    for (final feedback in feedbacks) {
      counts.update(feedback.state, (value) => value + 1, ifAbsent: () => 1);
    }
    return counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }

  ResonanceState _classify({
    required double brightnessRatio,
    required double tiltDbPerOct,
  }) {
    if (brightnessRatio < 0.48 && tiltDbPerOct < -8.0) {
      return ResonanceState.dark;
    }
    if (brightnessRatio > 0.86 && tiltDbPerOct > -4.2) {
      return ResonanceState.bright;
    }
    return ResonanceState.balanced;
  }

  double _confidenceForFrame({
    required double rmsDbfs,
    required double pitchConfidence,
    required double brightnessRatio,
    required double tiltDbPerOct,
  }) {
    final rmsScore = ((rmsDbfs + 36) / 16).clamp(0.0, 1.0);
    final ratioDistance = (brightnessRatio - 0.64).abs().clamp(0.0, 0.5);
    final tiltDistance = ((tiltDbPerOct + 6.1).abs() / 8).clamp(0.0, 1.0);
    final featureCertainty = 1 - ((ratioDistance + tiltDistance) / 2);
    return ((rmsScore + pitchConfidence + featureCertainty) / 3).clamp(
      0.0,
      1.0,
    );
  }

  double _bandEnergyRatio(
    Uint8List pcmBytes, {
    required int sampleRate,
    required (double, double) lowBand,
    required (double, double) highBand,
  }) {
    final lowEnergy = _bandEnergy(
      pcmBytes,
      sampleRate: sampleRate,
      startHz: lowBand.$1,
      endHz: lowBand.$2,
    );
    final highEnergy = _bandEnergy(
      pcmBytes,
      sampleRate: sampleRate,
      startHz: highBand.$1,
      endHz: highBand.$2,
    );
    return highEnergy / math.max(1e-6, lowEnergy);
  }

  double _spectralTiltDbPerOct(Uint8List pcmBytes, {required int sampleRate}) {
    final energies = _analysisBandCenters
        .map(
          (centerHz) => _bandEnergy(
            pcmBytes,
            sampleRate: sampleRate,
            startHz: centerHz * 0.75,
            endHz: centerHz * 1.25,
          ),
        )
        .toList(growable: false);
    final xs = _analysisBandCenters
        .map((value) => math.log(value) / math.ln2)
        .toList();
    final ys = energies
        .map((value) => 10 * (math.log(value + 1e-9) / math.ln10))
        .toList();
    final meanX = xs.reduce((a, b) => a + b) / xs.length;
    final meanY = ys.reduce((a, b) => a + b) / ys.length;
    var numerator = 0.0;
    var denominator = 0.0;
    for (var index = 0; index < xs.length; index++) {
      numerator += (xs[index] - meanX) * (ys[index] - meanY);
      denominator += math.pow(xs[index] - meanX, 2).toDouble();
    }
    return denominator == 0 ? 0 : numerator / denominator;
  }

  double _bandEnergy(
    Uint8List pcmBytes, {
    required int sampleRate,
    required double startHz,
    required double endHz,
  }) {
    final samples = _pcmToWindowedSamples(pcmBytes);
    final binStart = (startHz * samples.length / sampleRate).floor().clamp(
      1,
      samples.length ~/ 2,
    );
    final binEnd = (endHz * samples.length / sampleRate).ceil().clamp(
      binStart + 1,
      samples.length ~/ 2,
    );
    var totalEnergy = 0.0;
    for (var k = binStart; k < binEnd; k++) {
      var real = 0.0;
      var imag = 0.0;
      for (var n = 0; n < samples.length; n++) {
        final angle = (2 * math.pi * k * n) / samples.length;
        real += samples[n] * math.cos(angle);
        imag -= samples[n] * math.sin(angle);
      }
      totalEnergy += (real * real) + (imag * imag);
    }
    return totalEnergy / math.max(1, binEnd - binStart);
  }

  List<double> _pcmToWindowedSamples(Uint8List pcmBytes) {
    final data = ByteData.sublistView(pcmBytes);
    final sampleCount = pcmBytes.length ~/ 2;
    final samples = List<double>.filled(sampleCount, 0);
    for (var index = 0; index < sampleCount; index++) {
      final raw = data.getInt16(index * 2, Endian.little) / 32768.0;
      final window =
          0.54 -
          (0.46 *
              math.cos((2 * math.pi * index) / math.max(1, sampleCount - 1)));
      samples[index] = raw * window;
    }
    return samples;
  }
}
