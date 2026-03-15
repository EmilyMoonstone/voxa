import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voxa/l10n/app_localizations.dart';

import '../../../app/app_providers.dart';
import '../../../app/router/app_routes.dart';
import '../../../core/theme/voxa_tokens.dart';
import '../../../core/widgets/voxa_logo.dart';
import '../../../core/widgets/voxa_panel.dart';
import '../../goal_setting/application/voice_target_use_cases.dart';
import '../../goal_setting/application/voice_target_validation.dart';
import '../../goal_setting/domain/voice_target.dart';
import '../../goal_setting/presentation/target_measurement.dart';

class OnboardingWelcomeScreen extends ConsumerWidget {
  const OnboardingWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: voxaAmbientBackground),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              VoxaSpacing.lg,
              VoxaSpacing.xl,
              VoxaSpacing.lg,
              VoxaSpacing.xl,
            ),
            children: [
              const SizedBox(height: VoxaSpacing.lg),
              const Center(
                child: VoxaLogo(
                  size: 80,
                  borderRadius: 20,
                  variant: VoxaLogoVariant.badge,
                ),
              ),
              const SizedBox(height: VoxaSpacing.xl),
              Text(
                l10n.onboardingTitle,
                style: theme.textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: VoxaSpacing.md),
              Text(
                l10n.onboardingBody,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: VoxaSpacing.xl),
              VoxaPanel(
                padding: const EdgeInsets.all(VoxaSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.onboardingWelcomeCardTitle,
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: VoxaSpacing.sm),
                    Text(
                      l10n.onboardingWelcomeCardBody,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.72,
                        ),
                      ),
                    ),
                    const SizedBox(height: VoxaSpacing.xl),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () =>
                            const OnboardingTargetRoute().go(context),
                        child: Text(l10n.onboardingContinue),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingTargetScreen extends ConsumerStatefulWidget {
  const OnboardingTargetScreen({super.key});

  @override
  ConsumerState<OnboardingTargetScreen> createState() =>
      _OnboardingTargetScreenState();
}

class _OnboardingTargetScreenState
    extends ConsumerState<OnboardingTargetScreen> {
  late final TextEditingController _customTargetController;
  TargetPreset _selectedPreset = TargetPreset.androgynous;
  bool _isSaving = false;
  bool _isMeasuring = false;

  @override
  void initState() {
    super.initState();
    _customTargetController = TextEditingController(
      text: presetTargetSuggestions[TargetPreset.androgynous]!
          .round()
          .toString(),
    );
  }

  @override
  void dispose() {
    _customTargetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: voxaAmbientBackground),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              VoxaSpacing.lg,
              VoxaSpacing.xl,
              VoxaSpacing.lg,
              VoxaSpacing.xl,
            ),
            children: [
              _BackLink(
                onTap: () => const OnboardingWelcomeRoute().go(context),
              ),
              const SizedBox(height: VoxaSpacing.lg),
              Text(
                l10n.onboardingTargetTitle,
                style: theme.textTheme.headlineLarge,
              ),
              const SizedBox(height: VoxaSpacing.sm),
              Text(
                l10n.onboardingTargetSubtitle,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
                ),
              ),
              const SizedBox(height: VoxaSpacing.xl),
              ...TargetPreset.values
                  .where((preset) => preset != TargetPreset.custom)
                  .map(
                    (preset) => Padding(
                      padding: const EdgeInsets.only(bottom: VoxaSpacing.md),
                      child: _PresetCard(
                        preset: preset,
                        label: _presetLabel(l10n, preset),
                        selected: _selectedPreset == preset,
                        onTap: () => setState(() {
                          _selectedPreset = preset;
                          _customTargetController.text =
                              presetTargetSuggestions[preset]!
                                  .round()
                                  .toString();
                        }),
                      ),
                    ),
                  ),
              VoxaPanel(
                padding: const EdgeInsets.all(VoxaSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.goalMeasureTitle,
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: VoxaSpacing.xs),
                    Text(
                      l10n.goalMeasureBody,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.72,
                        ),
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
              const SizedBox(height: VoxaSpacing.md),
              ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(
                  horizontal: VoxaSpacing.md,
                ),
                childrenPadding: const EdgeInsets.fromLTRB(
                  VoxaSpacing.md,
                  0,
                  VoxaSpacing.md,
                  VoxaSpacing.md,
                ),
                title: Text(l10n.goalMoreOptionsTitle),
                subtitle: Text(l10n.onboardingMoreOptionsBody),
                children: [
                  TextFormField(
                    controller: _customTargetController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: l10n.goalTargetLabel,
                      suffixText: l10n.commonUnitHz,
                    ),
                    onTap: () =>
                        setState(() => _selectedPreset = TargetPreset.custom),
                    onChanged: (_) =>
                        setState(() => _selectedPreset = TargetPreset.custom),
                  ),
                ],
              ),
              const SizedBox(height: VoxaSpacing.xl),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isSaving ? null : _saveAndContinue,
                  child: Text(
                    _isSaving ? l10n.commonLoading : l10n.onboardingContinue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _presetLabel(AppLocalizations l10n, TargetPreset preset) {
    return switch (preset) {
      TargetPreset.feminine => l10n.goalPresetFeminine,
      TargetPreset.androgynous => l10n.goalPresetAndrogynous,
      TargetPreset.masculine => l10n.goalPresetMasculine,
      TargetPreset.custom => l10n.goalPresetCustom,
    };
  }

  Future<void> _measureFromVoice() async {
    setState(() => _isMeasuring = true);
    final targetHz = await measureTargetFromVoice(context, ref);
    if (!mounted) {
      return;
    }
    setState(() {
      _isMeasuring = false;
      if (targetHz != null) {
        _selectedPreset = TargetPreset.custom;
        _customTargetController.text = targetHz.round().toString();
      }
    });
  }

  Future<void> _saveAndContinue() async {
    final l10n = AppLocalizations.of(context)!;
    final targetHz = _resolveTargetHz();
    if (targetHz == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.goalValidationBounds)));
      return;
    }

    setState(() => _isSaving = true);
    final now = DateTime.now().toUtc();
    await ref
        .read(saveVoiceTargetUseCaseProvider)
        .execute(
          VoiceTarget(
            id: 'current-target',
            targetHz: targetHz,
            suggestionPreset: _selectedPreset,
            createdAt: now,
            updatedAt: now,
          ),
        );
    if (!mounted) {
      return;
    }
    setState(() => _isSaving = false);
    const OnboardingPermissionsRoute().go(context);
  }

  double? _resolveTargetHz() {
    if (_selectedPreset != TargetPreset.custom) {
      return presetTargetSuggestions[_selectedPreset];
    }
    final value = double.tryParse(_customTargetController.text);
    if (validateVoiceTargetHz(targetHz: value) != null) {
      return null;
    }
    return value;
  }
}

class OnboardingPermissionsScreen extends ConsumerStatefulWidget {
  const OnboardingPermissionsScreen({super.key});

  @override
  ConsumerState<OnboardingPermissionsScreen> createState() =>
      _OnboardingPermissionsScreenState();
}

class _OnboardingPermissionsScreenState
    extends ConsumerState<OnboardingPermissionsScreen> {
  bool _isRequesting = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: voxaAmbientBackground),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              VoxaSpacing.lg,
              VoxaSpacing.xl,
              VoxaSpacing.lg,
              VoxaSpacing.xl,
            ),
            children: [
              _BackLink(onTap: () => const OnboardingTargetRoute().go(context)),
              const SizedBox(height: VoxaSpacing.lg),
              Icon(
                Icons.mic_rounded,
                size: 56,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: VoxaSpacing.xl),
              Text(
                l10n.practicePermissionTitle,
                style: theme.textTheme.headlineLarge,
              ),
              const SizedBox(height: VoxaSpacing.sm),
              Text(
                l10n.practicePermissionBody,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
                ),
              ),
              const SizedBox(height: VoxaSpacing.xl),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isRequesting ? null : _requestPermission,
                  child: Text(
                    _isRequesting
                        ? l10n.commonLoading
                        : l10n.practiceGrantPermission,
                  ),
                ),
              ),
              const SizedBox(height: VoxaSpacing.sm),
              Center(
                child: TextButton(
                  onPressed: () => const HomeRoute().go(context),
                  child: Text(l10n.onboardingSkipForNow),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _requestPermission() async {
    setState(() => _isRequesting = true);
    final permissionService = ref.read(audioPermissionServiceProvider);
    await permissionService.requestPermission();
    if (!mounted) {
      return;
    }
    setState(() => _isRequesting = false);
    const HomeRoute().go(context);
  }
}

class _PresetCard extends StatelessWidget {
  const _PresetCard({
    required this.preset,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final TargetPreset preset;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final band = presetReferenceBands[preset]!;

    return InkWell(
      borderRadius: BorderRadius.circular(VoxaRadius.xl),
      onTap: onTap,
      child: VoxaPanel(
        padding: const EdgeInsets.all(VoxaSpacing.lg),
        borderColor: selected ? VoxaColors.aqua.withValues(alpha: 0.42) : null,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: theme.textTheme.titleLarge),
                  const SizedBox(height: VoxaSpacing.xs),
                  Text(
                    AppLocalizations.of(context)!.commonRangeHz(
                      band.minHz.round().toString(),
                      band.maxHz.round().toString(),
                    ),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(
                        alpha: 0.72,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              const Icon(Icons.check_circle_rounded, color: VoxaColors.aqua),
          ],
        ),
      ),
    );
  }
}

class _BackLink extends StatelessWidget {
  const _BackLink({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.arrow_back_rounded),
        label: Text(AppLocalizations.of(context)!.commonBack),
      ),
    );
  }
}
