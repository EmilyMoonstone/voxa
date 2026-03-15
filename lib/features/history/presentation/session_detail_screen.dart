import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:voxa/l10n/app_localizations.dart';

import '../../../core/theme/voxa_tokens.dart';
import '../../../core/widgets/session_chart.dart';
import '../../../core/widgets/voxa_panel.dart';
import '../../practice/domain/pitch_training_mode.dart';
import '../../practice/domain/resonance_feedback.dart';
import '../application/session_providers.dart';

class SessionDetailScreen extends ConsumerStatefulWidget {
  const SessionDetailScreen({required this.sessionId, super.key});

  final String sessionId;

  @override
  ConsumerState<SessionDetailScreen> createState() =>
      _SessionDetailScreenState();
}

class _SessionDetailScreenState extends ConsumerState<SessionDetailScreen> {
  final AudioPlayer _player = AudioPlayer();
  StreamSubscription<PlayerState>? _playerSubscription;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _playerSubscription = _player.playerStateStream.listen((playerState) {
      if (!mounted) {
        return;
      }
      final isPlaying =
          playerState.playing &&
          playerState.processingState != ProcessingState.completed;
      if (_isPlaying != isPlaying) {
        setState(() {
          _isPlaying = isPlaying;
        });
      }
    });
  }

  @override
  void dispose() {
    unawaited(_playerSubscription?.cancel());
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final sessionAsync = ref.watch(sessionDetailProvider(widget.sessionId));

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: theme.colorScheme.brightness == Brightness.dark
              ? voxaAmbientBackground
              : voxaAmbientBackgroundLight,
        ),
        child: SafeArea(
          child: sessionAsync.when(
            data: (session) {
              if (session == null) {
                return Center(child: Text(l10n.sessionDetailNotFound));
              }

              return ListView(
                padding: const EdgeInsets.fromLTRB(
                  VoxaSpacing.lg,
                  VoxaSpacing.xl,
                  VoxaSpacing.lg,
                  VoxaSpacing.xxl,
                ),
                children: [
                  Row(
                    children: [
                      IconButton.filledTonal(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.arrow_back_rounded),
                      ),
                      const SizedBox(width: VoxaSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.sessionDetailTitle,
                              style: theme.textTheme.headlineMedium,
                            ),
                            const SizedBox(height: VoxaSpacing.xs),
                            Text(
                              MaterialLocalizations.of(
                                context,
                              ).formatFullDate(session.startedAt),
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.68,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: VoxaSpacing.xl),
                  VoxaPanel(
                    padding: const EdgeInsets.all(VoxaSpacing.xl),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.commonHz(
                            (session.averagePitchHz?.round() ?? '--')
                                .toString(),
                          ),
                          style: theme.textTheme.headlineLarge?.copyWith(
                            fontSize: 42,
                            color: VoxaColors.aqua,
                          ),
                        ),
                        const SizedBox(height: VoxaSpacing.sm),
                        Text(
                          l10n.commonRangeHz(
                            (session.minPitchHz?.round() ?? '--').toString(),
                            (session.maxPitchHz?.round() ?? '--').toString(),
                          ),
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: VoxaSpacing.xs),
                        Text(
                          l10n.sessionDetailAtTargetPercent(
                            session.timeAtTargetPercent.round(),
                          ),
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.70,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: VoxaSpacing.lg),
                  Row(
                    children: [
                      Expanded(
                        child: VoxaPanel(
                          padding: const EdgeInsets.all(VoxaSpacing.lg),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.sessionDetailTarget,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurface.withValues(
                                    alpha: 0.58,
                                  ),
                                ),
                              ),
                              const SizedBox(height: VoxaSpacing.sm),
                              Text(
                                session.targetLabel(),
                                style: theme.textTheme.titleLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: VoxaSpacing.md),
                      Expanded(
                        child: VoxaPanel(
                          padding: const EdgeInsets.all(VoxaSpacing.lg),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.practiceTrackedTime,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurface.withValues(
                                    alpha: 0.58,
                                  ),
                                ),
                              ),
                              const SizedBox(height: VoxaSpacing.sm),
                              Text(
                                l10n.commonSeconds(
                                  (session.totalTrackedTimeMs / 1000)
                                      .toStringAsFixed(1),
                                ),
                                style: theme.textTheme.titleLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: VoxaSpacing.lg),
                  VoxaPanel(
                    padding: const EdgeInsets.all(VoxaSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.practiceModeLabel,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.58,
                            ),
                          ),
                        ),
                        const SizedBox(height: VoxaSpacing.sm),
                        Text(
                          session.trackingMode == PitchTrainingMode.sound
                              ? l10n.practiceModeSound
                              : l10n.practiceModeSpeech,
                          style: theme.textTheme.titleLarge,
                        ),
                      ],
                    ),
                  ),
                  if (session.resonanceState != null) ...[
                    const SizedBox(height: VoxaSpacing.lg),
                    VoxaPanel(
                      padding: const EdgeInsets.all(VoxaSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.sessionDetailResonance,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.58,
                              ),
                            ),
                          ),
                          const SizedBox(height: VoxaSpacing.sm),
                          Text(
                            _resonanceLabel(l10n, session.resonanceState!),
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: _resonanceColor(session.resonanceState!),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          if (session.resonanceBalancedPercent != null) ...[
                            const SizedBox(height: VoxaSpacing.xs),
                            Text(
                              '${l10n.sessionDetailResonanceBalanced}: ${session.resonanceBalancedPercent!.round()}%',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.72,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: VoxaSpacing.lg),
                  VoxaPanel(
                    padding: const EdgeInsets.all(VoxaSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.sessionDetailPitchContour,
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: VoxaSpacing.md),
                        SessionChart(
                          points: session.chartPoints,
                          target: session.targetSnapshot,
                          toleranceHz: session.targetToleranceHz,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: VoxaSpacing.lg),
                  Wrap(
                    spacing: VoxaSpacing.sm,
                    runSpacing: VoxaSpacing.sm,
                    children: [
                      if (session.audioFilePath != null)
                        FilledButton(
                          onPressed: () =>
                              _togglePlayback(session.audioFilePath!),
                          child: Text(
                            _isPlaying
                                ? l10n.sessionDetailPlaybackStop
                                : l10n.sessionDetailPlayback,
                          ),
                        ),
                      FilledButton.tonal(
                        onPressed: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(l10n.historyDeleteConfirmTitle),
                                content: Text(l10n.historyDeleteConfirmBody),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: Text(l10n.historyDeleteCancel),
                                  ),
                                  FilledButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: Text(
                                      l10n.historyDeleteConfirmAction,
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                          if (confirmed != true) {
                            return;
                          }

                          await ref
                              .read(deleteSessionUseCaseProvider)
                              .execute(session);
                          if (context.mounted) {
                            context.pop();
                          }
                        },
                        child: Text(l10n.historyDelete),
                      ),
                    ],
                  ),
                ],
              );
            },
            error: (error, stackTrace) => Center(child: Text(error.toString())),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }

  Future<void> _togglePlayback(String filePath) async {
    if (_isPlaying) {
      await _player.stop();
      return;
    }
    await _player.setFilePath(filePath);
    await _player.play();
  }

  String _resonanceLabel(AppLocalizations l10n, ResonanceState state) {
    return switch (state) {
      ResonanceState.insufficientSignal => l10n.resonanceStateInsufficient,
      ResonanceState.dark => l10n.resonanceStateDark,
      ResonanceState.balanced => l10n.resonanceStateBalanced,
      ResonanceState.bright => l10n.resonanceStateBright,
      ResonanceState.unstable => l10n.resonanceStateUnstable,
    };
  }

  Color _resonanceColor(ResonanceState state) {
    return switch (state) {
      ResonanceState.insufficientSignal => VoxaColors.iris,
      ResonanceState.dark => VoxaColors.coral,
      ResonanceState.balanced => VoxaColors.pitchInRange,
      ResonanceState.bright => VoxaColors.pitchHigh,
      ResonanceState.unstable => VoxaColors.warning,
    };
  }
}
