import 'package:flutter/material.dart';

enum VoxaLogoVariant { framed, badge, plain }

class VoxaLogo extends StatelessWidget {
  const VoxaLogo({
    super.key,
    this.size = 48,
    this.padding = const EdgeInsets.all(8),
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = 16,
    this.variant = VoxaLogoVariant.framed,
  });

  final double size;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderRadius;
  final VoxaLogoVariant variant;

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(_assetPath, fit: BoxFit.contain);

    if (variant == VoxaLogoVariant.badge) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: SizedBox(width: size, height: size, child: image),
      );
    }

    if (variant == VoxaLogoVariant.plain) {
      return SizedBox(width: size, height: size, child: image);
    }

    return Container(
      width: size,
      height: size,
      padding: padding,
      decoration: BoxDecoration(
        color:
            backgroundColor ??
            Theme.of(context).colorScheme.surface.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color:
              borderColor ??
              Theme.of(
                context,
              ).colorScheme.outlineVariant.withValues(alpha: 0.18),
        ),
      ),
      child: image,
    );
  }

  String get _assetPath => switch (variant) {
    VoxaLogoVariant.badge => 'assets/logo/voxa_logo_bg.png',
    VoxaLogoVariant.framed || VoxaLogoVariant.plain =>
      'assets/logo/voxa_logo.png',
  };
}
