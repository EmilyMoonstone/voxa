import 'package:flutter_test/flutter_test.dart';
import 'package:voxa/features/goal_setting/domain/voice_target.dart';
import 'package:voxa/features/practice/application/live_pitch_signal_processor.dart';
import 'package:voxa/features/practice/domain/pitch_sample.dart';
import 'package:voxa/features/practice/domain/pitch_training_mode.dart';

void main() {
  final target = VoiceTarget(
    id: 'target',
    targetHz: 160,
    suggestionPreset: TargetPreset.androgynous,
    createdAt: DateTime(2026),
    updatedAt: DateTime(2026),
  );

  test('sound mode uses rolling median and exact target classification', () {
    final processor = LivePitchSignalProcessor(
      target: target,
      toleranceHz: 10,
      trainingMode: PitchTrainingMode.sound,
      smoothingWindowMs: 300,
    );

    processor.process(
      const DetectedPitchFrame(
        timestampMs: 60,
        rawFrequencyHz: 150,
        probability: 0.9,
        rmsDbfs: -18,
        isPitched: true,
      ),
    );
    processor.process(
      const DetectedPitchFrame(
        timestampMs: 120,
        rawFrequencyHz: 160,
        probability: 0.9,
        rmsDbfs: -18,
        isPitched: true,
      ),
    );
    processor.process(
      const DetectedPitchFrame(
        timestampMs: 180,
        rawFrequencyHz: 170,
        probability: 0.9,
        rmsDbfs: -18,
        isPitched: true,
      ),
    );
    final sample = processor.process(
      const DetectedPitchFrame(
        timestampMs: 240,
        rawFrequencyHz: 165,
        probability: 0.9,
        rmsDbfs: -18,
        isPitched: true,
      ),
    );

    expect(sample.frequencyHz, inInclusiveRange(156.0, 160.0));
    expect(sample.stateCategory, PitchStateCategory.atTarget);
  });

  test('speech mode tracks baseline instead of brief melodic spikes', () {
    final processor = LivePitchSignalProcessor(
      target: target,
      toleranceHz: 10,
      trainingMode: PitchTrainingMode.speech,
      smoothingWindowMs: 300,
    );

    PitchSample sample = processor.process(
      const DetectedPitchFrame(
        timestampMs: 300,
        rawFrequencyHz: 155,
        probability: 0.9,
        rmsDbfs: -18,
        isPitched: true,
      ),
    );
    sample = processor.process(
      const DetectedPitchFrame(
        timestampMs: 600,
        rawFrequencyHz: 168,
        probability: 0.9,
        rmsDbfs: -18,
        isPitched: true,
      ),
    );
    sample = processor.process(
      const DetectedPitchFrame(
        timestampMs: 900,
        rawFrequencyHz: 181,
        probability: 0.9,
        rmsDbfs: -18,
        isPitched: true,
      ),
    );
    sample = processor.process(
      const DetectedPitchFrame(
        timestampMs: 1200,
        rawFrequencyHz: 160,
        probability: 0.9,
        rmsDbfs: -18,
        isPitched: true,
      ),
    );

    expect(sample.frequencyHz, inInclusiveRange(157.0, 161.0));
    expect(sample.stateCategory, PitchStateCategory.atTarget);
  });

  test('keeps recent feedback briefly and turns unvoiced after timeout', () {
    final processor = LivePitchSignalProcessor(
      target: target,
      toleranceHz: 10,
      trainingMode: PitchTrainingMode.sound,
      smoothingWindowMs: 300,
    );

    final voicedSample = processor.process(
      const DetectedPitchFrame(
        timestampMs: 60,
        rawFrequencyHz: 160,
        probability: 0.9,
        rmsDbfs: -18,
        isPitched: true,
      ),
    );
    final heldSample = processor.process(
      const DetectedPitchFrame(
        timestampMs: 160,
        rawFrequencyHz: null,
        probability: 0,
        rmsDbfs: -120,
        isPitched: false,
      ),
    );
    final unvoicedSample = processor.process(
      const DetectedPitchFrame(
        timestampMs: 420,
        rawFrequencyHz: null,
        probability: 0,
        rmsDbfs: -120,
        isPitched: false,
      ),
    );

    expect(voicedSample.isVoiced, isTrue);
    expect(heldSample.isVoiced, isFalse);
    expect(heldSample.frequencyHz, voicedSample.frequencyHz);
    expect(unvoicedSample.stateCategory, PitchStateCategory.unvoiced);
    expect(unvoicedSample.frequencyHz, isNull);
  });

  test('suppresses isolated octave jumps as unstable frames', () {
    final processor = LivePitchSignalProcessor(
      target: target,
      toleranceHz: 10,
      trainingMode: PitchTrainingMode.sound,
      smoothingWindowMs: 300,
    );

    processor.process(
      const DetectedPitchFrame(
        timestampMs: 60,
        rawFrequencyHz: 160,
        probability: 0.88,
        rmsDbfs: -18,
        isPitched: true,
      ),
    );
    final unstable = processor.process(
      const DetectedPitchFrame(
        timestampMs: 120,
        rawFrequencyHz: 312,
        probability: 0.6,
        rmsDbfs: -19,
        isPitched: true,
      ),
    );

    expect(unstable.quality, PitchQuality.unstable);
    expect(unstable.frequencyHz, closeTo(160, 2));
  });
}
