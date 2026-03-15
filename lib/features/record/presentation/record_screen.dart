import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:voxa/l10n/app_localizations.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/theme/voxa_tokens.dart';
import '../../../core/widgets/voxa_page.dart';
import '../../../core/widgets/voxa_panel.dart';
import '../../practice/application/live_practice_controller.dart';
import '../../practice/domain/pitch_sample.dart';
import '../../practice/domain/pitch_training_mode.dart';
import '../../settings/application/app_settings_controller.dart';
import '../../settings/domain/app_settings.dart';
import '../application/record_session_controller.dart';
import '../domain/practice_text.dart';

class RecordScreen extends ConsumerStatefulWidget {
  const RecordScreen({super.key});

  @override
  ConsumerState<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends ConsumerState<RecordScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  StreamSubscription<PlayerState>? _playerSubscription;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _playerSubscription = _audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying =
          playerState.playing &&
          playerState.processingState != ProcessingState.completed;
      if (mounted && _isPlaying != isPlaying) {
        setState(() => _isPlaying = isPlaying);
      }
    });
  }

  @override
  void dispose() {
    unawaited(_playerSubscription?.cancel());
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final controller = ref.read(recordSessionControllerProvider.notifier);
    final state = ref.watch(recordSessionControllerProvider);
    final practiceTexts = ref.watch(localizedPracticeTextsProvider);
    final settings = ref.watch(appSettingsControllerProvider);
    final selectedText = _selectedText(
      practiceTexts,
      state.selectedPracticeTextId,
    );
    final currentSample = state.currentSample;
    final category =
        currentSample?.stateCategory ?? PitchStateCategory.unvoiced;
    final quality = currentSample?.quality ?? PitchQuality.silent;
    final accent = switch (category) {
      PitchStateCategory.low => VoxaColors.coral,
      PitchStateCategory.atTarget => VoxaColors.pitchInRange,
      PitchStateCategory.high => VoxaColors.pitchHigh,
      PitchStateCategory.unvoiced => VoxaColors.iris,
    };
    final qualityLabel = switch (quality) {
      PitchQuality.strong => l10n.practiceQualityStrong,
      PitchQuality.weak => l10n.practiceQualityWeak,
      PitchQuality.unstable => l10n.practiceQualityUnstable,
      PitchQuality.silent => l10n.practiceQualitySilent,
    };
    final isSpeechMode =
        settings.lastPitchTrainingMode == PitchTrainingMode.speech;

    return VoxaPage(
      eyebrow: l10n.recordEyebrow,
      title: l10n.recordPageTitle,
      subtitle: l10n.recordPageSubtitle,
      children: [
        if (state.status == PracticeSessionStatus.permissionDenied)
          VoxaPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.practicePermissionTitle,
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: VoxaSpacing.sm),
                Text(l10n.practicePermissionBody),
                const SizedBox(height: VoxaSpacing.lg),
                FilledButton(
                  onPressed: controller.start,
                  child: Text(l10n.practiceGrantPermission),
                ),
              ],
            ),
          )
        else if (state.status == PracticeSessionStatus.reviewReady &&
            state.review != null)
          _buildReview(context, controller, state)
        else if (state.status == PracticeSessionStatus.running ||
            state.status == PracticeSessionStatus.paused)
          _buildActive(
            context,
            controller,
            state,
            currentSample,
            accent,
            qualityLabel,
            selectedText,
            isSpeechMode,
          )
        else
          _buildSetup(
            context,
            controller,
            state,
            practiceTexts,
            selectedText,
            settings,
            isSpeechMode,
          ),
        if (state.status == PracticeSessionStatus.error &&
            state.message != null)
          Text(
            state.message!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
      ],
    );
  }

  Widget _buildSetup(
    BuildContext context,
    RecordSessionController controller,
    RecordSessionState state,
    List<PracticeText> practiceTexts,
    PracticeText? selectedText,
    AppSettings settings,
    bool isSpeechMode,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      children: [
        VoxaPanel(
          padding: const EdgeInsets.all(VoxaSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.practiceModeLabel, style: theme.textTheme.titleLarge),
              const SizedBox(height: VoxaSpacing.md),
              SegmentedButton<PitchTrainingMode>(
                segments: [
                  ButtonSegment<PitchTrainingMode>(
                    value: PitchTrainingMode.sound,
                    label: Text(l10n.practiceModeSound),
                  ),
                  ButtonSegment<PitchTrainingMode>(
                    value: PitchTrainingMode.speech,
                    label: Text(l10n.practiceModeSpeech),
                  ),
                ],
                selected: {settings.lastPitchTrainingMode},
                onSelectionChanged: (selection) {
                  final mode = selection.first;
                  ref
                      .read(appSettingsControllerProvider.notifier)
                      .setLastPitchTrainingMode(mode);
                  if (mode == PitchTrainingMode.sound) {
                    controller.selectPracticeText(null);
                  }
                },
              ),
              const SizedBox(height: VoxaSpacing.lg),
              Text(
                '${l10n.practiceTargetLabel}: ${state.targetLabel ?? '--'}',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: VoxaColors.aqua,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: VoxaSpacing.lg),
              if (isSpeechMode) ...[
                Text(
                  l10n.recordPracticeTextTitle,
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: VoxaSpacing.sm),
                OutlinedButton.icon(
                  onPressed: () => _pickPracticeText(context, practiceTexts),
                  icon: const Icon(Icons.menu_book_rounded),
                  label: Text(selectedText?.title ?? l10n.recordNoText),
                ),
                if (selectedText != null) ...[
                  const SizedBox(height: VoxaSpacing.sm),
                  Text(
                    selectedText.body,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(
                        alpha: 0.70,
                      ),
                    ),
                  ),
                ],
              ] else
                Text(
                  l10n.recordSoundModeHint,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
                  ),
                ),
              const SizedBox(height: VoxaSpacing.md),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.recordLiveFeedback),
                value: settings.showLiveFeedbackDuringRecording,
                onChanged: (value) => ref
                    .read(appSettingsControllerProvider.notifier)
                    .setLiveFeedbackDuringRecording(value),
              ),
              const SizedBox(height: VoxaSpacing.md),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: controller.start,
                  child: Text(l10n.recordStart),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActive(
    BuildContext context,
    RecordSessionController controller,
    RecordSessionState state,
    PitchSample? currentSample,
    Color accent,
    String qualityLabel,
    PracticeText? selectedText,
    bool isSpeechMode,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Column(
      children: [
        VoxaPanel(
          padding: const EdgeInsets.all(VoxaSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.status == PracticeSessionStatus.paused
                    ? l10n.practicePaused
                    : l10n.recordRecordingInProgress,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: VoxaSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: _RecordStat(
                      label: l10n.recordPitchLabel,
                      value: currentSample?.frequencyHz == null
                          ? '--'
                          : l10n.commonHz(
                              currentSample!.frequencyHz!.round().toString(),
                            ),
                      accent: accent,
                    ),
                  ),
                  const SizedBox(width: VoxaSpacing.md),
                  Expanded(
                    child: _RecordStat(
                      label: l10n.recordStatusLabel,
                      value: qualityLabel,
                      accent: accent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: VoxaSpacing.md),
              Text(
                isSpeechMode
                    ? (selectedText?.title ?? l10n.recordNoText)
                    : l10n.practiceModeSound,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.66),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: VoxaSpacing.md),
        Row(
          children: [
            Expanded(
              child: FilledButton.tonal(
                onPressed: state.status == PracticeSessionStatus.running
                    ? controller.pause
                    : controller.resume,
                child: Text(
                  state.status == PracticeSessionStatus.running
                      ? l10n.practicePause
                      : l10n.practiceResume,
                ),
              ),
            ),
            const SizedBox(width: VoxaSpacing.md),
            Expanded(
              child: FilledButton(
                onPressed: controller.stop,
                child: Text(l10n.recordStop),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReview(
    BuildContext context,
    RecordSessionController controller,
    RecordSessionState state,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final review = state.review!;
    final theme = Theme.of(context);

    return Column(
      children: [
        VoxaPanel(
          padding: const EdgeInsets.all(VoxaSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.recordReviewTitle, style: theme.textTheme.titleLarge),
              const SizedBox(height: VoxaSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: _RecordStat(
                      label: l10n.recordAvgLabel,
                      value: l10n.commonHz(
                        (review.analysis.averagePitchHz?.round() ?? '--')
                            .toString(),
                      ),
                      accent: VoxaColors.aqua,
                    ),
                  ),
                  const SizedBox(width: VoxaSpacing.md),
                  Expanded(
                    child: _RecordStat(
                      label: l10n.practiceStatInRange,
                      value: review.analysis.totalTrackedTimeMs == 0
                          ? l10n.commonPercent('0')
                          : l10n.commonPercent(
                              ((review.analysis.timeAtTargetMs /
                                          review.analysis.totalTrackedTimeMs) *
                                      100)
                                  .round()
                                  .toString(),
                            ),
                      accent: VoxaColors.pitchInRange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: VoxaSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: _RecordStat(
                      label: l10n.commonMin,
                      value: l10n.commonHz(
                        (review.analysis.minPitchHz?.round() ?? '--')
                            .toString(),
                      ),
                      accent: Colors.white,
                    ),
                  ),
                  const SizedBox(width: VoxaSpacing.md),
                  Expanded(
                    child: _RecordStat(
                      label: l10n.commonMax,
                      value: l10n.commonHz(
                        (review.analysis.maxPitchHz?.round() ?? '--')
                            .toString(),
                      ),
                      accent: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: VoxaSpacing.md),
              OutlinedButton.icon(
                onPressed: () => _togglePlayback(review.capture.filePath),
                icon: Icon(
                  _isPlaying
                      ? Icons.stop_circle_outlined
                      : Icons.play_circle_outline,
                ),
                label: Text(
                  _isPlaying
                      ? l10n.recordStopPlayback
                      : l10n.recordPlayRecording,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: VoxaSpacing.md),
        Row(
          children: [
            Expanded(
              child: FilledButton(
                onPressed: () async {
                  final sessionId = await controller.saveReview();
                  if (!context.mounted || sessionId == null) {
                    return;
                  }
                  SessionDetailRoute(sessionId).go(context);
                },
                child: Text(l10n.commonSave),
              ),
            ),
            const SizedBox(width: VoxaSpacing.md),
            Expanded(
              child: OutlinedButton(
                onPressed: controller.restartReview,
                child: Text(l10n.commonRepeat),
              ),
            ),
          ],
        ),
        const SizedBox(height: VoxaSpacing.sm),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: controller.discardReview,
            child: Text(l10n.commonDiscard),
          ),
        ),
      ],
    );
  }

  Future<void> _pickPracticeText(
    BuildContext context,
    List<PracticeText> practiceTexts,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = ref.read(recordSessionControllerProvider.notifier);
    final selectedId = await showModalBottomSheet<String?>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(VoxaSpacing.lg),
            children: [
              ListTile(
                title: Text(l10n.recordNoText),
                onTap: () => Navigator.of(context).pop(null),
              ),
              for (final practiceText in practiceTexts)
                ListTile(
                  title: Text(practiceText.title),
                  subtitle: Text(
                    practiceText.body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () => Navigator.of(context).pop(practiceText.id),
                ),
            ],
          ),
        );
      },
    );
    controller.selectPracticeText(selectedId);
  }

  PracticeText? _selectedText(
    List<PracticeText> practiceTexts,
    String? selectedId,
  ) {
    if (selectedId == null) {
      return null;
    }
    for (final text in practiceTexts) {
      if (text.id == selectedId) {
        return text;
      }
    }
    return null;
  }

  Future<void> _togglePlayback(String filePath) async {
    if (_isPlaying) {
      await _audioPlayer.stop();
      return;
    }
    await _audioPlayer.setFilePath(filePath);
    await _audioPlayer.play();
  }
}

class _RecordStat extends StatelessWidget {
  const _RecordStat({
    required this.label,
    required this.value,
    required this.accent,
  });

  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return VoxaPanel(
      padding: const EdgeInsets.all(VoxaSpacing.lg),
      child: Column(
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
              color: accent,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
