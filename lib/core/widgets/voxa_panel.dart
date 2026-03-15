import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../theme/voxa_tokens.dart';

class VoxaPanel extends StatelessWidget {
  const VoxaPanel({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(VoxaSpacing.lg),
    this.borderRadius = VoxaRadius.xl,
    this.backgroundColor,
    this.borderColor,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color:
            backgroundColor ??
            theme.colorScheme.surface.withValues(alpha: 0.84),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color:
              borderColor ??
              theme.colorScheme.outlineVariant.withValues(alpha: 0.24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 32,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
