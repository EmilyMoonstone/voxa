import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voxa/l10n/app_localizations.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/theme/voxa_tokens.dart';
import '../../../core/widgets/voxa_page.dart';
import '../../../core/widgets/voxa_panel.dart';
import '../application/app_locale.dart';
import '../../sync/application/sync_controller.dart';
import '../../training/application/training_plan_controller.dart';
import '../../training/domain/training_exercise_mode.dart';
import '../../training/domain/training_plan.dart';
import '../domain/app_settings.dart';
import '../application/app_settings_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(appSettingsControllerProvider);
    final syncStatus = ref.watch(syncControllerProvider);
    final trainingPlan = ref.watch(trainingPlanControllerProvider);

    return VoxaPage(
      eyebrow: l10n.settingsEyebrow,
      title: l10n.settingsTitle,
      subtitle: l10n.settingsOverviewSubtitle,
      children: [
        _SettingsLinkPanel(
          icon: Icons.language_rounded,
          title: '${l10n.settingsLanguage} & ${l10n.settingsAppearance}',
          body:
              '${_localeLabel(l10n, settings.localeCode)} · ${_themeLabel(l10n, settings.themeMode)}',
          onTap: () => const SettingsLanguageRoute().go(context),
        ),
        _SettingsLinkPanel(
          icon: Icons.tune_rounded,
          title: l10n.settingsAnalysis,
          body:
              '${l10n.commonToleranceHz(settings.targetToleranceHz.toString())} · ${l10n.commonToleranceDb(settings.targetVolumeToleranceDb.toString())}',
          onTap: () => const SettingsAnalysisRoute().go(context),
        ),
        _SettingsLinkPanel(
          icon: Icons.calendar_today_rounded,
          title: l10n.settingsTrainingPlanTitle,
          body:
              '${l10n.commonMinutesShort(trainingPlan.resolveFor(DateTime.now()).durationMinutes)} · ${trainingPlan.scheduleMode == TrainingScheduleMode.sameEveryDay ? l10n.settingsTrainingPlanSameDaily : l10n.settingsTrainingPlanByWeekday}',
          onTap: () => const SettingsTrainingPlanRoute().go(context),
        ),
        _SettingsLinkPanel(
          icon: Icons.sync_rounded,
          title: l10n.settingsSyncTitle,
          body: syncStatus.isConnected
              ? (syncStatus.accountEmail ?? l10n.settingsSyncConnected)
              : (syncStatus.isAvailable
                    ? l10n.settingsSyncNotConnected
                    : l10n.settingsSyncUnavailableDevice),
          onTap: () => const SettingsSyncRoute().go(context),
        ),
        _SettingsLinkPanel(
          icon: Icons.shield_outlined,
          title: l10n.settingsPrivacy,
          body: l10n.settingsPrivacyBody,
          onTap: () => const SettingsPrivacyRoute().go(context),
        ),
        _SettingsLinkPanel(
          icon: Icons.delete_outline_rounded,
          title: l10n.settingsResetTitle,
          body: l10n.settingsResetBody,
          onTap: () => const SettingsDataRoute().go(context),
        ),
      ],
    );
  }
}

class SettingsLanguageScreen extends ConsumerWidget {
  const SettingsLanguageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(appSettingsControllerProvider);
    final controller = ref.read(appSettingsControllerProvider.notifier);

    return _SettingsDetailPage(
      title: '${l10n.settingsLanguage} & ${l10n.settingsAppearance}',
      subtitle: l10n.settingsLanguageSubtitle,
      children: [
        VoxaPanel(
          padding: const EdgeInsets.all(VoxaSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionTitle(title: l10n.settingsLanguage),
              const SizedBox(height: VoxaSpacing.md),
              Wrap(
                spacing: VoxaSpacing.sm,
                runSpacing: VoxaSpacing.sm,
                children: [
                  ChoiceChip(
                    label: Text(l10n.settingsLocaleSystem),
                    selected:
                        settings.localeCode == AppSettings.systemLocaleCode,
                    onSelected: (_) =>
                        controller.setLocale(AppSettings.systemLocaleCode),
                  ),
                  ChoiceChip(
                    label: Text(l10n.settingsLocaleEnglish),
                    selected: settings.localeCode == 'en',
                    onSelected: (_) => controller.setLocale('en'),
                  ),
                  ChoiceChip(
                    label: Text(l10n.settingsLocaleGerman),
                    selected: settings.localeCode == 'de',
                    onSelected: (_) => controller.setLocale('de'),
                  ),
                ],
              ),
              const SizedBox(height: VoxaSpacing.sm),
              Text(
                l10n.settingsLanguageDeviceHint(
                  _localeLabel(
                    l10n,
                    resolveEffectiveLocaleCode(settings.localeCode),
                  ),
                ),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.70),
                ),
              ),
              const SizedBox(height: VoxaSpacing.xl),
              _SectionTitle(title: l10n.settingsAppearance),
              const SizedBox(height: VoxaSpacing.md),
              Wrap(
                spacing: VoxaSpacing.sm,
                runSpacing: VoxaSpacing.sm,
                children: [
                  ChoiceChip(
                    label: Text(l10n.settingsThemeSystem),
                    selected: settings.themeMode == ThemeMode.system,
                    onSelected: (_) =>
                        controller.setThemeMode(ThemeMode.system),
                  ),
                  ChoiceChip(
                    label: Text(l10n.settingsThemeLight),
                    selected: settings.themeMode == ThemeMode.light,
                    onSelected: (_) => controller.setThemeMode(ThemeMode.light),
                  ),
                  ChoiceChip(
                    label: Text(l10n.settingsThemeDark),
                    selected: settings.themeMode == ThemeMode.dark,
                    onSelected: (_) => controller.setThemeMode(ThemeMode.dark),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SettingsAnalysisScreen extends ConsumerWidget {
  const SettingsAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final settings = ref.watch(appSettingsControllerProvider);
    final controller = ref.read(appSettingsControllerProvider.notifier);

    return _SettingsDetailPage(
      title: l10n.settingsAnalysis,
      subtitle: l10n.settingsAnalysisSubtitle,
      children: [
        VoxaPanel(
          padding: const EdgeInsets.all(VoxaSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<int>(
                initialValue: settings.smoothingWindowMs,
                decoration: InputDecoration(labelText: l10n.settingsSmoothing),
                items: [
                  DropdownMenuItem(
                    value: 180,
                    child: Text(l10n.commonMillisecondsShort(180)),
                  ),
                  DropdownMenuItem(
                    value: 300,
                    child: Text(l10n.commonMillisecondsShort(300)),
                  ),
                  DropdownMenuItem(
                    value: 420,
                    child: Text(l10n.commonMillisecondsShort(420)),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    controller.setSmoothingWindow(value);
                  }
                },
              ),
              const SizedBox(height: VoxaSpacing.lg),
              Text(
                '${l10n.settingsTolerance}: ${l10n.commonToleranceHz(settings.targetToleranceHz.toString())}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Slider(
                value: settings.targetToleranceHz.toDouble(),
                min: 5,
                max: 20,
                divisions: 15,
                label: l10n.commonToleranceHz(
                  settings.targetToleranceHz.toString(),
                ),
                onChanged: (value) =>
                    controller.setTargetTolerance(value.round()),
              ),
              Text(
                l10n.settingsToleranceHelp,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.70),
                ),
              ),
              const SizedBox(height: VoxaSpacing.lg),
              Text(
                '${l10n.settingsVolumeTolerance}: ${l10n.commonToleranceDb(settings.targetVolumeToleranceDb.toString())}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Slider(
                value: settings.targetVolumeToleranceDb.toDouble(),
                min: 3,
                max: 12,
                divisions: 9,
                label: l10n.commonToleranceDb(
                  settings.targetVolumeToleranceDb.toString(),
                ),
                onChanged: (value) =>
                    controller.setTargetVolumeTolerance(value.round()),
              ),
              Text(
                l10n.settingsVolumeToleranceHelp,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.70),
                ),
              ),
              const SizedBox(height: VoxaSpacing.lg),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.settingsLiveFeedback),
                value: settings.showLiveFeedbackDuringRecording,
                onChanged: controller.setLiveFeedbackDuringRecording,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SettingsTrainingPlanScreen extends ConsumerWidget {
  const SettingsTrainingPlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final trainingPlan = ref.watch(trainingPlanControllerProvider);
    final trainingController = ref.read(
      trainingPlanControllerProvider.notifier,
    );

    return _SettingsDetailPage(
      title: l10n.settingsTrainingPlanTitle,
      subtitle: l10n.settingsTrainingPlanSubtitle,
      children: [
        VoxaPanel(
          padding: const EdgeInsets.all(VoxaSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SegmentedButton<TrainingScheduleMode>(
                segments: [
                  ButtonSegment(
                    value: TrainingScheduleMode.sameEveryDay,
                    label: Text(l10n.settingsTrainingPlanSameDaily),
                  ),
                  ButtonSegment(
                    value: TrainingScheduleMode.byWeekday,
                    label: Text(l10n.settingsTrainingPlanByWeekday),
                  ),
                ],
                selected: {trainingPlan.scheduleMode},
                onSelectionChanged: (selection) =>
                    trainingController.setScheduleMode(selection.first),
              ),
              const SizedBox(height: VoxaSpacing.lg),
              if (trainingPlan.scheduleMode ==
                  TrainingScheduleMode.sameEveryDay)
                _TrainingDayEditor(
                  title: l10n.settingsTrainingPlanEveryDay,
                  dayPlan: trainingPlan.everydayPlan,
                  onDurationChanged: trainingController.setEverydayDuration,
                  onExerciseModeChanged:
                      trainingController.setEverydayExerciseMode,
                  onAddReminder: trainingController.addEverydayReminder,
                  onRemoveReminder: trainingController.removeEverydayReminder,
                )
              else
                Column(
                  children: [
                    for (final weekday in TrainingWeekday.values) ...[
                      _TrainingDayEditor(
                        title: _weekdayLabel(l10n, weekday),
                        dayPlan:
                            trainingPlan.weekdayPlans[weekday] ??
                            TrainingDayPlan.defaults,
                        onDurationChanged: (duration) => trainingController
                            .setWeekdayDuration(weekday, duration),
                        onExerciseModeChanged: (mode) => trainingController
                            .setWeekdayExerciseMode(weekday, mode),
                        onAddReminder: (time) => trainingController
                            .addWeekdayReminder(weekday, time),
                        onRemoveReminder: (time) => trainingController
                            .removeWeekdayReminder(weekday, time),
                      ),
                      if (weekday != TrainingWeekday.sunday)
                        const SizedBox(height: VoxaSpacing.md),
                    ],
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class SettingsSyncScreen extends ConsumerWidget {
  const SettingsSyncScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final syncStatus = ref.watch(syncControllerProvider);
    final syncController = ref.read(syncControllerProvider.notifier);

    return _SettingsDetailPage(
      title: l10n.settingsSyncTitle,
      subtitle: l10n.settingsSyncSubtitle,
      children: [
        VoxaPanel(
          padding: const EdgeInsets.all(VoxaSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                syncStatus.isAvailable
                    ? l10n.settingsSyncBody
                    : l10n.settingsSyncUnavailable,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
                ),
              ),
              const SizedBox(height: VoxaSpacing.xs),
              Text(
                l10n.settingsSyncAudioNote,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.62),
                ),
              ),
              if (syncStatus.accountEmail != null) ...[
                const SizedBox(height: VoxaSpacing.md),
                Text(
                  '${l10n.settingsSyncConnectedAs}: ${syncStatus.accountEmail}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: VoxaColors.aqua,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
              if (syncStatus.lastSyncedAt != null) ...[
                const SizedBox(height: VoxaSpacing.xs),
                Text(
                  '${l10n.settingsSyncLastSynced}: ${_formatTimestamp(syncStatus.lastSyncedAt!)}',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
              if (syncStatus.lastError != null &&
                  syncStatus.lastError!.isNotEmpty) ...[
                const SizedBox(height: VoxaSpacing.sm),
                Text(
                  syncStatus.lastError!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: VoxaColors.coral,
                  ),
                ),
              ],
              const SizedBox(height: VoxaSpacing.lg),
              Wrap(
                spacing: VoxaSpacing.sm,
                runSpacing: VoxaSpacing.sm,
                children: [
                  if (!syncStatus.isConnected)
                    FilledButton(
                      onPressed: syncStatus.isAvailable
                          ? syncController.connectGoogleAccount
                          : null,
                      child: Text(l10n.settingsSyncConnect),
                    )
                  else ...[
                    FilledButton(
                      onPressed: syncStatus.isSyncing
                          ? null
                          : syncController.syncNow,
                      child: Text(
                        syncStatus.isSyncing
                            ? l10n.commonLoading
                            : l10n.settingsSyncNow,
                      ),
                    ),
                    OutlinedButton(
                      onPressed: syncStatus.isSyncing
                          ? null
                          : syncController.disconnectGoogleAccount,
                      child: Text(l10n.settingsSyncDisconnect),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SettingsPrivacyScreen extends StatelessWidget {
  const SettingsPrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return _SettingsDetailPage(
      title: l10n.settingsPrivacy,
      subtitle: l10n.settingsPrivacySubtitle,
      children: [
        VoxaPanel(
          padding: const EdgeInsets.all(VoxaSpacing.xl),
          child: Text(
            l10n.settingsPrivacyBody,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}

class SettingsDataScreen extends ConsumerWidget {
  const SettingsDataScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final controller = ref.read(appSettingsControllerProvider.notifier);

    return _SettingsDetailPage(
      title: l10n.settingsResetTitle,
      subtitle: l10n.settingsDataSubtitle,
      children: [
        VoxaPanel(
          padding: const EdgeInsets.all(VoxaSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.settingsResetBody,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
                ),
              ),
              const SizedBox(height: VoxaSpacing.lg),
              FilledButton.tonal(
                onPressed: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(l10n.settingsResetConfirmTitle),
                        content: Text(l10n.settingsResetConfirmBody),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text(l10n.historyDeleteCancel),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text(l10n.settingsResetConfirmAction),
                          ),
                        ],
                      );
                    },
                  );
                  if (confirmed != true) {
                    return;
                  }
                  await controller.resetAllLocalData();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.settingsResetDone)),
                    );
                    const OnboardingWelcomeRoute().go(context);
                  }
                },
                child: Text(l10n.settingsResetAction),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsDetailPage extends StatelessWidget {
  const _SettingsDetailPage({
    required this.title,
    required this.subtitle,
    required this.children,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return VoxaPage(
      eyebrow: AppLocalizations.of(context)!.settingsEyebrow,
      title: title,
      subtitle: subtitle,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () => const SettingsRoute().go(context),
            icon: const Icon(Icons.arrow_back_rounded),
            label: Text(AppLocalizations.of(context)!.commonBack),
          ),
        ),
        ...children,
      ],
    );
  }
}

class _SettingsLinkPanel extends StatelessWidget {
  const _SettingsLinkPanel({
    required this.icon,
    required this.title,
    required this.body,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String body;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(VoxaRadius.xl),
      onTap: onTap,
      child: VoxaPanel(
        padding: const EdgeInsets.all(VoxaSpacing.lg),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: VoxaColors.aqua.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: VoxaColors.aqua),
            ),
            const SizedBox(width: VoxaSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleLarge),
                  const SizedBox(height: VoxaSpacing.xs),
                  Text(
                    body,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(
                        alpha: 0.72,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: VoxaSpacing.sm),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}

String _themeLabel(AppLocalizations l10n, ThemeMode themeMode) {
  return switch (themeMode) {
    ThemeMode.system => l10n.settingsThemeSystem,
    ThemeMode.light => l10n.settingsThemeLight,
    ThemeMode.dark => l10n.settingsThemeDark,
  };
}

String _localeLabel(AppLocalizations l10n, String localeCode) {
  return switch (localeCode) {
    AppSettings.systemLocaleCode => l10n.settingsLocaleSystem,
    'de' => l10n.settingsLocaleGerman,
    _ => l10n.settingsLocaleEnglish,
  };
}

String _weekdayLabel(AppLocalizations l10n, TrainingWeekday weekday) {
  return switch (weekday) {
    TrainingWeekday.monday => l10n.weekdayMonday,
    TrainingWeekday.tuesday => l10n.weekdayTuesday,
    TrainingWeekday.wednesday => l10n.weekdayWednesday,
    TrainingWeekday.thursday => l10n.weekdayThursday,
    TrainingWeekday.friday => l10n.weekdayFriday,
    TrainingWeekday.saturday => l10n.weekdaySaturday,
    TrainingWeekday.sunday => l10n.weekdaySunday,
  };
}

String _formatTimestamp(DateTime value) {
  final local = value.toLocal();
  String two(int number) => number.toString().padLeft(2, '0');
  return '${local.year}-${two(local.month)}-${two(local.day)} ${two(local.hour)}:${two(local.minute)}';
}

String _exerciseModeLabel(AppLocalizations l10n, TrainingExerciseMode mode) {
  return switch (mode) {
    TrainingExerciseMode.general => l10n.practiceExerciseGeneralLabel,
    TrainingExerciseMode.warmupReset => l10n.practiceExerciseWarmupResetLabel,
    TrainingExerciseMode.laxVox => l10n.practiceExerciseLaxVoxLabel,
    TrainingExerciseMode.strawBubbles => l10n.practiceExerciseStrawBubblesLabel,
    TrainingExerciseMode.lipTrills => l10n.practiceExerciseLipTrillsLabel,
    TrainingExerciseMode.resonanceHum => l10n.practiceExerciseResonanceHumLabel,
    TrainingExerciseMode.pitchGlides => l10n.practiceExercisePitchGlidesLabel,
    TrainingExerciseMode.targetSpeech => l10n.practiceExerciseTargetSpeechLabel,
    TrainingExerciseMode.readingTransfer =>
      l10n.practiceExerciseReadingTransferLabel,
    TrainingExerciseMode.chestResonance =>
      l10n.practiceExerciseChestResonanceLabel,
    TrainingExerciseMode.articulationProjection =>
      l10n.practiceExerciseArticulationLabel,
  };
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
    );
  }
}

class _TrainingDayEditor extends StatelessWidget {
  const _TrainingDayEditor({
    required this.title,
    required this.dayPlan,
    required this.onDurationChanged,
    required this.onExerciseModeChanged,
    required this.onAddReminder,
    required this.onRemoveReminder,
  });

  final String title;
  final TrainingDayPlan dayPlan;
  final ValueChanged<int> onDurationChanged;
  final ValueChanged<TrainingExerciseMode> onExerciseModeChanged;
  final ValueChanged<TrainingReminderTime> onAddReminder;
  final ValueChanged<TrainingReminderTime> onRemoveReminder;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(VoxaSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(VoxaRadius.xl),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleMedium),
          const SizedBox(height: VoxaSpacing.md),
          DropdownButtonFormField<int>(
            initialValue: dayPlan.durationMinutes,
            decoration: InputDecoration(labelText: l10n.practiceSessionLength),
            items: [
              DropdownMenuItem(
                value: 5,
                child: Text(l10n.commonMinutesShort(5)),
              ),
              DropdownMenuItem(
                value: 10,
                child: Text(l10n.commonMinutesShort(10)),
              ),
              DropdownMenuItem(
                value: 15,
                child: Text(l10n.commonMinutesShort(15)),
              ),
              DropdownMenuItem(
                value: 20,
                child: Text(l10n.commonMinutesShort(20)),
              ),
              DropdownMenuItem(
                value: 30,
                child: Text(l10n.commonMinutesShort(30)),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                onDurationChanged(value);
              }
            },
          ),
          const SizedBox(height: VoxaSpacing.md),
          DropdownButtonFormField<TrainingExerciseMode>(
            initialValue: dayPlan.exerciseMode,
            decoration: InputDecoration(labelText: l10n.practiceExerciseFocus),
            items: TrainingExerciseMode.values
                .map(
                  (mode) => DropdownMenuItem(
                    value: mode,
                    child: Text(_exerciseModeLabel(l10n, mode)),
                  ),
                )
                .toList(growable: false),
            onChanged: (value) {
              if (value != null) {
                onExerciseModeChanged(value);
              }
            },
          ),
          const SizedBox(height: VoxaSpacing.md),
          Wrap(
            spacing: VoxaSpacing.sm,
            runSpacing: VoxaSpacing.sm,
            children: [
              for (final reminder in dayPlan.reminderTimes)
                InputChip(
                  label: Text(_formatReminderTime(context, reminder)),
                  onDeleted: () => onRemoveReminder(reminder),
                ),
              ActionChip(
                avatar: const Icon(Icons.add_alarm_outlined, size: 18),
                label: Text(l10n.settingsAddReminder),
                onPressed: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: const TimeOfDay(hour: 9, minute: 0),
                  );
                  if (picked != null) {
                    onAddReminder(
                      TrainingReminderTime(
                        hour: picked.hour,
                        minute: picked.minute,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatReminderTime(BuildContext context, TrainingReminderTime time) {
    return MaterialLocalizations.of(context).formatTimeOfDay(
      TimeOfDay(hour: time.hour, minute: time.minute),
      alwaysUse24HourFormat: true,
    );
  }
}
