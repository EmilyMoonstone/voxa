enum PitchTrainingMode {
  sound('sound'),
  speech('speech');

  const PitchTrainingMode(this.storageValue);

  final String storageValue;

  static PitchTrainingMode fromStorage(String value) {
    return PitchTrainingMode.values.firstWhere(
      (mode) => mode.storageValue == value,
      orElse: () => PitchTrainingMode.speech,
    );
  }
}
