import 'package:farm_express/theme/app_colors.dart';
import 'package:flutter/material.dart';

ThemeData getApplicationLightTheme() {
  final colors = AppColorsLight();
  return ThemeData(
    useMaterial3: true,
    fontFamily: "OpenSans",
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: colors.primary,
      secondary: colors.secondary,
      error: colors.error,
      surface: colors.surface,
      onPrimary: colors.white,
      onSecondary: colors.textPrimary,
      onError: colors.white,
      onSurface: colors.textPrimary,
    ),
    scaffoldBackgroundColor: colors.background,
    appBarTheme: AppBarTheme(
      backgroundColor: colors.surface,
      foregroundColor: colors.textPrimary,
      elevation: 0,
      centerTitle: false,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.primary,
        foregroundColor: colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: colors.primary),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: colors.primary,
        side: BorderSide(color: colors.border),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.error),
      ),
      labelStyle: TextStyle(color: colors.textSecondary),
      hintStyle: TextStyle(color: colors.textHint),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: colors.surface,
      selectedItemColor: colors.primary,
      unselectedItemColor: colors.textSecondary,
      elevation: 8,
    ),
    cardTheme: CardThemeData(
      color: colors.surface,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        color: colors.textPrimary,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: colors.textPrimary,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        color: colors.textPrimary,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(color: colors.textPrimary),
      bodyMedium: TextStyle(color: colors.textSecondary),
      bodySmall: TextStyle(color: colors.textHint),
    ),
  );
}

ThemeData getApplicationDarkTheme() {
  final colors = AppColorsDark();
  return ThemeData(
    useMaterial3: true,
    fontFamily: "OpenSans",
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: colors.primary,
      secondary: colors.secondary,
      error: colors.error,
      surface: colors.surface,
      onPrimary: colors.textPrimary,
      onSecondary: colors.textPrimary,
      onError: colors.textPrimary,
      onSurface: colors.textPrimary,
    ),
    scaffoldBackgroundColor: colors.background,
    appBarTheme: AppBarTheme(
      backgroundColor: colors.surface,
      foregroundColor: colors.textPrimary,
      elevation: 0,
      centerTitle: false,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.primary,
        foregroundColor: colors.textPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: colors.primary),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: colors.primary,
        side: BorderSide(color: colors.border),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colors.surfaceVariant,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.error),
      ),
      labelStyle: TextStyle(color: colors.textSecondary),
      hintStyle: TextStyle(color: colors.textHint),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: colors.surface,
      selectedItemColor: colors.primary,
      unselectedItemColor: colors.textSecondary,
      elevation: 8,
    ),
    cardTheme: CardThemeData(
      color: colors.surface,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        color: colors.textPrimary,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: colors.textPrimary,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        color: colors.textPrimary,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(color: colors.textPrimary),
      bodyMedium: TextStyle(color: colors.textSecondary),
      bodySmall: TextStyle(color: colors.textHint),
    ),
  );
}

// Keep this for backward compatibility
ThemeData getApplicationTheme() {
  return getApplicationLightTheme();
}
