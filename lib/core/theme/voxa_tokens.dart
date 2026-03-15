import 'package:flutter/material.dart';

abstract final class VoxaColors {
  static const violet = Color(0xFF8B5CF6);
  static const iris = Color(0xFFA78BFA);
  static const teal = Color(0xFF14B8A6);
  static const aqua = Color(0xFF5EEAD4);
  static const coral = Color(0xFFF58A7A);
  static const indigo = Color(0xFF2C3E73);
  static const night = Color(0xFF0F1220);

  static const backgroundLight = Color(0xFFF7F8FC);
  static const surfaceLight = Color(0xFFFFFFFF);
  static const surfaceLightAlt = Color(0xFFEEF2FF);
  static const borderLight = Color(0xFFD9E1F2);
  static const textPrimaryLight = Color(0xFF18233F);
  static const textSecondaryLight = Color(0xFF52607A);

  static const backgroundDark = Color(0xFF0B1020);
  static const surfaceDark = Color(0xFF171B2E);
  static const surfaceDarkAlt = Color(0xFF1F2640);
  static const surfaceDarkSoft = Color(0xFF20263A);
  static const borderDark = Color(0xFF2A3555);
  static const textPrimaryDark = Color(0xFFF8FAFC);
  static const textSecondaryDark = Color(0xFFB6C0D4);

  static const pitchLow = Color(0xFFF26B6B);
  static const pitchInRange = Color(0xFF22C55E);
  static const pitchHigh = Color(0xFF4F8CFF);
  static const warning = Color(0xFFF59E0B);
  static const info = Color(0xFF38BDF8);
}

abstract final class VoxaRadius {
  static const xs = 8.0;
  static const sm = 12.0;
  static const md = 16.0;
  static const lg = 20.0;
  static const xl = 24.0;
  static const xxl = 28.0;
}

abstract final class VoxaSpacing {
  static const xxs = 4.0;
  static const xs = 8.0;
  static const sm = 12.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 40.0;
}

const voxaPrimaryGradient = LinearGradient(
  colors: [Color(0xFF14B8A6), Color(0xFF5B7CFA), Color(0xFF8B5CF6)],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);

const voxaAmbientBackground = LinearGradient(
  colors: [Color(0xFF090D1A), Color(0xFF0C1327), Color(0xFF0A1020)],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

const voxaAmbientBackgroundLight = LinearGradient(
  colors: [Color(0xFFF8FBFF), Color(0xFFF1F5FF), Color(0xFFF7F8FC)],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);
