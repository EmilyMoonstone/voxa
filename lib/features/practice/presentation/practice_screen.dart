import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voxa/l10n/app_localizations.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/theme/voxa_tokens.dart';
import '../../../core/widgets/voxa_panel.dart';
import '../../goal_setting/application/voice_target_use_cases.dart';
import '../../goal_setting/domain/voice_target.dart';
import '../../settings/application/app_settings_controller.dart';
import '../../training/domain/training_exercise_mode.dart';
import '../application/live_practice_controller.dart';
import '../domain/pitch_sample.dart';
import '../domain/pitch_training_mode.dart';
import '../domain/resonance_feedback.dart';
import '../domain/volume_feedback.dart';

enum PracticeEntryMode { live, record }

class PracticeScreen extends ConsumerStatefulWidget {
  const PracticeScreen({
    super.key,
    this.initialEntryMode = PracticeEntryMode.live,
  });

  final PracticeEntryMode initialEntryMode;

  static const chartMinHz = 50.0;
  static const chartMaxHz = 350.0;

  @override
  ConsumerState<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends ConsumerState<PracticeScreen> {
  late PracticeEntryMode _entryMode;

  @override
  void initState() {
    super.initState();
    _entryMode = widget.initialEntryMode;
  }

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(livePracticeControllerProvider);
    final controller = ref.read(livePracticeControllerProvider.notifier);
    final target = ref.watch(activeTargetProvider);
    final settings = ref.watch(appSettingsControllerProvider);
    final isIdleSetupState =
        state.status == PracticeSessionStatus.idle ||
        state.status == PracticeSessionStatus.error;

    if (target == null) {
      return _PracticeFrame(
        header: const _PracticeHeader(targetLabel: null),
        body: Center(
          child: VoxaPanel(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.homeNoTarget,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: VoxaSpacing.sm),
                Text(l10n.goalHelper),
                const SizedBox(height: VoxaSpacing.lg),
                FilledButton(
                  onPressed: () => const TargetRoute().go(context),
                  child: Text(l10n.practiceOpenTargetSetup),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (state.status == PracticeSessionStatus.permissionDenied) {
      return _PracticeFrame(
        header: _PracticeHeader(
          targetLabel: target.formatWithTolerance(settings.targetToleranceHz),
          sessionMeta: _ActiveSessionMetaBar(
            trainingMode: settings.lastPitchTrainingMode,
            exerciseMode: state.selectedExerciseMode,
          ),
        ),
        body: Center(
          child: VoxaPanel(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.practicePermissionTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: VoxaSpacing.sm),
                Text(l10n.practicePermissionBody),
                const SizedBox(height: VoxaSpacing.lg),
                Wrap(
                  spacing: VoxaSpacing.sm,
                  runSpacing: VoxaSpacing.sm,
                  children: [
                    FilledButton(
                      onPressed: controller.start,
                      child: Text(l10n.practiceGrantPermission),
                    ),
                    OutlinedButton(
                      onPressed: controller.openSettings,
                      child: Text(l10n.practiceOpenSettings),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    final currentSample = state.currentSample;
    final volumeState = classifyVolumeState(
      isVoiced: currentSample?.isVoiced ?? false,
      rmsDbfs: currentSample?.rmsDbfs ?? -120,
      targetVolumeDbfs: target.targetVolumeDbfs,
      toleranceDb: settings.targetVolumeToleranceDb,
    );
    final volumeStatusLabel = volumeValueLabel(
      l10n,
      volumeState,
      hasVolumeTarget: target.targetVolumeDbfs != null,
    );
    final volumeToneColor = volumeColor(
      volumeState,
      hasVolumeTarget: target.targetVolumeDbfs != null,
    );
    final resonanceFeedback =
        currentSample?.resonanceFeedback ??
        const ResonanceFeedback(
          state: ResonanceState.insufficientSignal,
          confidence: 0,
          brightnessRatio: 0,
          spectralTiltDbPerOct: 0,
          timestampMs: 0,
        );

    return _PracticeFrame(
      header: _PracticeHeader(
        targetLabel: target.formatWithTolerance(settings.targetToleranceHz),
        sessionMeta: !isIdleSetupState
            ? _ActiveSessionMetaBar(
                trainingMode: settings.lastPitchTrainingMode,
                exerciseMode: state.selectedExerciseMode,
              )
            : null,
      ),
      body:
          state.status == PracticeSessionStatus.reviewReady &&
              state.review != null
          ? _PracticeReview(
              review: state.review!,
              onSave: () async {
                final sessionId = await controller.saveReview();
                if (context.mounted && sessionId != null) {
                  SessionDetailRoute(sessionId).go(context);
                }
              },
              onRepeat: controller.repeatSession,
              onDiscard: controller.discardReview,
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                final layout = _PracticeLayoutSpec.fromSize(
                  MediaQuery.sizeOf(context),
                );
                final availableHeight = constraints.maxHeight;
                final chartHeight = math.min(
                  math.max(
                    layout.chartMinHeight,
                    availableHeight * layout.chartHeightFactor,
                  ),
                  math.max(
                    layout.chartMinHeight * 0.75,
                    availableHeight -
                        layout.controlsHeight -
                        (layout.sectionGap * 2) -
                        layout.feedbackViewportMinHeight,
                  ),
                );

                final practiceContent = Column(
                  children: [
                    SizedBox(
                      height: chartHeight,
                      child: _ChartPanel(
                        target: target,
                        toleranceHz: settings.targetToleranceHz,
                        recentSamples: state.recentSamples,
                        currentSample: currentSample,
                        sessionStatus: state.status,
                      ),
                    ),
                    SizedBox(height: layout.sectionGap),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _PrimaryStatsRow(
                              timeAtTargetPercent: state.timeAtTargetPercent,
                              remainingSeconds: state.remainingSeconds,
                              volumeLabel: volumeStatusLabel,
                              volumeColor: volumeToneColor,
                              resonanceFeedback: resonanceFeedback,
                            ),
                            SizedBox(height: layout.sectionGap),
                            _TipCard(
                              text: _tipText(
                                l10n: l10n,
                                status: state.status,
                                currentSample: currentSample,
                                trainingMode: settings.lastPitchTrainingMode,
                                resonanceFeedback: resonanceFeedback,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: layout.sectionGap),
                    _ControlsRow(
                      state: state.status,
                      onStart: controller.start,
                      onPause: controller.pause,
                      onResume: controller.resume,
                      onStop: controller.stop,
                    ),
                  ],
                );

                if (!isIdleSetupState) {
                  return practiceContent;
                }

                return Stack(
                  children: [
                    Positioned.fill(
                      child: IgnorePointer(
                        child: Opacity(
                          opacity: 0.52,
                          child: ImageFiltered(
                            imageFilter: ImageFilter.blur(
                              sigmaX: 9,
                              sigmaY: 9,
                            ),
                            child: practiceContent,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          vertical: VoxaSpacing.md,
                        ),
                        child: _IdleSetupCard(
                          entryMode: _entryMode,
                          trainingMode: settings.lastPitchTrainingMode,
                          exerciseMode: state.selectedExerciseMode,
                          plannedDurationMinutes: state.plannedDurationMinutes,
                          onEntryModeChanged: (mode) {
                            setState(() => _entryMode = mode);
                          },
                          onTrainingModeChanged: (mode) {
                            ref
                                .read(appSettingsControllerProvider.notifier)
                                .setLastPitchTrainingMode(mode);
                          },
                          onExerciseModeChanged: controller.setExerciseMode,
                          onDurationChanged:
                              controller.setPlannedDurationMinutes,
                          onStart: () {
                            if (_entryMode == PracticeEntryMode.record) {
                              const PracticeRecordRoute().go(context);
                              return;
                            }
                            controller.start();
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }

  static String _tipText({
    required AppLocalizations l10n,
    required PracticeSessionStatus status,
    required PitchSample? currentSample,
    required PitchTrainingMode trainingMode,
    required ResonanceFeedback resonanceFeedback,
  }) {
    if (status == PracticeSessionStatus.paused) {
      return l10n.practicePaused;
    }
    if (currentSample == null) {
      return trainingMode == PitchTrainingMode.sound
          ? l10n.practiceSoundIdle
          : l10n.practiceSpeechIdle;
    }
    return switch (currentSample.stateCategory) {
      PitchStateCategory.low => l10n.practiceStatusLow,
      PitchStateCategory.atTarget => resonanceHelper(
        l10n,
        resonanceFeedback.state,
        trainingMode,
      ),
      PitchStateCategory.high => l10n.practiceStatusHigh,
      PitchStateCategory.unvoiced => l10n.practiceStatusUnvoiced,
    };
  }

  static String volumeValueLabel(
    AppLocalizations l10n,
    VolumeState state, {
    required bool hasVolumeTarget,
  }) {
    if (!hasVolumeTarget) {
      return l10n.practiceVolumeNotSet;
    }
    return switch (state) {
      VolumeState.quiet => l10n.practiceVolumeQuiet,
      VolumeState.atTarget => l10n.practiceVolumeAtTarget,
      VolumeState.loud => l10n.practiceVolumeLoud,
      VolumeState.unclear => l10n.practiceVolumeUnclear,
    };
  }

  static Color volumeColor(VolumeState state, {required bool hasVolumeTarget}) {
    if (!hasVolumeTarget) {
      return VoxaColors.iris;
    }
    return switch (state) {
      VolumeState.quiet => VoxaColors.coral,
      VolumeState.atTarget => VoxaColors.pitchInRange,
      VolumeState.loud => VoxaColors.warning,
      VolumeState.unclear => VoxaColors.iris,
    };
  }

  static Color stateColor(PitchStateCategory category) {
    return switch (category) {
      PitchStateCategory.low => VoxaColors.coral,
      PitchStateCategory.atTarget => VoxaColors.pitchInRange,
      PitchStateCategory.high => VoxaColors.pitchHigh,
      PitchStateCategory.unvoiced => VoxaColors.iris,
    };
  }

  static String resonanceLabel(AppLocalizations l10n, ResonanceState state) {
    return switch (state) {
      ResonanceState.insufficientSignal => l10n.resonanceStateInsufficient,
      ResonanceState.dark => l10n.resonanceStateDark,
      ResonanceState.balanced => l10n.resonanceStateBalanced,
      ResonanceState.bright => l10n.resonanceStateBright,
      ResonanceState.unstable => l10n.resonanceStateUnstable,
    };
  }

  static String resonanceHelper(
    AppLocalizations l10n,
    ResonanceState state,
    PitchTrainingMode mode,
  ) {
    return switch (state) {
      ResonanceState.insufficientSignal => l10n.resonanceHelperInsufficient,
      ResonanceState.dark =>
        mode == PitchTrainingMode.sound
            ? l10n.resonanceHelperDarkSound
            : l10n.resonanceHelperDarkSpeech,
      ResonanceState.balanced =>
        mode == PitchTrainingMode.sound
            ? l10n.resonanceHelperBalancedSound
            : l10n.resonanceHelperBalancedSpeech,
      ResonanceState.bright =>
        mode == PitchTrainingMode.sound
            ? l10n.resonanceHelperBrightSound
            : l10n.resonanceHelperBrightSpeech,
      ResonanceState.unstable => l10n.resonanceHelperUnstable,
    };
  }

  static Color resonanceColor(ResonanceState state) {
    return switch (state) {
      ResonanceState.insufficientSignal => VoxaColors.iris,
      ResonanceState.dark => VoxaColors.coral,
      ResonanceState.balanced => VoxaColors.pitchInRange,
      ResonanceState.bright => VoxaColors.pitchHigh,
      ResonanceState.unstable => VoxaColors.warning,
    };
  }

  static IconData resonanceIcon(ResonanceState state) {
    return switch (state) {
      ResonanceState.insufficientSignal => Icons.hearing_disabled_outlined,
      ResonanceState.dark => Icons.south_rounded,
      ResonanceState.balanced => Icons.check_circle_outline_rounded,
      ResonanceState.bright => Icons.north_rounded,
      ResonanceState.unstable => Icons.waves_outlined,
    };
  }

  static String exerciseModeLabel(
    AppLocalizations l10n,
    TrainingExerciseMode mode,
  ) {
    return switch (mode) {
      TrainingExerciseMode.general => l10n.practiceExerciseGeneralLabel,
      TrainingExerciseMode.warmupReset => l10n.practiceExerciseWarmupResetLabel,
      TrainingExerciseMode.laxVox => l10n.practiceExerciseLaxVoxLabel,
      TrainingExerciseMode.strawBubbles =>
        l10n.practiceExerciseStrawBubblesLabel,
      TrainingExerciseMode.lipTrills => l10n.practiceExerciseLipTrillsLabel,
      TrainingExerciseMode.resonanceHum =>
        l10n.practiceExerciseResonanceHumLabel,
      TrainingExerciseMode.pitchGlides => l10n.practiceExercisePitchGlidesLabel,
      TrainingExerciseMode.targetSpeech =>
        l10n.practiceExerciseTargetSpeechLabel,
      TrainingExerciseMode.readingTransfer =>
        l10n.practiceExerciseReadingTransferLabel,
      TrainingExerciseMode.chestResonance =>
        l10n.practiceExerciseChestResonanceLabel,
      TrainingExerciseMode.articulationProjection =>
        l10n.practiceExerciseArticulationLabel,
    };
  }

}

class _PracticeFrame extends StatelessWidget {
  const _PracticeFrame({required this.header, required this.body});

  final Widget header;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final layout = _PracticeLayoutSpec.fromSize(size);

    return DecoratedBox(
      decoration: const BoxDecoration(gradient: voxaAmbientBackground),
      child: Stack(
        children: [
          Positioned(
            top: -120,
            left: -100,
            child: _GlowOrb(
              size: 260,
              color: VoxaColors.aqua.withValues(alpha: 0.12),
            ),
          ),
          Positioned(
            top: 160,
            right: -80,
            child: _GlowOrb(
              size: 240,
              color: VoxaColors.iris.withValues(alpha: 0.14),
            ),
          ),
          Positioned(
            bottom: 80,
            left: -60,
            child: _GlowOrb(
              size: 220,
              color: VoxaColors.teal.withValues(alpha: 0.10),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              layout.horizontalPadding,
              layout.topPadding,
              layout.horizontalPadding,
              layout.bottomPadding,
            ),
            child: Column(
              children: [
                SizedBox(height: layout.headerHeight, child: header),
                SizedBox(height: layout.sectionGap),
                Expanded(child: body),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PracticeHeader extends StatelessWidget {
  const _PracticeHeader({
    required this.targetLabel,
    this.sessionMeta,
  });

  final String? targetLabel;
  final Widget? sessionMeta;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.practiceEyebrow,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: VoxaColors.aqua,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.practiceLiveFeedbackTitle,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            if (targetLabel != null) ...[
              const SizedBox(width: VoxaSpacing.sm),
              _TargetBadge(label: targetLabel!),
            ],
          ],
        ),
        const SizedBox(height: VoxaSpacing.md),
        ...?(sessionMeta == null ? null : [sessionMeta!]),
      ],
    );
  }
}

class _ActiveSessionMetaBar extends StatelessWidget {
  const _ActiveSessionMetaBar({
    required this.trainingMode,
    required this.exerciseMode,
  });

  final PitchTrainingMode trainingMode;
  final TrainingExerciseMode exerciseMode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Wrap(
      spacing: VoxaSpacing.sm,
      runSpacing: VoxaSpacing.sm,
      children: [
        _MetaPill(
          icon: trainingMode == PitchTrainingMode.sound
              ? Icons.graphic_eq_rounded
              : Icons.record_voice_over_rounded,
          label: trainingMode == PitchTrainingMode.sound
              ? l10n.practiceModeSound
              : l10n.practiceModeSpeech,
        ),
        _MetaPill(
          icon: Icons.fitness_center_rounded,
          label: _PracticeScreenState.exerciseModeLabel(l10n, exerciseMode),
        ),
      ],
    );
  }
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      constraints: const BoxConstraints(maxWidth: 220),
      padding: const EdgeInsets.symmetric(
        horizontal: VoxaSpacing.md,
        vertical: VoxaSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: VoxaColors.aqua),
          const SizedBox(width: VoxaSpacing.xs),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IdleSetupCard extends StatelessWidget {
  const _IdleSetupCard({
    required this.entryMode,
    required this.trainingMode,
    required this.exerciseMode,
    required this.plannedDurationMinutes,
    required this.onEntryModeChanged,
    required this.onTrainingModeChanged,
    required this.onExerciseModeChanged,
    required this.onDurationChanged,
    required this.onStart,
  });

  final PracticeEntryMode entryMode;
  final PitchTrainingMode trainingMode;
  final TrainingExerciseMode exerciseMode;
  final int plannedDurationMinutes;
  final ValueChanged<PracticeEntryMode> onEntryModeChanged;
  final ValueChanged<PitchTrainingMode> onTrainingModeChanged;
  final ValueChanged<TrainingExerciseMode> onExerciseModeChanged;
  final ValueChanged<int> onDurationChanged;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: VoxaPanel(
        padding: const EdgeInsets.all(VoxaSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.practiceSessionSetupTitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: VoxaSpacing.lg),
            SegmentedButton<PracticeEntryMode>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(
                  value: PracticeEntryMode.live,
                  label: Text(l10n.practiceSessionTypeLive),
                  icon: const Icon(Icons.show_chart_rounded),
                ),
                ButtonSegment(
                  value: PracticeEntryMode.record,
                  label: Text(l10n.practiceSessionTypeRecord),
                  icon: const Icon(Icons.mic_rounded),
                ),
              ],
              selected: {entryMode},
              onSelectionChanged: (selection) =>
                  onEntryModeChanged(selection.first),
            ),
            const SizedBox(height: VoxaSpacing.lg),
            SegmentedButton<PitchTrainingMode>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(
                  value: PitchTrainingMode.sound,
                  label: Text(l10n.practiceModeSound),
                ),
                ButtonSegment(
                  value: PitchTrainingMode.speech,
                  label: Text(l10n.practiceModeSpeech),
                ),
              ],
              selected: {trainingMode},
              onSelectionChanged: (selection) =>
                  onTrainingModeChanged(selection.first),
            ),
            const SizedBox(height: VoxaSpacing.lg),
            DropdownButtonFormField<TrainingExerciseMode>(
              initialValue: exerciseMode,
              decoration: InputDecoration(
                labelText: l10n.practiceExerciseFocus,
              ),
              items: TrainingExerciseMode.values
                  .map(
                    (mode) => DropdownMenuItem(
                      value: mode,
                      child: Text(
                        _PracticeScreenState.exerciseModeLabel(l10n, mode),
                      ),
                    ),
                  )
                  .toList(growable: false),
              onChanged: (value) {
                if (value != null) {
                  onExerciseModeChanged(value);
                }
              },
            ),
            const SizedBox(height: VoxaSpacing.lg),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: VoxaSpacing.sm,
              runSpacing: VoxaSpacing.sm,
              children: [5, 10, 15, 20, 30].map((minutes) {
                return ChoiceChip(
                  label: Text(l10n.commonMinutesShort(minutes)),
                  selected: plannedDurationMinutes == minutes,
                  onSelected: (_) => onDurationChanged(minutes),
                );
              }).toList(),
            ),
            const SizedBox(height: VoxaSpacing.xl),
            FilledButton(
              onPressed: onStart,
              child: Text(
                entryMode == PracticeEntryMode.record
                    ? l10n.practiceSessionTypeRecord
                    : l10n.practiceStart,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TargetBadge extends StatelessWidget {
  const _TargetBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
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
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: VoxaColors.aqua,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _PrimaryStatsRow extends StatelessWidget {
  const _PrimaryStatsRow({
    required this.timeAtTargetPercent,
    required this.remainingSeconds,
    required this.volumeLabel,
    required this.volumeColor,
    required this.resonanceFeedback,
  });

  final double timeAtTargetPercent;
  final int remainingSeconds;
  final String volumeLabel;
  final Color volumeColor;
  final ResonanceFeedback resonanceFeedback;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final layout = _PracticeLayoutSpec.fromSize(MediaQuery.sizeOf(context));
    return VoxaPanel(
      padding: EdgeInsets.all(layout.panelPadding),
      child: SizedBox(
        height: layout.feedbackCardHeight,
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _InlineStat(
                      label: l10n.practiceStatInRange,
                      value: l10n.commonPercent(
                        timeAtTargetPercent.round().toString(),
                      ),
                      color: VoxaColors.aqua,
                      icon: Icons.track_changes_rounded,
                    ),
                  ),
                  const _FeedbackDivider.vertical(),
                  Expanded(
                    child: _InlineStat(
                      label: l10n.practiceStatTimeLeft,
                      value:
                          '${(remainingSeconds ~/ 60).toString().padLeft(2, '0')}:${(remainingSeconds % 60).toString().padLeft(2, '0')}',
                      color: Colors.white,
                      icon: Icons.timer_outlined,
                    ),
                  ),
                ],
              ),
            ),
            const _FeedbackDivider.horizontal(),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _InlineStat(
                      label: l10n.practiceVolumeLabel,
                      value: volumeLabel,
                      color: volumeColor,
                      icon: Icons.multitrack_audio_rounded,
                    ),
                  ),
                  const _FeedbackDivider.vertical(),
                  Expanded(
                    child: _InlineStat(
                      label: l10n.resonanceTitle,
                      value: _PracticeScreenState.resonanceLabel(
                        l10n,
                        resonanceFeedback.state,
                      ),
                      color: _PracticeScreenState.resonanceColor(
                        resonanceFeedback.state,
                      ),
                      icon: _PracticeScreenState.resonanceIcon(
                        resonanceFeedback.state,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeedbackDivider extends StatelessWidget {
  const _FeedbackDivider.vertical() : axis = Axis.vertical;

  const _FeedbackDivider.horizontal() : axis = Axis.horizontal;

  final Axis axis;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: 0.10);
    return axis == Axis.vertical
        ? Container(
            width: 1,
            margin: const EdgeInsets.symmetric(horizontal: VoxaSpacing.sm),
            color: color,
          )
        : Container(
            height: 1,
            margin: const EdgeInsets.symmetric(vertical: VoxaSpacing.sm),
            color: color,
          );
  }
}

class _InlineStat extends StatelessWidget {
  const _InlineStat({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  final String label;
  final String value;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: VoxaSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.56),
                ),
              ),
              const SizedBox(height: 2),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      value,
                      maxLines: 1,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w800,
                        height: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TipCard extends StatelessWidget {
  const _TipCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VoxaPanel(
      padding: const EdgeInsets.all(VoxaSpacing.lg),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: VoxaColors.iris.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.lightbulb_outline_rounded,
              color: VoxaColors.iris,
            ),
          ),
          const SizedBox(width: VoxaSpacing.md),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _PracticeReview extends StatelessWidget {
  const _PracticeReview({
    required this.review,
    required this.onSave,
    required this.onRepeat,
    required this.onDiscard,
  });

  final PracticeSessionReview review;
  final Future<void> Function() onSave;
  final Future<void> Function() onRepeat;
  final VoidCallback onDiscard;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final analysis = review.analysis;
    final inRangePercent = analysis.totalTrackedTimeMs == 0
        ? 0
        : ((analysis.timeAtTargetMs / analysis.totalTrackedTimeMs) * 100)
              .round();

    return ListView(
      children: [
        VoxaPanel(
          padding: const EdgeInsets.all(VoxaSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.practiceReviewTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: VoxaSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: l10n.recordAvgLabel,
                      value: l10n.commonHz(
                        (analysis.averagePitchHz?.round() ?? '--').toString(),
                      ),
                      color: VoxaColors.aqua,
                    ),
                  ),
                  const SizedBox(width: VoxaSpacing.md),
                  Expanded(
                    child: _StatCard(
                      label: l10n.practiceStatInRange,
                      value: l10n.commonPercent(inRangePercent.toString()),
                      color: VoxaColors.pitchInRange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: VoxaSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: l10n.commonMin,
                      value: l10n.commonHz(
                        (analysis.minPitchHz?.round() ?? '--').toString(),
                      ),
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: VoxaSpacing.md),
                  Expanded(
                    child: _StatCard(
                      label: l10n.commonMax,
                      value: l10n.commonHz(
                        (analysis.maxPitchHz?.round() ?? '--').toString(),
                      ),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: VoxaSpacing.md),
        Row(
          children: [
            Expanded(
              child: FilledButton(
                onPressed: onSave,
                child: Text(l10n.commonSave),
              ),
            ),
            const SizedBox(width: VoxaSpacing.md),
            Expanded(
              child: OutlinedButton(
                onPressed: onRepeat,
                child: Text(l10n.commonRepeat),
              ),
            ),
          ],
        ),
        const SizedBox(height: VoxaSpacing.sm),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: onDiscard,
            child: Text(l10n.commonDiscard),
          ),
        ),
      ],
    );
  }
}

class _ChartPanel extends StatelessWidget {
  const _ChartPanel({
    required this.target,
    required this.toleranceHz,
    required this.recentSamples,
    required this.currentSample,
    required this.sessionStatus,
  });

  final VoiceTarget target;
  final int toleranceHz;
  final List<PitchSample> recentSamples;
  final PitchSample? currentSample;
  final PracticeSessionStatus sessionStatus;
  static const _chartWindowMs = 4000;
  static const _pitchHoldMs = 1500;
  static const _axisLabelValues = [350, 300, 250, 200, 150, 100, 50];

  @override
  Widget build(BuildContext context) {
    final pointColor = _PracticeScreenState.stateColor(
      currentSample?.stateCategory ?? PitchStateCategory.unvoiced,
    );
    final layout = _PracticeLayoutSpec.fromSize(MediaQuery.sizeOf(context));
    final stopped = sessionStatus == PracticeSessionStatus.reviewReady;

    return VoxaPanel(
      padding: EdgeInsets.fromLTRB(
        layout.panelPadding,
        layout.panelPadding,
        layout.panelPadding,
        layout.chartBottomPadding,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final visibleSamples = _visibleSamples(
            recentSamples,
            stopped: stopped,
          );
          final highlightedSample = _latestVoicedSample(visibleSamples);
          final highlightColor = highlightedSample == null
              ? pointColor
              : _sampleColor(highlightedSample);
          final chartWidth = stopped
              ? math.max(
                  constraints.maxWidth,
                  _chartWidthForStoppedSamples(
                    visibleSamples,
                    constraints.maxWidth,
                  ),
                )
              : constraints.maxWidth;
          final chartHeight = constraints.maxHeight;
          final point = _latestPoint(
            Size(chartWidth, chartHeight),
            visibleSamples,
          );
          final chart = SizedBox(
            width: chartWidth,
            height: chartHeight,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: RepaintBoundary(
                    child: CustomPaint(
                      painter: _RealtimeChartPainter(
                        target: target,
                        toleranceHz: toleranceHz,
                        samples: visibleSamples,
                      ),
                    ),
                  ),
                ),
                for (final hz in _axisLabelValues)
                  Positioned(
                    left: 4,
                    top: _labelTopForHz(chartHeight, hz.toDouble()),
                    child: _ChartLegendLabel(frequencyHz: hz),
                  ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Center(
                    child: Text(
                      stopped
                          ? AppLocalizations.of(context)!.practiceChartDrag
                          : AppLocalizations.of(context)!.practiceChartNow,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.56),
                      ),
                    ),
                  ),
                ),
                if (highlightedSample?.frequencyHz != null && point != null)
                  Positioned(
                    left: (point.dx - 86).clamp(
                      0.0,
                      math.max(0.0, chartWidth - 172),
                    ),
                    top: math.max(0, point.dy - 86),
                    child: _PitchCallout(
                      frequencyHz: highlightedSample!.frequencyHz!,
                      color: highlightColor,
                    ),
                  ),
                if (point != null)
                  Positioned(
                    left: point.dx - 7,
                    top: point.dy - 7,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: highlightColor.withValues(alpha: 0.42),
                            blurRadius: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );

          if (!stopped) {
            return chart;
          }

          return ClipRect(
            child: InteractiveViewer(
              constrained: false,
              boundaryMargin: const EdgeInsets.all(48),
              minScale: 1,
              maxScale: 2,
              child: chart,
            ),
          );
        },
      ),
    );
  }

  Offset? _latestPoint(Size size, List<PitchSample> samples) {
    final voicedSamples = samples
        .where((sample) => sample.frequencyHz != null && sample.isVoiced)
        .toList(growable: false);
    if (voicedSamples.isEmpty || samples.isEmpty) {
      return null;
    }

    final last = voicedSamples.last;
    final startTimestamp = samples.first.timestampMs;
    final endTimestamp = math.max(startTimestamp + 1, samples.last.timestampMs);
    final dx =
        size.width *
        ((last.timestampMs - startTimestamp) / (endTimestamp - startTimestamp));
    final normalized =
        ((last.frequencyHz! - PracticeScreen.chartMinHz) /
                (PracticeScreen.chartMaxHz - PracticeScreen.chartMinHz))
            .clamp(0.0, 1.0);
    final dy = size.height - (size.height * normalized);
    return Offset(dx, dy);
  }

  PitchSample? _latestVoicedSample(List<PitchSample> samples) {
    for (var index = samples.length - 1; index >= 0; index--) {
      final sample = samples[index];
      if (sample.isVoiced && sample.frequencyHz != null) {
        return sample;
      }
    }
    return null;
  }

  List<PitchSample> _visibleSamples(
    List<PitchSample> samples, {
    required bool stopped,
  }) {
    if (samples.isEmpty) {
      return const [];
    }
    if (stopped) {
      return samples;
    }
    final latestTimestamp = _anchorTimestamp(samples);
    return samples
        .where(
          (sample) => latestTimestamp - sample.timestampMs <= _chartWindowMs,
        )
        .toList(growable: false);
  }

  int _anchorTimestamp(List<PitchSample> samples) {
    final latestSampleTimestamp = samples.last.timestampMs;
    final lastVoiced = samples.lastWhere(
      (sample) => sample.isVoiced && sample.frequencyHz != null,
      orElse: () => samples.last,
    );
    return math.min(
      latestSampleTimestamp,
      lastVoiced.timestampMs + _pitchHoldMs,
    );
  }

  double _chartWidthForStoppedSamples(
    List<PitchSample> samples,
    double minWidth,
  ) {
    if (samples.length < 2) {
      return minWidth;
    }
    final durationMs = samples.last.timestampMs - samples.first.timestampMs;
    final seconds = math.max(4, (durationMs / 1000).ceil());
    return math.max(minWidth, seconds * 120);
  }

  Color _sampleColor(PitchSample sample) {
    final frequencyHz = sample.frequencyHz;
    if (frequencyHz == null || !sample.isVoiced) {
      return VoxaColors.iris;
    }
    if ((frequencyHz - target.targetHz).abs() <= toleranceHz) {
      return VoxaColors.pitchInRange;
    }
    if (_isWithinBand(frequencyHz, TargetPreset.masculine)) {
      return VoxaColors.coral;
    }
    if (_isWithinBand(frequencyHz, TargetPreset.androgynous)) {
      return VoxaColors.aqua;
    }
    if (_isWithinBand(frequencyHz, TargetPreset.feminine)) {
      return VoxaColors.pitchHigh;
    }

    if (frequencyHz < presetReferenceBands[TargetPreset.masculine]!.minHz) {
      return VoxaColors.coral;
    }
    if (frequencyHz > presetReferenceBands[TargetPreset.feminine]!.maxHz) {
      return VoxaColors.pitchHigh;
    }

    return frequencyHz < target.targetHz
        ? VoxaColors.aqua
        : VoxaColors.pitchHigh;
  }

  bool _isWithinBand(double frequencyHz, TargetPreset preset) {
    final band = presetReferenceBands[preset]!;
    return frequencyHz >= band.minHz && frequencyHz <= band.maxHz;
  }

  double _labelTopForHz(double chartHeight, double hz) {
    final normalized =
        ((hz - PracticeScreen.chartMinHz) /
                (PracticeScreen.chartMaxHz - PracticeScreen.chartMinHz))
            .clamp(0.0, 1.0);
    final top = chartHeight - (chartHeight * normalized) - 8;
    return top.clamp(0.0, math.max(0.0, chartHeight - 16));
  }
}

class _RealtimeChartPainter extends CustomPainter {
  const _RealtimeChartPainter({
    required this.target,
    required this.toleranceHz,
    required this.samples,
  });

  final VoiceTarget target;
  final int toleranceHz;
  final List<PitchSample> samples;
  static const _chartWindowMs = 4000;

  @override
  void paint(Canvas canvas, Size size) {
    final framePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke;
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..strokeWidth = 1;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Offset.zero & size,
        const Radius.circular(VoxaRadius.lg),
      ),
      framePaint,
    );

    for (final hz in const [50.0, 100.0, 150.0, 200.0, 250.0, 300.0, 350.0]) {
      final y = _yForHz(size, hz);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    _paintBand(
      canvas,
      size,
      minHz: presetReferenceBands[TargetPreset.masculine]!.minHz,
      maxHz: presetReferenceBands[TargetPreset.masculine]!.maxHz,
      color: VoxaColors.coral,
    );
    _paintBand(
      canvas,
      size,
      minHz: presetReferenceBands[TargetPreset.androgynous]!.minHz,
      maxHz: presetReferenceBands[TargetPreset.androgynous]!.maxHz,
      color: VoxaColors.aqua,
    );
    _paintBand(
      canvas,
      size,
      minHz: presetReferenceBands[TargetPreset.feminine]!.minHz,
      maxHz: presetReferenceBands[TargetPreset.feminine]!.maxHz,
      color: VoxaColors.pitchHigh,
    );

    final targetY = _yForHz(size, target.targetHz);
    final targetGlow = Paint()
      ..color = VoxaColors.pitchInRange.withValues(alpha: 0.22)
      ..strokeWidth = 10
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    final targetLine = Paint()
      ..color = VoxaColors.pitchInRange.withValues(alpha: 0.92)
      ..strokeWidth = 2;
    canvas.drawLine(
      Offset(0, targetY),
      Offset(size.width, targetY),
      targetGlow,
    );
    canvas.drawLine(
      Offset(0, targetY),
      Offset(size.width, targetY),
      targetLine,
    );

    if (samples.length < 2) {
      return;
    }

    final visibleSamples = samples
        .where(
          (sample) =>
              samples.last.timestampMs - sample.timestampMs <= _chartWindowMs,
        )
        .toList(growable: false);
    if (visibleSamples.length < 2) {
      return;
    }

    final startTimestamp = visibleSamples.first.timestampMs;
    final endTimestamp = math.max(
      startTimestamp + 1,
      visibleSamples.last.timestampMs,
    );
    Offset? previousPoint;
    Color? previousColor;
    for (final sample in visibleSamples) {
      if (!sample.isVoiced || sample.frequencyHz == null) {
        previousPoint = null;
        previousColor = null;
        continue;
      }

      final dx =
          size.width *
          ((sample.timestampMs - startTimestamp) /
              (endTimestamp - startTimestamp));
      final dy = _yForHz(size, sample.frequencyHz!);
      final point = Offset(dx, dy);
      final color = _colorForFrequency(sample.frequencyHz!);
      if (previousPoint != null && previousColor != null) {
        _paintSegment(canvas, previousPoint, point, previousColor, color);
      }
      previousPoint = point;
      previousColor = color;
    }
  }

  void _paintBand(
    Canvas canvas,
    Size size, {
    required double minHz,
    required double maxHz,
    required Color color,
  }) {
    final top = _yForHz(size, maxHz);
    final bottom = _yForHz(size, minHz);
    final rect = Rect.fromLTRB(0, top, size.width, bottom);
    final glowRect = Rect.fromLTRB(
      -size.width * 0.08,
      top - 14,
      size.width * 1.08,
      bottom + 14,
    );
    final glowPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          color.withValues(alpha: 0),
          color.withValues(alpha: 0.012),
          color.withValues(alpha: 0.028),
          color.withValues(alpha: 0.012),
          color.withValues(alpha: 0),
        ],
        stops: const [0, 0.18, 0.5, 0.82, 1],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(glowRect)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 22);
    canvas.drawRRect(
      RRect.fromRectAndRadius(glowRect, const Radius.circular(VoxaRadius.xl)),
      glowPaint,
    );

    final shader = LinearGradient(
      colors: [
        color.withValues(alpha: 0),
        color.withValues(alpha: 0.02),
        color.withValues(alpha: 0.038),
        color.withValues(alpha: 0.02),
        color.withValues(alpha: 0),
      ],
      stops: const [0, 0.18, 0.5, 0.82, 1],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).createShader(rect);
    final verticalShader = LinearGradient(
      colors: [
        Colors.transparent,
        color.withValues(alpha: 0.012),
        color.withValues(alpha: 0.026),
        color.withValues(alpha: 0.012),
        Colors.transparent,
      ],
      stops: const [0, 0.12, 0.5, 0.88, 1],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ).createShader(rect);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(VoxaRadius.lg)),
      Paint()..shader = shader,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(VoxaRadius.lg)),
      Paint()..shader = verticalShader,
    );
  }

  void _paintSegment(
    Canvas canvas,
    Offset start,
    Offset end,
    Color startColor,
    Color endColor,
  ) {
    final shaderRect = Rect.fromPoints(start, end).inflate(18);
    final gradient = LinearGradient(
      colors: [startColor, endColor],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).createShader(shaderRect);
    final glowPaint = Paint()
      ..shader = gradient
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7);
    final linePaint = Paint()
      ..shader = gradient
      ..strokeWidth = 4.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(start, end, glowPaint);
    canvas.drawLine(start, end, linePaint);
  }

  Color _colorForFrequency(double frequencyHz) {
    if ((frequencyHz - target.targetHz).abs() <= toleranceHz) {
      return VoxaColors.pitchInRange;
    }
    if (_isWithinBand(frequencyHz, TargetPreset.masculine)) {
      return VoxaColors.coral;
    }
    if (_isWithinBand(frequencyHz, TargetPreset.androgynous)) {
      return VoxaColors.aqua;
    }
    if (_isWithinBand(frequencyHz, TargetPreset.feminine)) {
      return VoxaColors.pitchHigh;
    }
    if (frequencyHz < presetReferenceBands[TargetPreset.masculine]!.minHz) {
      return VoxaColors.coral;
    }
    if (frequencyHz > presetReferenceBands[TargetPreset.feminine]!.maxHz) {
      return VoxaColors.pitchHigh;
    }
    return frequencyHz < target.targetHz
        ? VoxaColors.aqua
        : VoxaColors.pitchHigh;
  }

  bool _isWithinBand(double frequencyHz, TargetPreset preset) {
    final band = presetReferenceBands[preset]!;
    return frequencyHz >= band.minHz && frequencyHz <= band.maxHz;
  }

  double _yForHz(Size size, double hz) {
    final normalized =
        ((hz - PracticeScreen.chartMinHz) /
                (PracticeScreen.chartMaxHz - PracticeScreen.chartMinHz))
            .clamp(0.0, 1.0);
    return size.height - (size.height * normalized);
  }

  @override
  bool shouldRepaint(covariant _RealtimeChartPainter oldDelegate) {
    return oldDelegate.target != target ||
        oldDelegate.toleranceHz != toleranceHz ||
        oldDelegate.samples != samples;
  }
}

class _ChartLegendLabel extends StatelessWidget {
  const _ChartLegendLabel({required this.frequencyHz});

  final int frequencyHz;

  @override
  Widget build(BuildContext context) {
    return Text(
      AppLocalizations.of(context)!.commonHz(frequencyHz.toString()),
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: Colors.white.withValues(alpha: 0.56),
      ),
    );
  }
}

class _PitchCallout extends StatelessWidget {
  const _PitchCallout({required this.frequencyHz, required this.color});

  final double frequencyHz;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: VoxaSpacing.lg,
        vertical: VoxaSpacing.md,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(VoxaRadius.lg),
        border: Border.all(color: color.withValues(alpha: 0.42)),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: frequencyHz.round().toString(),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            TextSpan(
              text: ' ${AppLocalizations.of(context)!.commonUnitHz}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white.withValues(alpha: 0.92),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final layout = _PracticeLayoutSpec.fromSize(MediaQuery.sizeOf(context));
    final valueStyle = theme.textTheme.titleLarge?.copyWith(
      color: color,
      fontWeight: FontWeight.w800,
      height: 1.05,
    );

    return SizedBox(
      height: layout.statCardHeight,
      child: VoxaPanel(
        padding: EdgeInsets.all(layout.panelPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.56),
              ),
            ),
            SizedBox(height: layout.statValueGap),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: valueStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ControlsRow extends StatelessWidget {
  const _ControlsRow({
    required this.state,
    required this.onStart,
    required this.onPause,
    required this.onResume,
    required this.onStop,
  });

  final PracticeSessionStatus state;
  final Future<void> Function() onStart;
  final Future<void> Function() onPause;
  final Future<void> Function() onResume;
  final Future<void> Function() onStop;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final buttons = <Widget>[];

    if (state == PracticeSessionStatus.idle ||
        state == PracticeSessionStatus.error) {
      buttons.add(
        Expanded(
          child: FilledButton(
            onPressed: onStart,
            child: Text(l10n.practiceStart),
          ),
        ),
      );
      buttons.add(const SizedBox(width: VoxaSpacing.md));
      buttons.add(
        Expanded(
          child: OutlinedButton(
            onPressed: () => const PracticeRecordRoute().go(context),
            child: Text(l10n.practiceSwitchToRecord),
          ),
        ),
      );
    } else if (state == PracticeSessionStatus.running) {
      buttons.add(
        Expanded(
          child: FilledButton.tonal(
            onPressed: onPause,
            child: Text(l10n.practicePause),
          ),
        ),
      );
      buttons.add(const SizedBox(width: VoxaSpacing.md));
      buttons.add(
        Expanded(
          child: FilledButton(
            onPressed: onStop,
            style: FilledButton.styleFrom(
              backgroundColor: VoxaColors.coral.withValues(alpha: 0.18),
              foregroundColor: VoxaColors.coral,
            ),
            child: Text(l10n.practiceFinish),
          ),
        ),
      );
    } else if (state == PracticeSessionStatus.paused) {
      buttons.add(
        Expanded(
          child: FilledButton(
            onPressed: onResume,
            child: Text(l10n.practiceResume),
          ),
        ),
      );
      buttons.add(const SizedBox(width: VoxaSpacing.md));
      buttons.add(
        Expanded(
          child: OutlinedButton(
            onPressed: onStop,
            child: Text(l10n.practiceFinish),
          ),
        ),
      );
    }

    return SizedBox(
      height: _PracticeLayoutSpec.fromSize(
        MediaQuery.sizeOf(context),
      ).controlsHeight,
      child: Row(children: buttons),
    );
  }
}

class _PracticeLayoutSpec {
  const _PracticeLayoutSpec({
    required this.headerHeight,
    required this.controlsHeight,
    required this.statCardHeight,
    required this.feedbackCardHeight,
    required this.chartMinHeight,
    required this.chartHeightFactor,
    required this.feedbackViewportMinHeight,
    required this.horizontalPadding,
    required this.topPadding,
    required this.bottomPadding,
    required this.sectionGap,
    required this.panelPadding,
    required this.chartBottomPadding,
    required this.statValueGap,
  });

  final double headerHeight;
  final double controlsHeight;
  final double statCardHeight;
  final double feedbackCardHeight;
  final double chartMinHeight;
  final double chartHeightFactor;
  final double feedbackViewportMinHeight;
  final double horizontalPadding;
  final double topPadding;
  final double bottomPadding;
  final double sectionGap;
  final double panelPadding;
  final double chartBottomPadding;
  final double statValueGap;

  factory _PracticeLayoutSpec.fromSize(Size size) {
    final shortestSide = math.min(size.width, size.height);
    final isTablet = shortestSide >= 600;
    final isSmallPhone = size.height < 760 || size.width < 380;

    if (isTablet) {
      return const _PracticeLayoutSpec(
        headerHeight: 124,
        controlsHeight: 64,
        statCardHeight: 92,
        feedbackCardHeight: 126,
        chartMinHeight: 320,
        chartHeightFactor: 0.56,
        feedbackViewportMinHeight: 150,
        horizontalPadding: 24,
        topPadding: 20,
        bottomPadding: 20,
        sectionGap: 16,
        panelPadding: 16,
        chartBottomPadding: 12,
        statValueGap: 8,
      );
    }

    if (isSmallPhone) {
      return const _PracticeLayoutSpec(
        headerHeight: 112,
        controlsHeight: 50,
        statCardHeight: 82,
        feedbackCardHeight: 114,
        chartMinHeight: 300,
        chartHeightFactor: 0.58,
        feedbackViewportMinHeight: 126,
        horizontalPadding: 14,
        topPadding: 14,
        bottomPadding: 14,
        sectionGap: 8,
        panelPadding: 10,
        chartBottomPadding: 8,
        statValueGap: 4,
      );
    }

    return const _PracticeLayoutSpec(
      headerHeight: 118,
      controlsHeight: 56,
      statCardHeight: 82,
      feedbackCardHeight: 120,
      chartMinHeight: 320,
      chartHeightFactor: 0.58,
      feedbackViewportMinHeight: 138,
      horizontalPadding: 16,
      topPadding: 16,
      bottomPadding: 16,
      sectionGap: 12,
      panelPadding: 12,
      chartBottomPadding: 10,
      statValueGap: 6,
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
        ),
      ),
    );
  }
}
