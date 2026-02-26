import 'package:flutter/material.dart';

class AppColorsExtended {
  // --- الألوان الأساسية (Primary Palette) ---
  static const Color darkBg = Color(
    0xFF0F0F1E,
  ); // خلفية داكنة جداً (almost black)
  static const Color surfaceDark = Color(0xFF1A1A2E); // سطح داكن
  static const Color cardBg = Color(0xFF16213E); // خلفية البطاقات
  static const Color cardBgLight = Color(0xFF1F2937); // خلفية بطاقة أفتح قليلاً

  // --- ألوان الحدود والفواصل ---
  static const Color borderColor = Color(0xFF2D3748); // حدود ناعمة
  static const Color borderColorLight = Color(0xFF3F4654);

  // --- ألوان النصوص ---
  static const Color textPrimary = Color(0xFFE8EAED); // نص أبيض
  static const Color textSecondary = Color(0xFFB0B3B8); // نص رمادي فاتح
  static const Color textMuted = Color(0xFF8A8D93); // نص رمادي داكن

  // --- ألوان الحالات ---
  // البنفسجي (Ethereum)
  static const Color purpleAccent = Color(0xFFB897EE);
  static const Color purpleDark = Color(0xFF7C3AED);
  static const Color purpleLight = Color(0xFFDDD6FE);

  // البرتقالي (BNB Chain)
  static const Color orangeAccent = Color(0xFFFBBF24);
  static const Color orangeDark = Color(0xFFF59E0B);
  static const Color orangeLight = Color(0xFFFED7AA);

  // الأحمر/الوردي (Polygon)
  static const Color pinkAccent = Color(0xFFF472B6);
  static const Color pinkDark = Color(0xFFEC4899);
  static const Color pinkLight = Color(0xFFFCE7F3);

  // الأزرق السماوي
  static const Color cyanAccent = Color(0xFF22D3EE);
  static const Color cyanDark = Color(0xFF06B6D4);

  // الأخضر
  static const Color greenAccent = Color(0xFF10B981);
  static const Color greenLight = Color(0xFFD1FAE5);

  // الأحمر
  static const Color redAccent = Color(0xFFEF4444);
  static const Color redLight = Color(0xFFFEE2E2);

  // --- Gradients ---
  static LinearGradient purpleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      purpleDark.withValues(alpha: 0.3),
      purpleAccent.withValues(alpha: 0.1),
    ],
  );

  static LinearGradient orangeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      orangeDark.withValues(alpha: 0.3),
      orangeAccent.withValues(alpha: 0.1),
    ],
  );

  static LinearGradient pinkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      pinkDark.withValues(alpha: 0.3),
      pinkAccent.withValues(alpha: 0.1),
    ],
  );

  // --- Shadows ---
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.3),
      blurRadius: 20,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];
}
