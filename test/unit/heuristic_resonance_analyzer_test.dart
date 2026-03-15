import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:voxa/core/audio/data/heuristic_resonance_analyzer.dart';
import 'package:voxa/features/practice/domain/pitch_sample.dart';
import 'package:voxa/features/practice/domain/pitch_training_mode.dart';
import 'package:voxa/features/practice/domain/resonance_feedback.dart';

void main() {
  test('quiet frames become insufficient signal', () {
    final analyzer = HeuristicResonanceAnalyzer();
    final feedback = analyzer.analyzeLiveFrame(
      _toneMix([(500, 0.02)]),
      sampleRate: 44100,
      mode: PitchTrainingMode.sound,
      isVoiced: true,
      trackedPitchHz: 160,
      pitchConfidence: 0.9,
      rmsDbfs: -40,
      timestampMs: 20,
    );

    expect(feedback.state, ResonanceState.insufficientSignal);
  });

  test('low-heavy frames classify as dark', () {
    final analyzer = HeuristicResonanceAnalyzer();
    ResonanceFeedback feedback = const ResonanceFeedback(
      state: ResonanceState.insufficientSignal,
      confidence: 0,
      brightnessRatio: 0,
      spectralTiltDbPerOct: 0,
      timestampMs: 0,
    );
    for (var i = 0; i < 5; i++) {
      feedback = analyzer.analyzeLiveFrame(
        _toneMix([(450, 0.55), (2400, 0.06)]),
        sampleRate: 44100,
        mode: PitchTrainingMode.sound,
        isVoiced: true,
        trackedPitchHz: 160,
        pitchConfidence: 0.9,
        rmsDbfs: -18,
        timestampMs: 20 * (i + 1),
      );
    }

    expect(feedback.state, ResonanceState.dark);
  });

  test('high-heavy frames classify as bright', () {
    final analyzer = HeuristicResonanceAnalyzer();
    ResonanceFeedback feedback = const ResonanceFeedback(
      state: ResonanceState.insufficientSignal,
      confidence: 0,
      brightnessRatio: 0,
      spectralTiltDbPerOct: 0,
      timestampMs: 0,
    );
    for (var i = 0; i < 5; i++) {
      feedback = analyzer.analyzeLiveFrame(
        _toneMix([(450, 0.14), (2600, 0.48)]),
        sampleRate: 44100,
        mode: PitchTrainingMode.sound,
        isVoiced: true,
        trackedPitchHz: 180,
        pitchConfidence: 0.9,
        rmsDbfs: -18,
        timestampMs: 20 * (i + 1),
      );
    }

    expect(feedback.state, ResonanceState.bright);
  });

  test('mixed frames classify as balanced', () {
    final analyzer = HeuristicResonanceAnalyzer();
    ResonanceFeedback feedback = const ResonanceFeedback(
      state: ResonanceState.insufficientSignal,
      confidence: 0,
      brightnessRatio: 0,
      spectralTiltDbPerOct: 0,
      timestampMs: 0,
    );
    for (var i = 0; i < 5; i++) {
      feedback = analyzer.analyzeLiveFrame(
        _toneMix([(500, 0.3), (2300, 0.18)]),
        sampleRate: 44100,
        mode: PitchTrainingMode.sound,
        isVoiced: true,
        trackedPitchHz: 160,
        pitchConfidence: 0.9,
        rmsDbfs: -18,
        timestampMs: 20 * (i + 1),
      );
    }

    expect(feedback.state, ResonanceState.balanced);
  });

  test('speech smoothing resists single-frame flips', () {
    final analyzer = HeuristicResonanceAnalyzer();
    ResonanceFeedback feedback = const ResonanceFeedback(
      state: ResonanceState.insufficientSignal,
      confidence: 0,
      brightnessRatio: 0,
      spectralTiltDbPerOct: 0,
      timestampMs: 0,
    );
    for (var i = 0; i < 4; i++) {
      feedback = analyzer.analyzeLiveFrame(
        _toneMix([(500, 0.3), (2300, 0.18)]),
        sampleRate: 44100,
        mode: PitchTrainingMode.speech,
        isVoiced: true,
        trackedPitchHz: 165,
        pitchConfidence: 0.88,
        rmsDbfs: -18,
        timestampMs: 20 * (i + 1),
      );
    }
    feedback = analyzer.analyzeLiveFrame(
      _toneMix([(450, 0.14), (2600, 0.52)]),
      sampleRate: 44100,
      mode: PitchTrainingMode.speech,
      isVoiced: true,
      trackedPitchHz: 165,
      pitchConfidence: 0.88,
      rmsDbfs: -18,
      timestampMs: 120,
    );

    expect(feedback.state, ResonanceState.balanced);
  });

  test('alternating frames become unstable', () {
    final analyzer = HeuristicResonanceAnalyzer();
    ResonanceFeedback feedback = const ResonanceFeedback(
      state: ResonanceState.insufficientSignal,
      confidence: 0,
      brightnessRatio: 0,
      spectralTiltDbPerOct: 0,
      timestampMs: 0,
    );
    final frames = [
      _toneMix([(450, 0.55), (2400, 0.06)]),
      _toneMix([(450, 0.14), (2600, 0.48)]),
      _toneMix([(450, 0.55), (2400, 0.06)]),
      _toneMix([(450, 0.14), (2600, 0.48)]),
      _toneMix([(450, 0.55), (2400, 0.06)]),
    ];
    for (var i = 0; i < frames.length; i++) {
      feedback = analyzer.analyzeLiveFrame(
        frames[i],
        sampleRate: 44100,
        mode: PitchTrainingMode.sound,
        isVoiced: true,
        trackedPitchHz: 160,
        pitchConfidence: 0.9,
        rmsDbfs: -18,
        timestampMs: 20 * (i + 1),
      );
    }

    expect(feedback.state, ResonanceState.unstable);
  });

  test('tracked audio summary returns dominant state and balanced percent', () {
    final analyzer = HeuristicResonanceAnalyzer();
    final summary = analyzer.analyzeTrackedAudio(
      mode: PitchTrainingMode.sound,
      samples: const [
        PitchSample(
          timestampMs: 0,
          frequencyHz: 160,
          confidence: 0.9,
          rmsDbfs: -18,
          quality: PitchQuality.strong,
          resonanceFeedback: ResonanceFeedback(
            state: ResonanceState.balanced,
            confidence: 0.9,
            brightnessRatio: 0.6,
            spectralTiltDbPerOct: -6,
            timestampMs: 0,
          ),
          isVoiced: true,
          stateCategory: PitchStateCategory.atTarget,
        ),
        PitchSample(
          timestampMs: 60,
          frequencyHz: 162,
          confidence: 0.9,
          rmsDbfs: -18,
          quality: PitchQuality.strong,
          resonanceFeedback: ResonanceFeedback(
            state: ResonanceState.balanced,
            confidence: 0.8,
            brightnessRatio: 0.58,
            spectralTiltDbPerOct: -6.1,
            timestampMs: 60,
          ),
          isVoiced: true,
          stateCategory: PitchStateCategory.atTarget,
        ),
        PitchSample(
          timestampMs: 120,
          frequencyHz: 165,
          confidence: 0.9,
          rmsDbfs: -18,
          quality: PitchQuality.strong,
          resonanceFeedback: ResonanceFeedback(
            state: ResonanceState.bright,
            confidence: 0.7,
            brightnessRatio: 0.95,
            spectralTiltDbPerOct: -3,
            timestampMs: 120,
          ),
          isVoiced: true,
          stateCategory: PitchStateCategory.atTarget,
        ),
      ],
    );

    expect(summary.dominantState, ResonanceState.balanced);
    expect(summary.balancedTrackedPercent, closeTo(66.6, 1));
    expect(summary.averageConfidence, closeTo(0.8, 0.01));
  });
}

Uint8List _toneMix(List<(double frequencyHz, double amplitude)> tones) {
  const sampleRate = 44100;
  const durationMs = 24;
  final sampleCount = ((sampleRate * durationMs) / 1000).round();
  final data = ByteData(sampleCount * 2);
  for (var index = 0; index < sampleCount; index++) {
    var sample = 0.0;
    for (final tone in tones) {
      sample += tone.$2 *
          math.sin(2 * math.pi * tone.$1 * (index / sampleRate));
    }
    final clamped = (sample * 32767).round().clamp(-32768, 32767);
    data.setInt16(index * 2, clamped, Endian.little);
  }
  return data.buffer.asUint8List();
}
