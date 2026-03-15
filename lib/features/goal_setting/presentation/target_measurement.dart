import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voxa/l10n/app_localizations.dart';

import '../../../app/app_providers.dart';
import '../../../core/audio/domain/audio_contracts.dart';
import '../../../core/theme/voxa_tokens.dart';
import '../../goal_setting/domain/voice_target.dart';
import '../../practice/domain/pitch_training_mode.dart';
import '../../practice/domain/pitch_sample.dart';
import '../../settings/application/app_settings_controller.dart';

Future<double?> measureTargetFromVoice(
  BuildContext context,
  WidgetRef ref,
) async {
  final l10n = AppLocalizations.of(context)!;
  final permissionService = ref.read(audioPermissionServiceProvider);
  var permissionStatus = await permissionService.checkStatus();
  if (permissionStatus != AudioPermissionStatus.granted) {
    permissionStatus = await permissionService.requestPermission();
  }
  if (permissionStatus != AudioPermissionStatus.granted) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.practicePermissionBody)));
    }
    return null;
  }

  if (!context.mounted) {
    return null;
  }

  return showModalBottomSheet<double>(
    context: context,
    isDismissible: false,
    enableDrag: false,
    builder: (context) => _MeasureTargetSheet(ref: ref),
  );
}

class _MeasureTargetSheet extends ConsumerStatefulWidget {
  const _MeasureTargetSheet({required this.ref});

  final WidgetRef ref;

  @override
  ConsumerState<_MeasureTargetSheet> createState() =>
      _MeasureTargetSheetState();
}

class _MeasureTargetSheetState extends ConsumerState<_MeasureTargetSheet> {
  static const _secondsToMeasure = 4;

  StreamSubscription<PitchSample>? _subscription;
  Timer? _timer;
  final List<double> _voicedSamples = <double>[];
  int _remainingSeconds = _secondsToMeasure;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    unawaited(_startMeasurement());
  }

  @override
  void dispose() {
    _timer?.cancel();
    unawaited(_subscription?.cancel());
    unawaited(widget.ref.read(livePitchEngineProvider).stop());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          VoxaSpacing.lg,
          VoxaSpacing.lg,
          VoxaSpacing.lg,
          VoxaSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Measure from your voice',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: VoxaSpacing.sm),
            Text(
              _error ??
                  (_isLoading
                      ? 'Speak naturally for a few seconds. Voxa will suggest a starting target.'
                      : 'Suggested target ready.'),
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
              ),
            ),
            const SizedBox(height: VoxaSpacing.lg),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(VoxaSpacing.xl),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.56),
                borderRadius: BorderRadius.circular(VoxaRadius.xl),
              ),
              child: Column(
                children: [
                  Text(
                    _isLoading ? '$_remainingSeconds s' : 'Done',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: VoxaColors.aqua,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: VoxaSpacing.sm),
                  LinearProgressIndicator(
                    value:
                        (_secondsToMeasure - _remainingSeconds) /
                        _secondsToMeasure,
                    minHeight: 8,
                    backgroundColor: theme.colorScheme.onSurface.withValues(
                      alpha: 0.10,
                    ),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      VoxaColors.aqua,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: VoxaSpacing.lg),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.commonClose),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _startMeasurement() async {
    final settings = ref.read(appSettingsControllerProvider);
    final livePitchEngine = ref.read(livePitchEngineProvider);
    final now = DateTime.now();

    try {
      final stream = await livePitchEngine.start(
        target: VoiceTarget(
          id: 'measurement-target',
          targetHz: presetTargetSuggestions[TargetPreset.androgynous]!,
          suggestionPreset: TargetPreset.custom,
          createdAt: now,
          updatedAt: now,
        ),
        toleranceHz: settings.targetToleranceHz,
        trainingMode: PitchTrainingMode.speech,
        smoothingWindowMs: settings.smoothingWindowMs,
      );

      _subscription = stream.listen((sample) {
        final frequencyHz = sample.frequencyHz;
        if (sample.isVoiced && frequencyHz != null) {
          _voicedSamples.add(frequencyHz);
        }
      });

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
        if (!mounted) {
          return;
        }
        if (_remainingSeconds <= 1) {
          timer.cancel();
          await _finishMeasurement();
          return;
        }
        setState(() => _remainingSeconds -= 1);
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
        _error = 'Microphone measurement is unavailable right now.';
      });
    }
  }

  Future<void> _finishMeasurement() async {
    await _subscription?.cancel();
    _subscription = null;
    await ref.read(livePitchEngineProvider).stop();

    if (!mounted) {
      return;
    }

    if (_voicedSamples.length < 8) {
      setState(() {
        _isLoading = false;
        _error =
            'Voxa could not capture a stable sample. Try again in a quieter space.';
      });
      return;
    }

    final average =
        _voicedSamples.reduce((a, b) => a + b) / _voicedSamples.length;
    Navigator.of(context).pop(average);
  }
}
