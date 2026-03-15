import 'package:flutter_test/flutter_test.dart';
import 'package:voxa/features/practice/domain/volume_feedback.dart';

void main() {
  test('classifies target loudness corridor from rms dBFS', () {
    expect(
      classifyVolumeState(
        isVoiced: true,
        rmsDbfs: -26,
        targetVolumeDbfs: -18,
        toleranceDb: 6,
      ),
      VolumeState.quiet,
    );
    expect(
      classifyVolumeState(
        isVoiced: true,
        rmsDbfs: -20,
        targetVolumeDbfs: -18,
        toleranceDb: 6,
      ),
      VolumeState.atTarget,
    );
    expect(
      classifyVolumeState(
        isVoiced: true,
        rmsDbfs: -9,
        targetVolumeDbfs: -18,
        toleranceDb: 6,
      ),
      VolumeState.loud,
    );
    expect(
      classifyVolumeState(
        isVoiced: false,
        rmsDbfs: -18,
        targetVolumeDbfs: -18,
        toleranceDb: 6,
      ),
      VolumeState.unclear,
    );
  });
}

