enum ResonanceState { insufficientSignal, dark, balanced, bright, unstable }

class ResonanceFeedback {
  const ResonanceFeedback({
    required this.state,
    required this.confidence,
    required this.brightnessRatio,
    required this.spectralTiltDbPerOct,
    required this.timestampMs,
  });

  final ResonanceState state;
  final double confidence;
  final double brightnessRatio;
  final double spectralTiltDbPerOct;
  final int timestampMs;
}

class SessionResonanceAnalysis {
  const SessionResonanceAnalysis({
    required this.dominantState,
    required this.balancedTrackedPercent,
    required this.averageConfidence,
  });

  final ResonanceState dominantState;
  final double balancedTrackedPercent;
  final double averageConfidence;
}
