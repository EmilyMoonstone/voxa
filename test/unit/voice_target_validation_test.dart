import 'package:flutter_test/flutter_test.dart';
import 'package:voxa/features/goal_setting/application/voice_target_validation.dart';
import 'package:voxa/features/goal_setting/domain/voice_target.dart';

void main() {
  test('maps preset suggestions to exact starter targets', () {
    expect(presetTargetSuggestions[TargetPreset.masculine], 123);
    expect(presetTargetSuggestions[TargetPreset.androgynous], 160);
    expect(presetTargetSuggestions[TargetPreset.feminine], 193);
  });

  test('validates exact target bounds', () {
    expect(
      validateVoiceTargetHz(targetHz: null),
      VoiceTargetValidationError.missingTarget,
    );
    expect(
      validateVoiceTargetHz(targetHz: 60),
      VoiceTargetValidationError.outOfBounds,
    );
    expect(
      validateVoiceTargetHz(targetHz: 360),
      VoiceTargetValidationError.outOfBounds,
    );
    expect(validateVoiceTargetHz(targetHz: 185), isNull);
  });
}
