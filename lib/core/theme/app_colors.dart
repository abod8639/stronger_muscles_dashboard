import 'package:flutter/material.dart';

class AppColorsExtended {
  // --- Minimal Monochrome Backgrounds (Eye-friendly Neutral Zinc/Charcoal) ---
  static const Color backgroundColor = Color(0xFF121214);
  static const Color darkBg = Color(0xFF121214);
  static const Color surfaceDark = Color(0xFF18181B);
  static const Color cardBg = Color(0xFF1E1E22);
  static const Color cardBgLight = Color(0xFF26262B);

  // --- Borders & Outlines ---
  static const Color borderColor = Color(0xFF2E2E34);
  static const Color borderColorLight = Color(0xFF383840);

  // --- Typography (Clean, high-legibility, zero glare) ---
  static const Color textPrimary = Color(0xFFF4F4F5);
  static const Color textSecondary = Color(0xFFA1A1AA);
  static const Color textMuted = Color(0xFF71717A);

  // --- Monochrome Accents ---
  static const Color purpleAccent = Color(0xFFE4E4E7);
  static const Color purpleDark = Color(0xFF27272A);
  static const Color purpleLight = Color(0xFFF4F4F5);

  static const Color orangeAccent = Color(0xFFF59E0B);
  static const Color orangeDark = Color(0xFFD97706);
  static const Color orangeLight = Color(0xFFFEF3C7);

  static const Color pinkAccent = Color(0xFFD4D4D8);
  static const Color pinkDark = Color(0xFF52525B);
  static const Color pinkLight = Color(0xFFF4F4F5);

  static const Color cyanAccent = Color(0xFFE4E4E7);
  static const Color cyanDark = Color(0xFF3F3F46);

  // --- Balanced, Eye-Friendly Status Colors ---
  static const Color greenAccent = Color(0xFF22C55E);
  static const Color greenLight = Color(0xFFDCFCE7);

  static const Color redAccent = Color(0xFFEF4444);
  static const Color redLight = Color(0xFFFEE2E2);

  // --- Subtle Gradients ---
  static LinearGradient purpleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      const Color(0xFF27272A),
      const Color(0xFF1E1E22),
    ],
  );

  static LinearGradient orangeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      const Color(0xFF27272A),
      const Color(0xFF1E1E22),
    ],
  );

  static LinearGradient pinkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      const Color(0xFF27272A),
      const Color(0xFF1E1E22),
    ],
  );

  // --- Subtle Shadows ---
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.2),
      blurRadius: 12,
      offset: const Offset(0, 3),
    ),
  ];

  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.12),
      blurRadius: 6,
      offset: const Offset(0, 2),
    ),
  ];
}
