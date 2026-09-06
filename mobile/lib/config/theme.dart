import 'package:flutter/material.dart';

/// Tema premium de la aplicación con diseño moderno glassmorphism
class AppTheme {
  // Colores principales
  static const Color primaryColor = Color(0xFF6C63FF);
  static const Color secondaryColor = Color(0xFF00D2FF);
  static const Color accentColor = Color(0xFFFF6584);
  static const Color backgroundColor = Color(0xFF0A0E21);
  static const Color surfaceColor = Color(0xFF1A1F38);
  static const Color cardColor = Color(0xFF252A45);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B3C5);
  static const Color successColor = Color(0xFF00E676);
  static const Color errorColor = Color(0xFFFF5252);
  static const Color warningColor = Color(0xFFFFAB40);

  // Gradientes
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, secondaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF0A0E21), Color(0xFF1A1040), Color(0xFF0A0E21)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0x33FFFFFF), Color(0x0DFFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Border radius
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 16.0;
  static const double borderRadiusLarge = 24.0;

  // Shadows
  static List<BoxShadow> get glowShadow => [
        BoxShadow(
          color: primaryColor.withValues(alpha: 0.3),
          blurRadius: 20,
          spreadRadius: -5,
        ),
      ];

  // Glassmorphism decoration
  static BoxDecoration get glassDecoration => BoxDecoration(
        gradient: cardGradient,
        borderRadius: BorderRadius.circular(borderRadiusMedium),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            spreadRadius: -5,
          ),
        ],
      );

  // Input decoration
  static InputDecoration inputDecoration({
    required String label,
    required IconData icon,
    String? hint,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: textSecondary, size: 20),
      suffixIcon: suffixIcon,
      labelStyle: const TextStyle(color: textSecondary, fontSize: 14),
      hintStyle: TextStyle(color: textSecondary.withValues(alpha: 0.5)),
      filled: true,
      fillColor: surfaceColor.withValues(alpha: 0.6),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusMedium),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusMedium),
        borderSide: BorderSide(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusMedium),
        borderSide: const BorderSide(
          color: primaryColor,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusMedium),
        borderSide: const BorderSide(
          color: errorColor,
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusMedium),
        borderSide: const BorderSide(
          color: errorColor,
          width: 2,
        ),
      ),
      errorStyle: const TextStyle(color: errorColor, fontSize: 12),
    );
  }

  // ThemeData
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: primaryColor,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        error: errorColor,
        onPrimary: textPrimary,
        onSecondary: textPrimary,
        onSurface: textPrimary,
        onError: textPrimary,
      ),
      fontFamily: 'Roboto',
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textPrimary,
          letterSpacing: -0.5,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textPrimary,
          letterSpacing: -0.3,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: textSecondary,
        ),
        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          letterSpacing: 0.5,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusMedium),
          ),
          elevation: 0,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor.withValues(alpha: 0.6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
          borderSide: BorderSide.none,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: cardColor,
        contentTextStyle: const TextStyle(color: textPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusSmall),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
