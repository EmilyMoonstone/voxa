import 'dart:math' as math;

import '../../goal_setting/domain/voice_target.dart';
import '../domain/pitch_sample.dart';
import '../domain/pitch_training_mode.dart';

class DetectedPitchFrame {
  const DetectedPitchFrame({
    required this.timestampMs,
    required this.rawFrequencyHz,
    required this.probability,
    required this.rmsDbfs,
    required this.isPitched,
  });

  final int timestampMs;
  final double? rawFrequencyHz;
  final double probability;
  final double rmsDbfs;
  final bool isPitched;
}

enum PitchTrackingProfile { live, offline }

class PitchTrackingConfig {
  const PitchTrackingConfig({
    required this.profile,
    required this.windowSize,
    required this.hopSize,
    required this.minimumVoicedFrequencyHz,
    required this.maximumVoicedFrequencyHz,
    required this.minimumRmsDbfs,
    required this.minimumConfidence,
    required this.strongRmsDbfs,
    required this.strongConfidence,
    required this.unvoicedTimeoutMs,
    required this.speechBaselineWindowMs,
    required this.displaySmoothingFactor,
    required this.maximumPitchStepHz,
    required this.jumpToleranceHz,
    required this.confirmedJumpFrames,
    required this.speechOutlierHz,
  });

  const PitchTrackingConfig.live()
    : this(
        profile: PitchTrackingProfile.live,
        windowSize: 2048,
        hopSize: 1024,
        minimumVoicedFrequencyHz: 70,
        maximumVoicedFrequencyHz: 350,
        minimumRmsDbfs: -34,
        minimumConfidence: 0.55,
        strongRmsDbfs: -22,
        strongConfidence: 0.82,
        unvoicedTimeoutMs: 320,
        speechBaselineWindowMs: 1200,
        displaySmoothingFactor: 0.36,
        maximumPitchStepHz: 14,
        jumpToleranceHz: 26,
        confirmedJumpFrames: 2,
        speechOutlierHz: 24,
      );

  const PitchTrackingConfig.offline()
    : this(
        profile: PitchTrackingProfile.offline,
        windowSize: 4096,
        hopSize: 512,
        minimumVoicedFrequencyHz: 70,
        maximumVoicedFrequencyHz: 350,
        minimumRmsDbfs: -30,
        minimumConfidence: 0.62,
        strongRmsDbfs: -20,
        strongConfidence: 0.86,
        unvoicedTimeoutMs: 280,
        speechBaselineWindowMs: 1200,
        displaySmoothingFactor: 0.42,
        maximumPitchStepHz: 11,
        jumpToleranceHz: 20,
        confirmedJumpFrames: 2,
        speechOutlierHz: 18,
      );

  final PitchTrackingProfile profile;
  final int windowSize;
  final int hopSize;
  final double minimumVoicedFrequencyHz;
  final double maximumVoicedFrequencyHz;
  final double minimumRmsDbfs;
  final double minimumConfidence;
  final double strongRmsDbfs;
  final double strongConfidence;
  final int unvoicedTimeoutMs;
  final int speechBaselineWindowMs;
  final double displaySmoothingFactor;
  final double maximumPitchStepHz;
  final double jumpToleranceHz;
  final int confirmedJumpFrames;
  final double speechOutlierHz;
}

class LivePitchSignalProcessor {
  LivePitchSignalProcessor({
    required VoiceTarget target,
    required int toleranceHz,
    required PitchTrainingMode trainingMode,
    required int smoothingWindowMs,
    this.config = const PitchTrackingConfig.live(),
  }) : _target = target,
       _toleranceHz = toleranceHz,
       _trainingMode = trainingMode {
    _smoothingSampleCount = smoothingSampleCountForWindow(smoothingWindowMs);
  }

  final PitchTrackingConfig config;

  final List<double> _recentAcceptedPitches = <double>[];
  final List<_TimestampedPitch> _recentSpeechPitches = <_TimestampedPitch>[];
  VoiceTarget _target;
  int _toleranceHz;
  PitchTrainingMode _trainingMode;
  int _lastTimestampMs = 0;
  int _lastVoicedTimestampMs = 0;
  PitchSample? _lastVoicedSample;
  double? _displayPitchHz;
  double? _pendingJumpPitchHz;
  int _pendingJumpCount = 0;
  int _smoothingSampleCount = 5;

  PitchTrainingMode get trainingMode => _trainingMode;

  void reset({
    required VoiceTarget target,
    required int toleranceHz,
    required PitchTrainingMode trainingMode,
    required int smoothingWindowMs,
  }) {
    _target = target;
    _toleranceHz = toleranceHz;
    _trainingMode = trainingMode;
    _lastTimestampMs = 0;
    _lastVoicedTimestampMs = 0;
    _lastVoicedSample = null;
    _displayPitchHz = null;
    _pendingJumpPitchHz = null;
    _pendingJumpCount = 0;
    _recentAcceptedPitches.clear();
    _recentSpeechPitches.clear();
    _smoothingSampleCount = smoothingSampleCountForWindow(smoothingWindowMs);
  }

  PitchSample process(DetectedPitchFrame frame) {
    _lastTimestampMs = frame.timestampMs;
    final acceptedPitchHz = _acceptedPitch(frame);
    if (acceptedPitchHz != null) {
      _lastVoicedTimestampMs = frame.timestampMs;
      _recentAcceptedPitches.add(acceptedPitchHz);
      if (_recentAcceptedPitches.length > _smoothingSampleCount) {
        _recentAcceptedPitches.removeAt(0);
      }

      final smoothedPitchHz = rollingMedian(_recentAcceptedPitches);
      final trackedPitchHz = _trackingPitch(_stabilizePitch(smoothedPitchHz));
      final quality = _qualityForAcceptedFrame(frame);
      final sample = PitchSample(
        timestampMs: frame.timestampMs,
        frequencyHz: trackedPitchHz,
        rawFrequencyHz: frame.rawFrequencyHz,
        confidence: frame.probability,
        rmsDbfs: frame.rmsDbfs,
        quality: quality,
        isVoiced: true,
        stateCategory: classifyAgainstTarget(
          trackedPitchHz,
          _target,
          _toleranceHz,
        ),
      );
      _lastVoicedSample = sample;
      return sample;
    }

    final suppressedJump =
        frame.isPitched &&
        frame.rawFrequencyHz != null &&
        _lastVoicedSample != null &&
        frame.rmsDbfs >= config.minimumRmsDbfs;
    if (suppressedJump) {
      final lastSample = _lastVoicedSample!;
      return PitchSample(
        timestampMs: frame.timestampMs,
        frequencyHz: lastSample.frequencyHz,
        rawFrequencyHz: frame.rawFrequencyHz,
        confidence: frame.probability,
        rmsDbfs: frame.rmsDbfs,
        quality: PitchQuality.unstable,
        isVoiced: true,
        stateCategory: lastSample.stateCategory,
      );
    }

    final recentlyVoiced =
        (frame.timestampMs - _lastVoicedTimestampMs) < config.unvoicedTimeoutMs;
    if (recentlyVoiced && _lastVoicedSample != null) {
      final lastSample = _lastVoicedSample!;
      return PitchSample(
        timestampMs: frame.timestampMs,
        frequencyHz: lastSample.frequencyHz,
        rawFrequencyHz: null,
        confidence: frame.probability,
        rmsDbfs: frame.rmsDbfs,
        quality: PitchQuality.silent,
        isVoiced: false,
        stateCategory: lastSample.stateCategory,
      );
    }

    return PitchSample(
      timestampMs: frame.timestampMs,
      frequencyHz: null,
      rawFrequencyHz: frame.rawFrequencyHz,
      confidence: frame.probability,
      rmsDbfs: frame.rmsDbfs,
      quality: frame.rmsDbfs >= config.minimumRmsDbfs
          ? PitchQuality.weak
          : PitchQuality.silent,
      isVoiced: false,
      stateCategory: PitchStateCategory.unvoiced,
    );
  }

  double? _acceptedPitch(DetectedPitchFrame frame) {
    final detectedPitchHz = frame.rawFrequencyHz;
    final inRange =
        detectedPitchHz != null &&
        detectedPitchHz >= config.minimumVoicedFrequencyHz &&
        detectedPitchHz <= config.maximumVoicedFrequencyHz;
    final meetsGate =
        frame.isPitched &&
        detectedPitchHz != null &&
        inRange &&
        frame.rmsDbfs >= config.minimumRmsDbfs &&
        frame.probability >= config.minimumConfidence;
    if (!meetsGate) {
      _pendingJumpPitchHz = null;
      _pendingJumpCount = 0;
      return null;
    }

    final lastPitchHz = _lastVoicedSample?.frequencyHz ?? _displayPitchHz;
    if (lastPitchHz == null) {
      _pendingJumpPitchHz = null;
      _pendingJumpCount = 0;
      return detectedPitchHz;
    }

    final delta = (detectedPitchHz - lastPitchHz).abs();
    if (delta <= config.jumpToleranceHz ||
        frame.probability >= config.strongConfidence) {
      _pendingJumpPitchHz = null;
      _pendingJumpCount = 0;
      return detectedPitchHz;
    }

    if (_pendingJumpPitchHz != null &&
        (_pendingJumpPitchHz! - detectedPitchHz).abs() <=
            config.jumpToleranceHz / 2) {
      _pendingJumpCount += 1;
      if (_pendingJumpCount >= config.confirmedJumpFrames) {
        _pendingJumpPitchHz = null;
        _pendingJumpCount = 0;
        return detectedPitchHz;
      }
    } else {
      _pendingJumpPitchHz = detectedPitchHz;
      _pendingJumpCount = 1;
    }
    return null;
  }

  double _trackingPitch(double smoothedPitchHz) {
    if (_trainingMode == PitchTrainingMode.sound) {
      return smoothedPitchHz;
    }

    _recentSpeechPitches.add(
      _TimestampedPitch(
        timestampMs: _lastTimestampMs,
        frequencyHz: smoothedPitchHz,
      ),
    );
    _recentSpeechPitches.removeWhere(
      (entry) =>
          (_lastTimestampMs - entry.timestampMs) >
          config.speechBaselineWindowMs,
    );
    final baselineValues = _recentSpeechPitches
        .map((entry) => entry.frequencyHz)
        .toList(growable: false);
    final median = rollingMedian(baselineValues);
    final filtered = baselineValues
        .where((value) => (value - median).abs() <= config.speechOutlierHz)
        .toList(growable: false);
    if (filtered.isEmpty) {
      return median;
    }
    return rollingMedian(filtered);
  }

  PitchQuality _qualityForAcceptedFrame(DetectedPitchFrame frame) {
    if (frame.probability >= config.strongConfidence &&
        frame.rmsDbfs >= config.strongRmsDbfs) {
      return PitchQuality.strong;
    }
    return PitchQuality.weak;
  }

  double _stabilizePitch(double nextPitchHz) {
    final current = _displayPitchHz;
    if (current == null) {
      _displayPitchHz = nextPitchHz;
      return nextPitchHz;
    }

    final delta = nextPitchHz - current;
    final boundedDelta = delta.clamp(
      -config.maximumPitchStepHz,
      config.maximumPitchStepHz,
    );
    final factor = delta.abs() > config.jumpToleranceHz
        ? math.min(0.52, config.displaySmoothingFactor + 0.12)
        : config.displaySmoothingFactor;
    final stabilized = current + (boundedDelta * factor);
    _displayPitchHz = stabilized;
    return stabilized;
  }

  static int smoothingSampleCountForWindow(int smoothingWindowMs) {
    return math.max(3, math.min(9, (smoothingWindowMs / 60).round()));
  }

  static PitchStateCategory classifyAgainstTarget(
    double frequencyHz,
    VoiceTarget target,
    int toleranceHz,
  ) {
    if (frequencyHz < target.targetHz - toleranceHz) {
      return PitchStateCategory.low;
    }
    if (frequencyHz > target.targetHz + toleranceHz) {
      return PitchStateCategory.high;
    }
    return PitchStateCategory.atTarget;
  }

  static double rollingMedian(List<double> values) {
    final sorted = values.toList()..sort();
    final middle = sorted.length ~/ 2;
    if (sorted.length.isOdd) {
      return sorted[middle];
    }
    return (sorted[middle - 1] + sorted[middle]) / 2;
  }
}

class _TimestampedPitch {
  const _TimestampedPitch({
    required this.timestampMs,
    required this.frequencyHz,
  });

  final int timestampMs;
  final double frequencyHz;
}
