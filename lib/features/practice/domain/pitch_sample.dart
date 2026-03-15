import 'resonance_feedback.dart';

enum PitchStateCategory { low, atTarget, high, unvoiced }

enum PitchQuality { strong, weak, unstable, silent }

class PitchSample {
  const PitchSample({
    required this.timestampMs,
    required double? frequencyHz,
    this.rawFrequencyHz,
    required this.confidence,
    this.rmsDbfs = -120,
    this.quality = PitchQuality.silent,
    this.resonanceFeedback,
    required this.isVoiced,
    required this.stateCategory,
  }) : trackedFrequencyHz = frequencyHz;

  final int timestampMs;
  final double? rawFrequencyHz;
  final double? trackedFrequencyHz;
  final double confidence;
  final double rmsDbfs;
  final PitchQuality quality;
  final ResonanceFeedback? resonanceFeedback;
  final bool isVoiced;
  final PitchStateCategory stateCategory;

  double? get frequencyHz => trackedFrequencyHz;

  PitchSample copyWith({
    double? frequencyHz,
    double? rawFrequencyHz,
    double? confidence,
    double? rmsDbfs,
    PitchQuality? quality,
    ResonanceFeedback? resonanceFeedback,
    bool? isVoiced,
    PitchStateCategory? stateCategory,
  }) {
    return PitchSample(
      timestampMs: timestampMs,
      frequencyHz: frequencyHz ?? trackedFrequencyHz,
      rawFrequencyHz: rawFrequencyHz ?? this.rawFrequencyHz,
      confidence: confidence ?? this.confidence,
      rmsDbfs: rmsDbfs ?? this.rmsDbfs,
      quality: quality ?? this.quality,
      resonanceFeedback: resonanceFeedback ?? this.resonanceFeedback,
      isVoiced: isVoiced ?? this.isVoiced,
      stateCategory: stateCategory ?? this.stateCategory,
    );
  }
}
