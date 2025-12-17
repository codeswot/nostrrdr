import 'package:flutter/material.dart';

@immutable
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  const AppColorsExtension({
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.error,
    required this.onError,
    required this.roseRed,
    required this.oceanBlue,
    required this.forestGreen,
    required this.sunYellow,
  });

  final Color primary;
  final Color onPrimary;
  final Color secondary;
  final Color onSecondary;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color error;
  final Color onError;

  // Custom semantic colors
  final Color roseRed;
  final Color oceanBlue;
  final Color forestGreen;
  final Color sunYellow;

  @override
  AppColorsExtension copyWith({
    Color? primary,
    Color? onPrimary,
    Color? secondary,
    Color? onSecondary,
    Color? background,
    Color? onBackground,
    Color? surface,
    Color? onSurface,
    Color? error,
    Color? onError,
    Color? roseRed,
    Color? oceanBlue,
    Color? forestGreen,
    Color? sunYellow,
  }) {
    return AppColorsExtension(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      secondary: secondary ?? this.secondary,
      onSecondary: onSecondary ?? this.onSecondary,
      background: background ?? this.background,
      onBackground: onBackground ?? this.onBackground,
      surface: surface ?? this.surface,
      onSurface: onSurface ?? this.onSurface,
      error: error ?? this.error,
      onError: onError ?? this.onError,
      roseRed: roseRed ?? this.roseRed,
      oceanBlue: oceanBlue ?? this.oceanBlue,
      forestGreen: forestGreen ?? this.forestGreen,
      sunYellow: sunYellow ?? this.sunYellow,
    );
  }

  @override
  AppColorsExtension lerp(ThemeExtension<AppColorsExtension>? other, double t) {
    if (other is! AppColorsExtension) {
      return this;
    }
    return AppColorsExtension(
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      onSecondary: Color.lerp(onSecondary, other.onSecondary, t)!,
      background: Color.lerp(background, other.background, t)!,
      onBackground: Color.lerp(onBackground, other.onBackground, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      error: Color.lerp(error, other.error, t)!,
      onError: Color.lerp(onError, other.onError, t)!,
      roseRed: Color.lerp(roseRed, other.roseRed, t)!,
      oceanBlue: Color.lerp(oceanBlue, other.oceanBlue, t)!,
      forestGreen: Color.lerp(forestGreen, other.forestGreen, t)!,
      sunYellow: Color.lerp(sunYellow, other.sunYellow, t)!,
    );
  }

  // Light Theme Colors
  static const light = AppColorsExtension(
    primary: Color(0xFF6750A4),
    onPrimary: Colors.white,
    secondary: Color(0xFF625B71),
    onSecondary: Colors.white,
    background: Color(0xFFFFFBFE),
    onBackground: Color(0xFF1C1B1F),
    surface: Color(0xFFFFFBFE),
    onSurface: Color(0xFF1C1B1F),
    error: Color(0xFFB3261E),
    onError: Colors.white,
    roseRed: Color(0xFFE91E63),
    oceanBlue: Color(0xFF03A9F4),
    forestGreen: Color(0xFF4CAF50),
    sunYellow: Color(0xFFFFC107),
  );

  // Dark Theme Colors
  static const dark = AppColorsExtension(
    primary: Color(0xFFD0BCFF),
    onPrimary: Color(0xFF381E72),
    secondary: Color(0xFFCCC2DC),
    onSecondary: Color(0xFF332D41),
    background: Color(0xFF1C1B1F),
    onBackground: Color(0xFFE6E1E5),
    surface: Color(0xFF1C1B1F),
    onSurface: Color(0xFFE6E1E5),
    error: Color(0xFFF2B8B5),
    onError: Color(0xFF601410),
    roseRed: Color(0xFFF48FB1),
    oceanBlue: Color(0xFF81D4FA),
    forestGreen: Color(0xFFA5D6A7),
    sunYellow: Color(0xFFFFE082),
  );
}

// Extension to access colors via context
extension AppColorsContext on BuildContext {
  AppColorsExtension get colors =>
      Theme.of(this).extension<AppColorsExtension>() ??
      AppColorsExtension.light;
}
