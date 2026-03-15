import 'package:flutter/material.dart';
import 'package:voxa/l10n/app_localizations.dart';

import '../../../core/theme/voxa_tokens.dart';
import '../../../core/widgets/voxa_panel.dart';

class RecordSummaryCard extends StatelessWidget {
  const RecordSummaryCard({
    required this.averagePitchHz,
    required this.targetLabel,
    required this.timeAtTargetPercent,
    super.key,
  });

  final double? averagePitchHz;
  final String? targetLabel;
  final double timeAtTargetPercent;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return VoxaPanel(
      padding: const EdgeInsets.all(VoxaSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Summary',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: VoxaSpacing.lg),
          Text(
            '${l10n.recordAvgLabel}: ${averagePitchHz?.round() ?? '--'} Hz',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: VoxaSpacing.sm),
          Text(
            '${l10n.practiceTargetLabel}: ${targetLabel ?? '--'}',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: VoxaSpacing.sm),
          Text(
            '${l10n.recordAtTargetLabel}: ${timeAtTargetPercent.round()}%',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
