import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voxa/l10n/app_localizations.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/theme/voxa_tokens.dart';
import '../../../core/widgets/voxa_logo.dart';
import '../../../core/widgets/voxa_page.dart';
import '../../../core/widgets/voxa_panel.dart';
import '../../goal_setting/application/voice_target_use_cases.dart';
import '../../history/application/session_providers.dart';
import '../../settings/application/app_settings_controller.dart';
import '../../training/application/training_plan_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final settings = ref.watch(appSettingsControllerProvider);
    final target = ref.watch(currentTargetProvider).asData?.value;
    final sessions =
        ref.watch(practiceSessionsProvider).asData?.value ?? const [];
    final latestSession = sessions.isEmpty ? null : sessions.first;
    final todayPlan = ref.watch(todayTrainingDayPlanProvider);
    final reminders = todayPlan.reminderTimes
        .map(
          (entry) => MaterialLocalizations.of(context).formatTimeOfDay(
            TimeOfDay(hour: entry.hour, minute: entry.minute),
            alwaysUse24HourFormat: true,
          ),
        )
        .toList(growable: false);

    return VoxaPage(
      eyebrow: l10n.homeEyebrow.toUpperCase(),
      children: [
        _HomeHeader(
          title: l10n.homeReadyTitle,
          targetLabel: target == null
              ? l10n.homeNoTarget
              : target.formatWithTolerance(settings.targetToleranceHz),
          targetHint: target == null
              ? l10n.homeTargetHintMissing
              : l10n.homeTargetHintSaved,
          onEditTarget: () => const TargetRoute().go(context),
        ),
        VoxaPanel(
          padding: const EdgeInsets.all(VoxaSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.homeTodayPlan,
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                  Text(
                    l10n.homePlanDuration(todayPlan.durationMinutes),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: VoxaColors.aqua,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: VoxaSpacing.sm),
              Text(
                reminders.isEmpty
                    ? l10n.homeNoReminderHint
                    : l10n.homeNextReminder(_nextReminderLabel(reminders)),
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
                ),
              ),
              if (reminders.isNotEmpty) ...[
                const SizedBox(height: VoxaSpacing.md),
                Wrap(
                  spacing: VoxaSpacing.sm,
                  runSpacing: VoxaSpacing.sm,
                  children: reminders
                      .map((value) => Chip(label: Text(value)))
                      .toList(),
                ),
              ],
              const SizedBox(height: VoxaSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => const PracticeRoute().go(context),
                  child: Text(l10n.homePlannedSessionCta),
                ),
              ),
            ],
          ),
        ),
        VoxaPanel(
          padding: const EdgeInsets.all(VoxaSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.homeCustomSessionTitle,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.68),
                ),
              ),
              const SizedBox(height: VoxaSpacing.sm),
              Text(
                l10n.homeStartNow,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: VoxaSpacing.sm),
              Text(
                l10n.homeCustomSessionBody,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
                ),
              ),
              const SizedBox(height: VoxaSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => const PracticeRoute().go(context),
                  child: Text(l10n.homeCustomSessionCta),
                ),
              ),
              const SizedBox(height: VoxaSpacing.sm),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => const PracticeRecordRoute().go(context),
                  child: Text(l10n.homeRecordSample),
                ),
              ),
            ],
          ),
        ),
        VoxaPanel(
          padding: const EdgeInsets.all(VoxaSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.homeLatestResult,
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                  if (latestSession != null)
                    Text(
                      MaterialLocalizations.of(
                        context,
                      ).formatShortDate(latestSession.startedAt),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.56,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: VoxaSpacing.lg),
              if (latestSession == null)
                Text(
                  l10n.homeNoSessions,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
                  ),
                )
              else ...[
                Text(
                  l10n.homeLatestInRange(
                    latestSession.timeAtTargetPercent.round(),
                  ),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: VoxaColors.aqua,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: VoxaSpacing.xs),
                Text(
                  l10n.homeLatestAverageSummary(
                    l10n.commonHz(
                      (latestSession.averagePitchHz?.round() ?? '--')
                          .toString(),
                    ),
                    latestSession.targetLabel(),
                  ),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
                  ),
                ),
                const SizedBox(height: VoxaSpacing.md),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () =>
                        SessionDetailRoute(latestSession.id).go(context),
                    child: Text(l10n.homeViewDetails),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _nextReminderLabel(List<String> reminders) {
    return reminders.first;
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({
    required this.title,
    required this.targetLabel,
    required this.targetHint,
    required this.onEditTarget,
  });

  final String title;
  final String targetLabel;
  final String targetHint;
  final VoidCallback onEditTarget;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const VoxaLogo(
          size: 48,
          borderRadius: 14,
          variant: VoxaLogoVariant.badge,
        ),
        const SizedBox(width: VoxaSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: VoxaSpacing.sm),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: VoxaSpacing.sm,
                runSpacing: VoxaSpacing.sm,
                children: [
                  _HomeTargetBadge(label: targetLabel),
                  TextButton(
                    onPressed: onEditTarget,
                    child: Text(l10n.homeEditTarget),
                  ),
                ],
              ),
              const SizedBox(height: VoxaSpacing.xs),
              Text(
                targetHint,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HomeTargetBadge extends StatelessWidget {
  const _HomeTargetBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: VoxaSpacing.md,
        vertical: VoxaSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: VoxaColors.aqua.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: VoxaColors.aqua.withValues(alpha: 0.18)),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: VoxaColors.aqua,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
