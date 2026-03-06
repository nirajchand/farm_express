import 'package:flutter/material.dart';

/// Light Theme Colors
class AppColorsLight {
  // Primary Colors
  final Color primary = const Color(0xFF15A305);
  final Color primaryDark = const Color(0xFF1BAA3D);
  final Color primaryLight = const Color(0xFFC8F1C8);
  final Color primaryContainer = const Color(0xFFE9F9ED);

  // Secondary Colors
  final Color secondary = const Color(0xFF2ECC52);
  final Color secondaryDark = const Color(0xFF1BAA3D);
  final Color secondaryLight = const Color(0xFFE9F9ED);

  // Success/Status Colors
  final Color success = const Color(0xFF2E7D32);
  final Color successLight = const Color(0xFFE8F5E9);
  final Color successContainer = const Color(0xFFF0F7F0);

  // Warning/Pending Colors
  final Color warning = const Color(0xFFE65100);
  final Color warningLight = const Color(0xFFFFF3E0);

  // Error Colors
  final Color error = const Color(0xFFEF4444);
  final Color errorRed = const Color(0xFFC62828);
  final Color errorLight = const Color(0xFFFFEBEE);

  // Info/Blue Colors
  final Color info = const Color(0xFF3B82F6);
  final Color infoBlue = const Color(0xFF1565C0);
  final Color infoLight = const Color(0xFFE3F2FD);

  // Accent Colors
  final Color accent = const Color(0xFF7B61FF);
  final Color accentLight = const Color(0xFFB8A9FF);
  final Color shipped = const Color(0xFF6A1B9A);
  final Color shippedLight = const Color(0xFFF3E5F5);

  // Background Colors
  final Color background = const Color(0xFFF5F7F5);
  final Color backgroundAlt = const Color(0xFFF7FAF7);
  final Color surface = Colors.white;
  final Color surfaceVariant = const Color(0xFFF5F5F5);

  // Text Colors
  final Color textPrimary = const Color(0xFF1A1A1A);
  final Color textSecondary = const Color(0xFF8A8A8A);
  final Color textTertiary = const Color(0xFF6B8C6B);
  final Color textHint = const Color(0xFF766868);
  final Color textMuted = const Color(0xFF616161);

  // Border/Divider Colors
  final Color border = const Color(0xFFDDE8DD);
  final Color divider = const Color(0xFFF0F4F0);
  final Color borderLight = const Color(0xFFE0E0E0);

  // Neutral Colors
  final Color white = Colors.white;
  final Color black = Colors.black;
  final Color grey = Colors.grey;
  final Color greyLight = const Color(0xFFE8E8E8);

  // Special Colors
  final Color lightBackground = const Color(0xFFE8E8E8);
  final Color whitebck = const Color.fromARGB(255, 232, 234, 237);
  final Color amber = Colors.amber;
  final Color shadow = const Color(0x0A000000);
  final Color shadowOpaque = const Color(0x08000000);
}

/// Dark Theme Colors
class AppColorsDark {
  // Primary Colors
  final Color primary = const Color(0xFF4CAF50);
  final Color primaryDark = const Color(0xFF2E7D32);
  final Color primaryLight = const Color(0xFFC8F1C8);
  final Color primaryContainer = const Color(0xFF1B5E20);

  // Secondary Colors
  final Color secondary = const Color(0xFF4CAF50);
  final Color secondaryDark = const Color(0xFF2E7D32);
  final Color secondaryLight = const Color(0xFFC8F1C8);

  // Success/Status Colors
  final Color success = const Color(0xFF4CAF50);
  final Color successLight = const Color(0xFF81C784);
  final Color successContainer = const Color(0xFF1B5E20);

  // Warning/Pending Colors
  final Color warning = const Color(0xFFFF9800);
  final Color warningLight = const Color(0xFFFFB74D);

  // Error Colors
  final Color error = const Color(0xFFEF4444);
  final Color errorRed = const Color(0xFFE53935);
  final Color errorLight = const Color(0xFFEF5350);

  // Info/Blue Colors
  final Color info = const Color(0xFF64B5F6);
  final Color infoBlue = const Color(0xFF42A5F5);
  final Color infoLight = const Color(0xFF90CAF9);

  // Accent Colors
  final Color accent = const Color(0xFFBB86FC);
  final Color accentLight = const Color(0xFFDCC9FF);
  final Color shipped = const Color(0xFFCE93D8);
  final Color shippedLight = const Color(0xFFE1BEE7);

  // Background Colors
  final Color background = const Color(0xFF121212);
  final Color backgroundAlt = const Color(0xFF1E1E1E);
  final Color surface = const Color(0xFF1F1F1F);
  final Color surfaceVariant = const Color(0xFF2C2C2C);

  // Text Colors
  final Color textPrimary = const Color(0xFFFFFFFF);
  final Color textSecondary = const Color(0xFFB0B0B0);
  final Color textTertiary = const Color(0xFF90A090);
  final Color textHint = const Color(0xFF999999);
  final Color textMuted = const Color(0xFF757575);

  // Border/Divider Colors
  final Color border = const Color(0xFF3D5A3D);
  final Color divider = const Color(0xFF303030);
  final Color borderLight = const Color(0xFF424242);

  // Neutral Colors
  final Color white = const Color(0xFFFFFFFF);
  final Color black = const Color(0xFF121212);
  final Color grey = const Color(0xFF9E9E9E);
  final Color greyLight = const Color(0xFF424242);

  // Special Colors
  final Color lightBackground = const Color(0xFF303030);
  final Color whitebck = const Color(0xFF2C2C2C);
  final Color amber = const Color(0xFFFFC107);
  final Color shadow = const Color(0x1A000000);
  final Color shadowOpaque = const Color(0x26000000);
}

/// App Colors Interface - Use this to access colors in the app
class AppColors {
  // Use context to determine which theme to apply
  static AppColorsLight light = AppColorsLight();
  static AppColorsDark dark = AppColorsDark();

  // Convenience method to get colors based on brightness
  static AppColorsLight getLight() => AppColorsLight();
  static AppColorsDark getDark() => AppColorsDark();
}
