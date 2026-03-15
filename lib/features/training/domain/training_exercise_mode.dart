import '../../practice/domain/pitch_training_mode.dart';

enum TrainingExerciseMode {
  general('general', null),
  warmupReset('warmup_reset', PitchTrainingMode.speech),
  laxVox('lax_vox', PitchTrainingMode.sound),
  strawBubbles('straw_bubbles', PitchTrainingMode.sound),
  lipTrills('lip_trills', PitchTrainingMode.sound),
  resonanceHum('resonance_hum', PitchTrainingMode.sound),
  pitchGlides('pitch_glides', PitchTrainingMode.sound),
  targetSpeech('target_speech', PitchTrainingMode.speech),
  readingTransfer('reading_transfer', PitchTrainingMode.speech),
  chestResonance('chest_resonance', PitchTrainingMode.sound),
  articulationProjection('articulation_projection', PitchTrainingMode.speech);

  const TrainingExerciseMode(this.storageValue, this.recommendedTrackingMode);

  final String storageValue;
  final PitchTrainingMode? recommendedTrackingMode;

  static TrainingExerciseMode fromStorage(String value) {
    return TrainingExerciseMode.values.firstWhere(
      (mode) => mode.storageValue == value,
      orElse: () => TrainingExerciseMode.general,
    );
  }
}
