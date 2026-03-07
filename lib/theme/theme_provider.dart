import 'dart:async';
import 'package:farm_express/theme/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:light/light.dart';

// Theme mode provider to manage light/dark theme switching
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(),
);

// Provider for auto theme (sensor-based) state
final autoThemeProvider = StateNotifierProvider<AutoThemeNotifier, bool>(
  (ref) => AutoThemeNotifier(ref),
);

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.light);

  void setThemeMode(ThemeMode mode) {
    state = mode;
  }

  void toggleThemeMode() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }

  void setLightTheme() {
    state = ThemeMode.light;
  }

  void setDarkTheme() {
    state = ThemeMode.dark;
  }
}

class AutoThemeNotifier extends StateNotifier<bool> {
  AutoThemeNotifier(this.ref) : super(false);
  final dynamic ref;
  final Light _light = Light();
  StreamSubscription<int>? _lightSubscription;

  static const int _brightLuxThreshold = 120;
  static const int _darkLuxThreshold = 40;

  void enableAutoTheme() {
    state = true;
    _startListeningToSensor();
  }

  void disableAutoTheme() {
    state = false;
    _stopListeningToSensor();
  }

  void _startListeningToSensor() {
    _stopListeningToSensor();

    if (kIsWeb) {
      debugPrint('Auto theme via ALS is not supported on web.');
      return;
    }

    _lightSubscription = _light.lightSensorStream.listen(
      (int lux) {
        if (lux >= _brightLuxThreshold) {
          ref.read(themeModeProvider.notifier).setLightTheme();
          debugPrint('Bright environment detected ($lux lux): Light Mode');
        } else if (lux <= _darkLuxThreshold) {
          ref.read(themeModeProvider.notifier).setDarkTheme();
          debugPrint('Dark environment detected ($lux lux): Dark Mode');
        }
      },
      onError: (Object error, StackTrace stackTrace) {
        debugPrint('Ambient light sensor error: $error');
      },
    );
  }

  void _stopListeningToSensor() {
    _lightSubscription?.cancel();
    _lightSubscription = null;
  }

  @override
  void dispose() {
    _stopListeningToSensor();
    super.dispose();
  }
}

/// Extension to get colors from BuildContext based on current theme
extension AppColorsExtension on BuildContext {
  /// Get color scheme based on current brightness
  /// Usage: context.appColors.primary, context.appColors.success, etc.
  dynamic get appColors {
    return Theme.of(this).brightness == Brightness.dark
        ? AppColorsDark()
        : AppColorsLight();
  }

  /// Get light theme colors
  AppColorsLight get appColorsLight => AppColorsLight();

  /// Get dark theme colors
  AppColorsDark get appColorsDark => AppColorsDark();

  /// Check if current theme is dark
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  /// Check if current theme is light
  bool get isLight => Theme.of(this).brightness == Brightness.light;
}

/// Status color helper
extension StatusColorExtension on String {
  Color getStatusColor({required bool isDark}) {
    if (isDark) {
      final colors = AppColorsDark();
      switch (toLowerCase()) {
        case 'pending':
          return colors.warning;
        case 'accepted':
          return colors.info;
        case 'shipped':
          return colors.shipped;
        case 'delivered':
          return colors.success;
        case 'cancelled':
          return colors.error;
        default:
          return colors.textSecondary;
      }
    } else {
      final colors = AppColorsLight();
      switch (toLowerCase()) {
        case 'pending':
          return colors.warning;
        case 'accepted':
          return colors.info;
        case 'shipped':
          return colors.shipped;
        case 'delivered':
          return colors.success;
        case 'cancelled':
          return colors.error;
        default:
          return colors.textSecondary;
      }
    }
  }

  Color getStatusBackgroundColor({required bool isDark}) {
    final light = AppColorsLight();
    switch (toLowerCase()) {
      case 'pending':
        return light.warningLight;
      case 'accepted':
        return light.infoLight;
      case 'shipped':
        return light.shippedLight;
      case 'delivered':
        return light.successLight;
      case 'cancelled':
        return light.errorLight;
      default:
        return light.surfaceVariant;
    }
  }
}
