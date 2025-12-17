import 'package:flutter/material.dart';
import 'package:nostrrdr/src/app/theme/app_colors.dart';
import 'package:nostrrdr/src/app/theme/app_typography.dart';

class AppTheme {
  static ThemeData get lightTheme {
    const colors = AppColorsExtension.light;
    final typography = AppTypographyExtension.fromColors(colors.onBackground);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: colors.primary,
        onPrimary: colors.onPrimary,
        secondary: colors.secondary,
        onSecondary: colors.onSecondary,
        surface: colors.surface,
        onSurface: colors.onSurface,
        error: colors.error,
        onError: colors.onError,
        background: colors.background,
        onBackground: colors.onBackground,
      ),
      extensions: <ThemeExtension<dynamic>>[colors, typography],
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: colors.onSurface,
      ),
    );
  }

  static ThemeData get darkTheme {
    const colors = AppColorsExtension.dark;
    final typography = AppTypographyExtension.fromColors(colors.onBackground);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: colors.primary,
        onPrimary: colors.onPrimary,
        secondary: colors.secondary,
        onSecondary: colors.onSecondary,
        surface: colors.surface,
        onSurface: colors.onSurface,
        error: colors.error,
        onError: colors.onError,
        background: colors.background,
        onBackground: colors.onBackground,
      ),
      extensions: <ThemeExtension<dynamic>>[colors, typography],
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: colors.onSurface,
      ),
    );
  }
}
