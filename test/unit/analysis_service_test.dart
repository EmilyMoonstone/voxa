import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:voxa/core/audio/data/record_audio_services.dart';
import 'package:voxa/features/goal_setting/domain/voice_target.dart';
import 'package:voxa/features/practice/domain/pitch_sample.dart';
import 'package:voxa/features/practice/domain/pitch_training_mode.dart';

void main() {
  const service = DefaultAnalysisService();
  final target = VoiceTarget(
    id: 'target',
    targetHz: 160,
    suggestionPreset: TargetPreset.androgynous,
    createdAt: DateTime(2026),
    updatedAt: DateTime(2026),
  );

  test('classifies pitch relative to exact target and tolerance', () {
    expect(
      service.classify(
        frequencyHz: 147,
        isVoiced: true,
        target: target,
        toleranceHz: 10,
      ),
      PitchStateCategory.low,
    );
    expect(
      service.classify(
        frequencyHz: 168,
        isVoiced: true,
        target: target,
        toleranceHz: 10,
      ),
      PitchStateCategory.atTarget,
    );
    expect(
      service.classify(
        frequencyHz: 172,
        isVoiced: true,
        target: target,
        toleranceHz: 10,
      ),
      PitchStateCategory.high,
    );
    expect(
      service.classify(
        frequencyHz: 160,
        isVoiced: false,
        target: target,
        toleranceHz: 10,
      ),
      PitchStateCategory.unvoiced,
    );
  });

  test('aggregates sound mode using tracked voiced samples', () {
    final analysis = service.analyzeTrackedSamples(
      samples: const [
        PitchSample(
          timestampMs: 0,
          frequencyHz: 155,
          confidence: 0.9,
          rmsDbfs: -18,
          quality: PitchQuality.strong,
          isVoiced: true,
          stateCategory: PitchStateCategory.atTarget,
        ),
        PitchSample(
          timestampMs: 100,
          frequencyHz: 174,
          confidence: 0.9,
          rmsDbfs: -18,
          quality: PitchQuality.strong,
          isVoiced: true,
          stateCategory: PitchStateCategory.high,
        ),
        PitchSample(
          timestampMs: 200,
          frequencyHz: null,
          confidence: 0,
          rmsDbfs: -120,
          quality: PitchQuality.silent,
          isVoiced: false,
          stateCategory: PitchStateCategory.unvoiced,
        ),
        PitchSample(
          timestampMs: 300,
          frequencyHz: 162,
          confidence: 0.9,
          rmsDbfs: -18,
          quality: PitchQuality.strong,
          isVoiced: true,
          stateCategory: PitchStateCategory.atTarget,
        ),
        PitchSample(
          timestampMs: 400,
          frequencyHz: 159,
          confidence: 0.9,
          rmsDbfs: -18,
          quality: PitchQuality.strong,
          isVoiced: true,
          stateCategory: PitchStateCategory.atTarget,
        ),
      ],
      target: target,
      toleranceHz: 10,
      trainingMode: PitchTrainingMode.sound,
    );

    expect(analysis.averagePitchHz, closeTo(162.5, 0.01));
    expect(analysis.minPitchHz, 155);
    expect(analysis.maxPitchHz, 174);
    expect(analysis.totalTrackedTimeMs, 300);
    expect(analysis.timeAtTargetMs, 200);
    expect(analysis.chartPoints, isNotEmpty);
    expect(
      analysis.chartPoints.any((point) => point.frequencyHz == null),
      isTrue,
    );
  });

  test('aggregates speech mode against rolling baseline windows', () {
    final analysis = service.analyzeTrackedSamples(
      samples: const [
        PitchSample(
          timestampMs: 0,
          frequencyHz: 156,
          confidence: 0.9,
          rmsDbfs: -18,
          quality: PitchQuality.strong,
          isVoiced: true,
          stateCategory: PitchStateCategory.atTarget,
        ),
        PitchSample(
          timestampMs: 300,
          frequencyHz: 166,
          confidence: 0.9,
          rmsDbfs: -18,
          quality: PitchQuality.strong,
          isVoiced: true,
          stateCategory: PitchStateCategory.atTarget,
        ),
        PitchSample(
          timestampMs: 600,
          frequencyHz: 176,
          confidence: 0.9,
          rmsDbfs: -18,
          quality: PitchQuality.strong,
          isVoiced: true,
          stateCategory: PitchStateCategory.high,
        ),
        PitchSample(
          timestampMs: 900,
          frequencyHz: 164,
          confidence: 0.9,
          rmsDbfs: -18,
          quality: PitchQuality.strong,
          isVoiced: true,
          stateCategory: PitchStateCategory.atTarget,
        ),
        PitchSample(
          timestampMs: 1200,
          frequencyHz: 158,
          confidence: 0.9,
          rmsDbfs: -18,
          quality: PitchQuality.strong,
          isVoiced: true,
          stateCategory: PitchStateCategory.atTarget,
        ),
        PitchSample(
          timestampMs: 1500,
          frequencyHz: 170,
          confidence: 0.9,
          rmsDbfs: -18,
          quality: PitchQuality.strong,
          isVoiced: true,
          stateCategory: PitchStateCategory.atTarget,
        ),
      ],
      target: target,
      toleranceHz: 10,
      trainingMode: PitchTrainingMode.speech,
    );

    expect(analysis.averagePitchHz, closeTo(165, 0.1));
    expect(analysis.totalTrackedTimeMs, greaterThan(0));
    expect(analysis.timeAtTargetMs, analysis.totalTrackedTimeMs);
  });

  test('offline analysis is stable for synthetic target tones', () async {
    final pcmBytes = _sinePcmBytes(
      frequencyHz: 160,
      sampleRate: 44100,
      durationMs: 1400,
      amplitude: 0.4,
    );

    final analysis = await service.analyzeRecordedAudio(
      pcmBytes: pcmBytes,
      sampleRate: 44100,
      channelCount: 1,
      target: target,
      toleranceHz: 10,
      trainingMode: PitchTrainingMode.sound,
      smoothingWindowMs: 300,
    );

    expect(analysis.averagePitchHz, isNotNull);
    expect(analysis.averagePitchHz!, closeTo(160, 4));
    expect(analysis.timeAtTargetMs, greaterThan(0));
    expect(
      analysis.chartPoints.where((point) => point.frequencyHz != null),
      isNotEmpty,
    );
  });
}

Uint8List _sinePcmBytes({
  required double frequencyHz,
  required int sampleRate,
  required int durationMs,
  required double amplitude,
}) {
  final sampleCount = ((sampleRate * durationMs) / 1000).round();
  final bytes = ByteData(sampleCount * 2);
  for (var index = 0; index < sampleCount; index++) {
    final sample = math.sin(
      2 * math.pi * frequencyHz * (index / sampleRate),
    );
    final value = (sample * amplitude * 32767).round().clamp(-32768, 32767);
    bytes.setInt16(index * 2, value, Endian.little);
  }
  return bytes.buffer.asUint8List();
}
