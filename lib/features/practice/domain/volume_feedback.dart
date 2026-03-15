enum VolumeState { quiet, atTarget, loud, unclear }

VolumeState classifyVolumeState({
  required bool isVoiced,
  required double rmsDbfs,
  required double? targetVolumeDbfs,
  required int toleranceDb,
}) {
  if (!isVoiced || targetVolumeDbfs == null || rmsDbfs <= -70) {
    return VolumeState.unclear;
  }
  if (rmsDbfs < targetVolumeDbfs - toleranceDb) {
    return VolumeState.quiet;
  }
  if (rmsDbfs > targetVolumeDbfs + toleranceDb) {
    return VolumeState.loud;
  }
  return VolumeState.atTarget;
}
