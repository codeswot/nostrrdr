import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      ),
      extensions: <ThemeExtension<dynamic>>[colors, typography],
      appBarTheme: getAppBarTheme(colors),
      filledButtonTheme: getFilledButtonThemeData(colors),
      dividerTheme: getDividerThemeData(colors),
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
      ),
      appBarTheme: getAppBarTheme(colors),
      filledButtonTheme: getFilledButtonThemeData(colors),
      dividerTheme: getDividerThemeData(colors),
      extensions: <ThemeExtension<dynamic>>[colors, typography],
    );
  }
}

AppBarTheme getAppBarTheme(AppColorsExtension colors) {
  return AppBarTheme(
    centerTitle: true,
    elevation: 0,
    backgroundColor: Colors.transparent,
    foregroundColor: colors.onSurface,
  );
}

FilledButtonThemeData getFilledButtonThemeData(AppColorsExtension colors) {
  return FilledButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.fromMap({
        WidgetState.selected: colors.primary,
        WidgetState.disabled: colors.primary.withValues(alpha: 0.1),
      }),
      foregroundColor: WidgetStateProperty.fromMap({
        WidgetState.selected: colors.onPrimary,
        WidgetState.disabled: colors.onBackground.withValues(alpha: 0.5),
      }),
      minimumSize: WidgetStatePropertyAll(Size(double.infinity, 50.h)),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
    ),
  );
}

DividerThemeData getDividerThemeData(AppColorsExtension colors) {
  return DividerThemeData(color: colors.onSurface, thickness: 0.1.sp);
}
