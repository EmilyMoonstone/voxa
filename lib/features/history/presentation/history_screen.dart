import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voxa/l10n/app_localizations.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/theme/voxa_tokens.dart';
import '../../../core/widgets/voxa_page.dart';
import '../../../core/widgets/voxa_panel.dart';
import '../../record/domain/practice_session.dart';
import '../application/session_providers.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final sessionsAsync = ref.watch(practiceSessionsProvider);

    return sessionsAsync.when(
      data: (sessions) {
        if (sessions.isEmpty) {
          return VoxaPage(
            eyebrow: 'HISTORY',
            title: l10n.historyTitle,
            subtitle: l10n.historySubtitle,
            children: [
              VoxaPanel(
                padding: const EdgeInsets.all(VoxaSpacing.xl),
                child: Column(
                  children: [
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        color: VoxaColors.aqua.withValues(alpha: 0.14),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.timeline_rounded,
                        size: 38,
                        color: VoxaColors.aqua,
                      ),
                    ),
                    const SizedBox(height: VoxaSpacing.lg),
                    Text(
                      l10n.historyEmptyTitle,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: VoxaSpacing.sm),
                    Text(
                      l10n.historyEmptyBody,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ],
          );
        }

        final averageInRange =
            sessions
                .map((session) => session.timeAtTargetPercent)
                .reduce((a, b) => a + b) /
            sessions.length;
        final recentTrend = sessions.length > 1
            ? sessions.first.averagePitchHz != null &&
                      sessions[1].averagePitchHz != null
                  ? (sessions.first.averagePitchHz! -
                            sessions[1].averagePitchHz!)
                        .round()
                  : 0
            : 0;

        return VoxaPage(
          eyebrow: 'HISTORY',
          title: l10n.historyTitle,
          subtitle: 'Look for direction, not perfection.',
          children: [
            VoxaPanel(
              padding: const EdgeInsets.all(VoxaSpacing.xl),
              child: Row(
                children: [
                  Expanded(
                    child: _SummaryMetric(
                      label: 'Sessions',
                      value: '${sessions.length}',
                    ),
                  ),
                  const SizedBox(width: VoxaSpacing.md),
                  Expanded(
                    child: _SummaryMetric(
                      label: 'Avg in range',
                      value: '${averageInRange.round()}%',
                    ),
                  ),
                  const SizedBox(width: VoxaSpacing.md),
                  Expanded(
                    child: _SummaryMetric(
                      label: 'Recent trend',
                      value: '${recentTrend >= 0 ? '+' : ''}$recentTrend Hz',
                    ),
                  ),
                ],
              ),
            ),
            ...sessions.map(
              (session) => Padding(
                padding: const EdgeInsets.only(bottom: VoxaSpacing.md),
                child: _SessionCard(session: session),
              ),
            ),
          ],
        );
      },
      error: (error, stackTrace) => Center(child: Text(error.toString())),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.58),
          ),
        ),
        const SizedBox(height: VoxaSpacing.xs),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _SessionCard extends StatelessWidget {
  const _SessionCard({required this.session});

  final PracticeSession session;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = MaterialLocalizations.of(context);
    final modeLabel = session.mode == PracticeSessionMode.practice
        ? 'Practice session'
        : 'Recorded sample';

    return InkWell(
      borderRadius: BorderRadius.circular(VoxaRadius.xl),
      onTap: () => SessionDetailRoute(session.id).go(context),
      child: VoxaPanel(
        padding: const EdgeInsets.all(VoxaSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              modeLabel,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: VoxaSpacing.xs),
            Text(
              localizations.formatMediumDate(session.startedAt),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.58),
              ),
            ),
            const SizedBox(height: VoxaSpacing.md),
            Row(
              children: [
                Expanded(
                  child: _MetricLine(
                    label: 'In range',
                    value: '${session.timeAtTargetPercent.round()}%',
                  ),
                ),
                Expanded(
                  child: _MetricLine(
                    label: 'Average',
                    value: '${session.averagePitchHz?.round() ?? '--'} Hz',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricLine extends StatelessWidget {
  const _MetricLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.56),
          ),
        ),
        const SizedBox(height: VoxaSpacing.xs),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
