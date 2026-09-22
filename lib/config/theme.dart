import 'package:flutter/material.dart';

class AppColors {
  // --- Minimal Monochrome Palette (Eye-Friendly, Neutral, Crisp) ---
  static const Color primary = Color(0xFFF4F4F5); // Crisp White/Off-white for actions
  static const Color primaryDark = Color(0xFFD4D4D8);
  static const Color primaryglow = Color(0xFFFFFFFF);

  static const Color accent = Color(0xFFA1A1AA); // Neutral Zinc

  // --- Backgrounds ---
  static const Color backgroundDark = Color(0xFF121214); // Deep neutral charcoal/zinc
  static const Color surfaceDark = Color(0xFF18181B); // Surface
  static const Color glassLow = Color(0x0FFFFFFF);
  static const Color glassHigh = Color(0x1AFFFFFF);

  // --- Text ---
  static const Color textLight = Color(0xFFF4F4F5);
  static const Color textMuted = Color(0xFFA1A1AA);

  // --- Status Indicators (Calm & Balanced) ---
  static const Color success = Color(0xFF22C55E); // Balanced green
  static const Color warning = Color(0xFFEAB308); // Balanced amber
  static const Color error = Color(0xFFEF4444); // Balanced red
  static const Color info = Color(0xFF60A5FA); // Soft blue

  // --- Gradients ---
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF27272A), Color(0xFF18181B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppTheme {
  static ThemeData getLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF18181B),
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: const Color(0xFFFAFAFA),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF18181B),
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Color(0xFF18181B),
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFE4E4E7)),
        ),
        color: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF4F4F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE4E4E7)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE4E4E7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF18181B), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }

  static ThemeData getDarkTheme() {
    const colorScheme = ColorScheme.dark(
      primary: Color(0xFFF4F4F5),
      onPrimary: Color(0xFF121214),
      primaryContainer: Color(0xFF27272A),
      onPrimaryContainer: Color(0xFFF4F4F5),
      secondary: Color(0xFFA1A1AA),
      onSecondary: Color(0xFF18181B),
      secondaryContainer: Color(0xFF27272A),
      onSecondaryContainer: Color(0xFFE4E4E7),
      surface: Color(0xFF121214),
      onSurface: Color(0xFFF4F4F5),
      surfaceContainerLowest: Color(0xFF0C0C0E),
      surfaceContainerLow: Color(0xFF141416),
      surfaceContainer: Color(0xFF1E1E22),
      surfaceContainerHigh: Color(0xFF27272C),
      surfaceContainerHighest: Color(0xFF323238),
      outline: Color(0xFF2E2E34),
      outlineVariant: Color(0xFF383840),
      error: Color(0xFFEF4444),
      onError: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: colorScheme.surface,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: colorScheme.surfaceContainer,
        foregroundColor: colorScheme.onSurface,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
        color: colorScheme.surfaceContainer,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHigh.withValues(alpha: 0.4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
      ),
    );
  }
}
