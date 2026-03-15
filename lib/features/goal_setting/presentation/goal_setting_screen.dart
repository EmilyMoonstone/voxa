import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voxa/l10n/app_localizations.dart';

import '../../../app/app_providers.dart';
import '../../../core/audio/domain/audio_contracts.dart';
import '../../../core/theme/voxa_tokens.dart';
import '../../../core/widgets/voxa_page.dart';
import '../../../core/widgets/voxa_panel.dart';
import '../../settings/application/app_settings_controller.dart';
import '../application/voice_target_use_cases.dart';
import '../application/voice_target_validation.dart';
import '../domain/voice_target.dart';
import 'target_measurement.dart';

class GoalSettingScreen extends ConsumerStatefulWidget {
  const GoalSettingScreen({super.key});

  @override
  ConsumerState<GoalSettingScreen> createState() => _GoalSettingScreenState();
}

class _GoalSettingScreenState extends ConsumerState<GoalSettingScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _targetController;
  TargetPreset _preset = TargetPreset.androgynous;
  double? _targetVolumeDbfs;
  bool _initialized = false;
  bool _isImportingFile = false;
  bool _isCalibratingVolume = false;
  bool _isMeasuring = false;

  @override
  void initState() {
    super.initState();
    _targetController = TextEditingController();
  }

  @override
  void dispose() {
    _targetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final target = ref.watch(currentTargetProvider).asData?.value;
    final settings = ref.watch(appSettingsControllerProvider);

    if (!_initialized) {
      _preset = target?.suggestionPreset ?? TargetPreset.androgynous;
      _targetVolumeDbfs = target?.targetVolumeDbfs;
      _targetController.text =
          (target?.targetHz ??
                  presetTargetSuggestions[TargetPreset.androgynous]!)
              .round()
              .toString();
      _initialized = true;
    }

    final targetHz =
        double.tryParse(_targetController.text) ??
        target?.targetHz ??
        presetTargetSuggestions[_preset] ??
        presetTargetSuggestions[TargetPreset.androgynous]!;

    return VoxaPage(
      eyebrow: l10n.goalEyebrow,
      title: l10n.goalPageTitle,
      subtitle: l10n.goalPageSubtitle,
      children: [
        VoxaPanel(
          padding: const EdgeInsets.all(VoxaSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.homeCurrentTarget, style: theme.textTheme.titleLarge),
              const SizedBox(height: VoxaSpacing.sm),
              Text(
                target == null
                    ? l10n.homeNoTarget
                    : target.formatWithTolerance(settings.targetToleranceHz),
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: VoxaColors.aqua,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: VoxaSpacing.lg),
              _TargetBand(
                targetHz: targetHz,
                toleranceHz: settings.targetToleranceHz,
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
                l10n.goalChoosePresetTitle,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: VoxaSpacing.md),
              Wrap(
                spacing: VoxaSpacing.sm,
                runSpacing: VoxaSpacing.sm,
                children: [
                  _presetChip(l10n.goalPresetFeminine, TargetPreset.feminine),
                  _presetChip(
                    l10n.goalPresetAndrogynous,
                    TargetPreset.androgynous,
                  ),
                  _presetChip(l10n.goalPresetMasculine, TargetPreset.masculine),
                  _presetChip(l10n.goalPresetCustom, TargetPreset.custom),
                ],
              ),
            ],
          ),
        ),
        VoxaPanel(
          padding: const EdgeInsets.all(VoxaSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.goalMeasureTitle, style: theme.textTheme.titleLarge),
              const SizedBox(height: VoxaSpacing.xs),
              Text(
                l10n.goalMeasureBody,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
                ),
              ),
              const SizedBox(height: VoxaSpacing.md),
              FilledButton.tonalIcon(
                onPressed: _isMeasuring ? null : _measureFromVoice,
                icon: _isMeasuring
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.graphic_eq_rounded),
                label: Text(l10n.goalMeasureAction),
              ),
            ],
          ),
        ),
        VoxaPanel(
          padding: EdgeInsets.zero,
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(
              horizontal: VoxaSpacing.lg,
              vertical: VoxaSpacing.xs,
            ),
            childrenPadding: const EdgeInsets.fromLTRB(
              VoxaSpacing.lg,
              0,
              VoxaSpacing.lg,
              VoxaSpacing.lg,
            ),
            title: Text(
              l10n.goalMoreOptionsTitle,
              style: theme.textTheme.titleLarge,
            ),
            subtitle: Text(
              l10n.goalMoreOptionsBody,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.66),
              ),
            ),
            children: [
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _targetController,
                  keyboardType: TextInputType.number,
                  onTap: () => setState(() => _preset = TargetPreset.custom),
                  onChanged: (_) =>
                      setState(() => _preset = TargetPreset.custom),
                  decoration: InputDecoration(
                    labelText: l10n.goalTargetLabel,
                    hintText: '185',
                    suffixText: l10n.commonUnitHz,
                  ),
                  validator: (value) {
                    final error = validateVoiceTargetHz(
                      targetHz: double.tryParse(value ?? ''),
                    );
                    if (error case VoiceTargetValidationError.missingTarget) {
                      return l10n.goalValidationTarget;
                    }
                    if (error case VoiceTargetValidationError.outOfBounds) {
                      return l10n.goalValidationBounds;
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: VoxaSpacing.md),
              Text(l10n.goalVolumeTitle, style: theme.textTheme.titleMedium),
              const SizedBox(height: VoxaSpacing.xs),
              Text(
                _targetVolumeDbfs == null
                    ? l10n.goalVolumeNotSet
                    : _formatVolumeTarget(
                        _targetVolumeDbfs!,
                        settings.targetVolumeToleranceDb,
                      ),
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: _targetVolumeDbfs == null
                      ? theme.colorScheme.onSurface.withValues(alpha: 0.62)
                      : VoxaColors.aqua,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: VoxaSpacing.sm),
              Wrap(
                spacing: VoxaSpacing.sm,
                runSpacing: VoxaSpacing.sm,
                children: [
                  OutlinedButton.icon(
                    onPressed: _isCalibratingVolume
                        ? null
                        : _captureTargetVolumeFromMicrophone,
                    icon: _isCalibratingVolume
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.mic_external_on_outlined),
                    label: Text(l10n.goalVolumeCalibrateAction),
                  ),
                  OutlinedButton.icon(
                    onPressed: _isImportingFile
                        ? null
                        : _importTargetFromAudioFile,
                    icon: _isImportingFile
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.audio_file_outlined),
                    label: Text(l10n.goalImportFileAction),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: FilledButton(onPressed: _save, child: Text(l10n.goalSave)),
        ),
      ],
    );
  }

  Future<void> _measureFromVoice() async {
    setState(() => _isMeasuring = true);
    final suggestedTarget = await measureTargetFromVoice(context, ref);
    if (!mounted) {
      return;
    }
    setState(() {
      _isMeasuring = false;
      if (suggestedTarget != null) {
        _preset = TargetPreset.custom;
        _targetController.text = suggestedTarget.round().toString();
      }
    });
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    if (_preset == TargetPreset.custom && !_formKey.currentState!.validate()) {
      return;
    }
    final now = DateTime.now().toUtc();
    await ref
        .read(saveVoiceTargetUseCaseProvider)
        .execute(
          VoiceTarget(
            id: 'current-target',
            targetHz: _preset == TargetPreset.custom
                ? double.parse(_targetController.text)
                : presetTargetSuggestions[_preset]!,
            targetVolumeDbfs: _targetVolumeDbfs,
            suggestionPreset: _preset,
            createdAt:
                ref.watch(currentTargetProvider).asData?.value?.createdAt ??
                now,
            updatedAt: now,
          ),
        );
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.goalSaved)));
  }

  Future<void> _importTargetFromAudioFile() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isImportingFile = true);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: false,
        withData: false,
      );
      final filePath = (result == null || result.files.isEmpty)
          ? null
          : result.files.first.path;
      if (filePath == null) {
        return;
      }

      final suggestion = await ref
          .read(importedPitchAnalysisServiceProvider)
          .analyzeAudioFile(
            filePath: filePath,
            trainingMode: ref
                .read(appSettingsControllerProvider)
                .lastPitchTrainingMode,
            smoothingWindowMs: ref
                .read(appSettingsControllerProvider)
                .smoothingWindowMs,
          );
      setState(() {
        _preset = TargetPreset.custom;
        _targetController.text = suggestion.targetHz.round().toString();
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.goalImportFileSuccess(suggestion.targetHz.round()),
            ),
          ),
        );
      }
    } on UnsupportedError {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.goalImportFileUnsupported)));
      }
    } on FormatException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.message)));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.goalImportFileError)));
      }
    } finally {
      if (mounted) {
        setState(() => _isImportingFile = false);
      }
    }
  }

  Future<void> _captureTargetVolumeFromMicrophone() async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _isCalibratingVolume = true);
    try {
      final permissionService = ref.read(audioPermissionServiceProvider);
      var permissionStatus = await permissionService.checkStatus();
      if (permissionStatus != AudioPermissionStatus.granted) {
        permissionStatus = await permissionService.requestPermission();
      }
      if (permissionStatus != AudioPermissionStatus.granted) {
        if (mounted) {
          messenger.showSnackBar(
            SnackBar(content: Text(l10n.practicePermissionBody)),
          );
        }
        return;
      }

      messenger.showSnackBar(
        SnackBar(content: Text(l10n.goalVolumeCalibratingHint)),
      );
      final targetVolumeDbfs = await ref
          .read(targetVolumeCalibrationServiceProvider)
          .captureTargetVolumeDbfs(
            trainingMode: ref
                .read(appSettingsControllerProvider)
                .lastPitchTrainingMode,
            smoothingWindowMs: ref
                .read(appSettingsControllerProvider)
                .smoothingWindowMs,
          );
      setState(() {
        _targetVolumeDbfs = targetVolumeDbfs;
      });
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(l10n.goalVolumeCalibrated(targetVolumeDbfs.round())),
          ),
        );
      }
    } on FormatException catch (error) {
      if (mounted) {
        messenger.showSnackBar(SnackBar(content: Text(error.message)));
      }
    } catch (_) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.goalVolumeCalibrateError)),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isCalibratingVolume = false);
      }
    }
  }

  String _formatVolumeTarget(double value, int toleranceDb) {
    final l10n = AppLocalizations.of(context)!;
    return l10n.commonDbfsTolerance(
      value.round().toString(),
      toleranceDb.toString(),
    );
  }

  Widget _presetChip(String label, TargetPreset preset) {
    return ChoiceChip(
      label: Text(label),
      selected: _preset == preset,
      onSelected: (_) {
        setState(() {
          _preset = preset;
          if (preset != TargetPreset.custom) {
            _targetController.text = presetTargetSuggestions[preset]!
                .round()
                .toString();
          }
        });
      },
    );
  }
}

class _TargetBand extends StatelessWidget {
  const _TargetBand({required this.targetHz, required this.toleranceHz});

  final double targetHz;
  final int toleranceHz;

  static const _minChartHz = 70.0;
  static const _maxChartHz = 350.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 96,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          double positionFor(double hz) =>
              ((hz - _minChartHz) / (_maxChartHz - _minChartHz)).clamp(
                0.0,
                1.0,
              ) *
              width;

          final targetStart = positionFor(targetHz - toleranceHz);
          final targetEnd = positionFor(targetHz + toleranceHz);
          final masculine = presetReferenceBands[TargetPreset.masculine]!;
          final feminine = presetReferenceBands[TargetPreset.feminine]!;

          return Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 1,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.12),
                ),
              ),
              _ReferenceBand(
                left: positionFor(masculine.minHz),
                right: positionFor(masculine.maxHz),
                color: VoxaColors.coral,
              ),
              _ReferenceBand(
                left: positionFor(feminine.minHz),
                right: positionFor(feminine.maxHz),
                color: VoxaColors.pitchHigh,
              ),
              Positioned(
                left: targetStart,
                width: (targetEnd - targetStart).clamp(28, width),
                top: 18,
                bottom: 18,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        VoxaColors.pitchInRange.withValues(alpha: 0.08),
                        VoxaColors.pitchInRange.withValues(alpha: 0.24),
                        VoxaColors.pitchInRange.withValues(alpha: 0.08),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(VoxaRadius.lg),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(
                        context,
                      )!.commonHz(_minChartHz.round().toString()),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.50,
                        ),
                      ),
                    ),
                    Text(
                      '${AppLocalizations.of(context)!.commonHz(targetHz.round().toString())} ± $toleranceHz',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: VoxaColors.pitchInRange,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(
                        context,
                      )!.commonHz(_maxChartHz.round().toString()),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.50,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ReferenceBand extends StatelessWidget {
  const _ReferenceBand({
    required this.left,
    required this.right,
    required this.color,
  });

  final double left;
  final double right;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      width: (right - left).clamp(24, double.infinity),
      top: 22,
      bottom: 22,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0),
              color.withValues(alpha: 0.10),
              color.withValues(alpha: 0.10),
              color.withValues(alpha: 0),
            ],
          ),
          borderRadius: BorderRadius.circular(VoxaRadius.md),
        ),
      ),
    );
  }
}
