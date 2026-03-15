enum VoiceTargetValidationError { missingTarget, outOfBounds }

VoiceTargetValidationError? validateVoiceTargetHz({required double? targetHz}) {
  if (targetHz == null) {
    return VoiceTargetValidationError.missingTarget;
  }
  if (targetHz < 70 || targetHz > 350) {
    return VoiceTargetValidationError.outOfBounds;
  }
  return null;
}
