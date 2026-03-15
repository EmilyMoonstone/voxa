import 'package:flutter/material.dart';

import '../../features/practice/domain/pitch_sample.dart';
import '../theme/voxa_tokens.dart';

class PitchGauge extends StatelessWidget {
  const PitchGauge({
    required this.frequencyHz,
    required this.stateCategory,
    required this.caption,
    super.key,
  });

  final double? frequencyHz;
  final PitchStateCategory stateCategory;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = switch (stateCategory) {
      PitchStateCategory.low => VoxaColors.pitchLow,
      PitchStateCategory.atTarget => VoxaColors.pitchInRange,
      PitchStateCategory.high => VoxaColors.pitchHigh,
      PitchStateCategory.unvoiced => theme.colorScheme.primary,
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(VoxaSpacing.xl),
        child: Column(
          children: [
            Container(
              width: 220,
              height: 220,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: SweepGradient(
                  colors: [
                    VoxaColors.pitchLow,
                    VoxaColors.pitchInRange,
                    VoxaColors.pitchHigh,
                    VoxaColors.pitchLow,
                  ],
                  stops: [0, 0.45, 0.75, 1],
                ),
              ),
              child: Center(
                child: Container(
                  width: 168,
                  height: 168,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.surface,
                    border: Border.all(
                      color: color.withValues(alpha: 0.35),
                      width: 3,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: VoxaSpacing.md,
                      vertical: VoxaSpacing.sm,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            frequencyHz == null
                                ? '--'
                                : '${frequencyHz!.round()} Hz',
                            style: theme.textTheme.displaySmall,
                          ),
                        ),
                        const SizedBox(height: VoxaSpacing.xs),
                        Text(
                          caption,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
