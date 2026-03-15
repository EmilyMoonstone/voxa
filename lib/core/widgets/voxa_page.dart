import 'package:flutter/material.dart';

import '../theme/voxa_tokens.dart';

class VoxaPage extends StatelessWidget {
  const VoxaPage({
    required this.children,
    super.key,
    this.title,
    this.subtitle,
    this.eyebrow,
    this.trailing,
    this.padding = const EdgeInsets.fromLTRB(
      VoxaSpacing.lg,
      VoxaSpacing.xl,
      VoxaSpacing.lg,
      140,
    ),
  });

  final String? title;
  final String? subtitle;
  final String? eyebrow;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
          ListView(
            padding: padding,
            children: [
              if (title != null || subtitle != null || eyebrow != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: VoxaSpacing.xl),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (eyebrow != null)
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: VoxaSpacing.sm,
                                ),
                                child: Text(
                                  eyebrow!,
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: VoxaColors.aqua,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                            if (title != null)
                              Text(
                                title!,
                                style: theme.textTheme.headlineLarge,
                              ),
                            if (subtitle != null)
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: VoxaSpacing.sm,
                                ),
                                child: Text(
                                  subtitle!,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.72),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (trailing != null) ...[
                        const SizedBox(width: VoxaSpacing.md),
                        trailing!,
                      ],
                    ],
                  ),
                ),
              ..._withGaps(children),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _withGaps(List<Widget> items) {
    if (items.isEmpty) {
      return const [];
    }
    final widgets = <Widget>[];
    for (var index = 0; index < items.length; index++) {
      widgets.add(items[index]);
      if (index != items.length - 1) {
        widgets.add(const SizedBox(height: VoxaSpacing.lg));
      }
    }
    return widgets;
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
