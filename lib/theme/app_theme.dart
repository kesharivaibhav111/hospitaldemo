import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors - Medical Palette
  static const Color primaryBlue = Color(0xFF0A3D62); // Deep medical navy blue
  static const Color primaryBlueDark = Color(0xFF06233B);
  static const Color primaryBlueLight = Color(0xFF1B5B8E);
  static const Color tealSecondary = Color(0xFF0D9488); // Healthcare teal
  static const Color tealLight = Color(0xFFE6FFFA);
  static const Color tealAccent = Color(0xFF14B8A6);

  // Background & Surfaces
  static const Color scaffoldBackground = Color(0xFFF4F7FB); // Soft light blue-gray
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF8FAFC);
  static const Color cardShadow = Color(0x0C0F172A);

  // Typography Colors
  static const Color textDark = Color(0xFF0F172A); // Dark navy
  static const Color textSecondary = Color(0xFF334155);
  static const Color textMuted = Color(0xFF64748B);
  static const Color textLight = Color(0xFF94A3B8);

  // Borders & Accents
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color borderFocus = Color(0xFF0A3D62);
  static const Color errorRed = Color(0xFFDC2626);
  static const Color errorRedLight = Color(0xFFFEF2F2);
  static const Color successGreen = Color(0xFF16A34A);
  static const Color successGreenLight = Color(0xFFF0FDF4);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: scaffoldBackground,
      colorScheme: const ColorScheme.light(
        primary: primaryBlue,
        onPrimary: surfaceWhite,
        secondary: tealSecondary,
        onSecondary: surfaceWhite,
        surface: surfaceWhite,
        onSurface: textDark,
        error: errorRed,
        onError: surfaceWhite,
      ),
      fontFamily: null, // Uses high quality system font fallback
      cardTheme: CardThemeData(
        color: surfaceWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: borderLight, width: 1),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryBlue;
          }
          return Colors.transparent;
        }),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        side: const BorderSide(color: textMuted, width: 1.5),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
