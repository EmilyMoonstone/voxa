import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'voxa_tokens.dart';

class VoxaTheme {
  const VoxaTheme._();

  static ThemeData light() {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: VoxaColors.violet,
      onPrimary: Colors.white,
      secondary: VoxaColors.teal,
      onSecondary: Colors.white,
      error: VoxaColors.pitchLow,
      onError: Colors.white,
      surface: VoxaColors.surfaceLight,
      onSurface: VoxaColors.textPrimaryLight,
    );

    return _baseTheme(colorScheme).copyWith(
      scaffoldBackgroundColor: VoxaColors.backgroundLight,
      cardColor: VoxaColors.surfaceLight,
      dividerColor: VoxaColors.borderLight,
      chipTheme: _chipTheme(colorScheme),
    );
  }

  static ThemeData dark() {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: VoxaColors.iris,
      onPrimary: VoxaColors.night,
      secondary: VoxaColors.aqua,
      onSecondary: VoxaColors.night,
      error: VoxaColors.pitchLow,
      onError: Colors.white,
      surface: VoxaColors.surfaceDark,
      onSurface: VoxaColors.textPrimaryDark,
    );

    return _baseTheme(colorScheme).copyWith(
      scaffoldBackgroundColor: VoxaColors.backgroundDark,
      cardColor: VoxaColors.surfaceDark,
      dividerColor: VoxaColors.borderDark,
      chipTheme: _chipTheme(colorScheme),
    );
  }

  static ThemeData _baseTheme(ColorScheme colorScheme) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      visualDensity: VisualDensity.standard,
    );
    final textTheme = GoogleFonts.manropeTextTheme(base.textTheme)
        .copyWith(
          displaySmall: GoogleFonts.manrope(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            height: 1.1,
          ),
          headlineLarge: GoogleFonts.manrope(
            fontSize: 40,
            fontWeight: FontWeight.w800,
            height: 1.06,
          ),
          headlineMedium: GoogleFonts.manrope(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
          titleLarge: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            height: 1.25,
          ),
          bodyLarge: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 1.45,
          ),
          bodyMedium: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.45,
          ),
          labelLarge: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
        )
        .apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        );

    return base.copyWith(
      textTheme: textTheme,
      scaffoldBackgroundColor: colorScheme.brightness == Brightness.light
          ? VoxaColors.backgroundLight
          : VoxaColors.backgroundDark,
      canvasColor: colorScheme.surface,
      cardColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: colorScheme.brightness == Brightness.light
            ? colorScheme.surface
            : VoxaColors.surfaceDarkSoft.withValues(alpha: 0.88),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(VoxaRadius.xl),
          side: BorderSide(
            color: colorScheme.brightness == Brightness.light
                ? VoxaColors.borderLight
                : VoxaColors.borderDark,
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: colorScheme.primary.withValues(alpha: 0.16),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected
                ? colorScheme.primary
                : colorScheme.onSurface.withValues(alpha: 0.86),
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: selected
                ? colorScheme.primary
                : colorScheme.onSurface.withValues(alpha: 0.82),
          );
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        labelStyle: textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurface.withValues(alpha: 0.82),
        ),
        hintStyle: textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurface.withValues(alpha: 0.54),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme.onSurface.withValues(alpha: 0.36),
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
      ),
      dividerColor: colorScheme.brightness == Brightness.light
          ? VoxaColors.borderLight
          : VoxaColors.borderDark,
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: VoxaSpacing.lg,
            vertical: VoxaSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(VoxaRadius.lg),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: VoxaSpacing.lg,
            vertical: VoxaSpacing.md,
          ),
          side: BorderSide(color: colorScheme.primary.withValues(alpha: 0.25)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(VoxaRadius.lg),
          ),
        ),
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: VoxaSpacing.md,
          vertical: VoxaSpacing.xs,
        ),
        iconColor: colorScheme.onSurface,
        textColor: colorScheme.onSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(VoxaRadius.lg),
        ),
      ),
    );
  }

  static ChipThemeData _chipTheme(ColorScheme colorScheme) {
    return ChipThemeData(
      side: BorderSide(color: colorScheme.primary.withValues(alpha: 0.12)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(VoxaRadius.lg),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      selectedColor: colorScheme.primary.withValues(alpha: 0.14),
      backgroundColor: colorScheme.surface,
      labelStyle: GoogleFonts.manrope(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
