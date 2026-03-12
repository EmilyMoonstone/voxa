# Flutter Design Tokens

## Foundations

Recommended stack:
- Flutter
- Material 3 as baseline
- custom Voxa theme layer

## Color Tokens

```dart
class VoxaColors {
  static const violet = Color(0xFF8B5CF6);
  static const iris = Color(0xFFA78BFA);
  static const teal = Color(0xFF14B8A6);
  static const aqua = Color(0xFF5EEAD4);
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
  static const borderDark = Color(0xFF2A3555);
  static const textPrimaryDark = Color(0xFFF8FAFC);
  static const textSecondaryDark = Color(0xFFB6C0D4);

  static const pitchLow = Color(0xFFF26B6B);
  static const pitchInRange = Color(0xFF22C55E);
  static const pitchHigh = Color(0xFF4F8CFF);
  static const warning = Color(0xFFF59E0B);
  static const info = Color(0xFF38BDF8);
}
```

## Gradient Tokens

```dart
const voxaPrimaryGradient = LinearGradient(
  colors: [
    Color(0xFF14B8A6),
    Color(0xFF5B7CFA),
    Color(0xFF8B5CF6),
  ],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);
```

## Radius Tokens

```dart
class VoxaRadius {
  static const xs = 8.0;
  static const sm = 12.0;
  static const md = 16.0;
  static const lg = 20.0;
  static const xl = 24.0;
  static const xxl = 28.0;
}
```

## Spacing Tokens

```dart
class VoxaSpacing {
  static const xxs = 4.0;
  static const xs = 8.0;
  static const sm = 12.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 40.0;
}
```

## Typography Tokens

Recommended font family:
- `Manrope`

Suggested semantic roles:

```dart
class VoxaTypeScale {
  static const displayLarge = 32.0;
  static const displayMedium = 28.0;
  static const headlineLarge = 24.0;
  static const headlineMedium = 20.0;
  static const titleLarge = 18.0;
  static const bodyLarge = 16.0;
  static const bodyMedium = 14.0;
  static const labelLarge = 14.0;
  static const metricHero = 48.0;
  static const metricLarge = 32.0;
}
```

## Elevation / Surface Strategy

Suggested approach:
- prefer tonal separation over strong shadows
- use very soft shadows only where necessary
- keep dark mode surfaces distinct but close in value

## Component Guidelines

### Buttons
- primary: violet fill or brand gradient
- secondary: tinted teal or low-emphasis surface
- destructive: use error color carefully

### Cards
- rounded, generous padding
- surface-based hierarchy
- no harsh borders unless needed for contrast

### Charts
- curved line options where helpful
- subtle grid lines
- strong legibility for comparison mode

### Live Gauge
- one dominant central component
- semantic colors for low / in-range / high
- smooth animation, low latency visual updates

## Theme Strategy

Create:
- `VoxaColorScheme.light()`
- `VoxaColorScheme.dark()`
- component theme extensions for live gauge, charts and session cards

A custom `ThemeExtension` structure is recommended for:
- live pitch colors
- chart colors
- gradient tokens
- training state styles
