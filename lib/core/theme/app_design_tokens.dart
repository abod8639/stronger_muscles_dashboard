import 'package:flutter/material.dart';

/// ثوابت التصميم المركزية للظلال، نسب الانحناء، والمسافات عبر التطبيق
class AppDesignTokens {
  // ── نسب الانحناء (Border Radii) ──────────────────────────────────────────
  static const double radiusSmallValue = 8.0;
  static const double radiusMediumValue = 12.0;
  static const double radiusCardValue = 16.0;
  static const double radiusLargeValue = 20.0;
  static const double radiusPillValue = 24.0;
  static const double radiusCircularValue = 999.0;

  static final BorderRadius radiusSmall = BorderRadius.circular(radiusSmallValue);
  static final BorderRadius radiusMedium = BorderRadius.circular(radiusMediumValue);
  static final BorderRadius radiusCard = BorderRadius.circular(radiusCardValue);
  static final BorderRadius radiusLarge = BorderRadius.circular(radiusLargeValue);
  static final BorderRadius radiusPill = BorderRadius.circular(radiusPillValue);
  static final BorderRadius radiusCircular = BorderRadius.circular(radiusCircularValue);

  // Convenient aliases
  static BorderRadius get borderRadiusSmall => radiusSmall;
  static BorderRadius get borderRadiusMedium => radiusMedium;
  static BorderRadius get borderRadiusCard => radiusCard;
  static BorderRadius get borderRadiusLarge => radiusLarge;
  static BorderRadius get borderRadiusPill => radiusPill;

  // ── المسافات والهوامش (Spacing & Padding) ──────────────────────────────────
  static const double space2 = 2.0;
  static const double space4 = 4.0;
  static const double space6 = 6.0;
  static const double space8 = 8.0;
  static const double space10 = 10.0;
  static const double space12 = 12.0;
  static const double space14 = 14.0;
  static const double space16 = 16.0;
  static const double space18 = 18.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;

  static const EdgeInsets paddingScreen = EdgeInsets.symmetric(horizontal: 24, vertical: 20);
  static const EdgeInsets paddingCard = EdgeInsets.all(16);
  static const EdgeInsets paddingCompact = EdgeInsets.symmetric(horizontal: 12, vertical: 8);

  // ── الظلال الموحدة (BoxShadows & Elevations) ───────────────────────────────
  static List<BoxShadow> subtleShadow(bool isDark) => [
        BoxShadow(
          color: isDark
              ? Colors.black.withValues(alpha: 0.3)
              : const Color(0xFFA3B1C6).withValues(alpha: 0.2),
          offset: const Offset(0, 2),
          blurRadius: 6,
        ),
      ];

  static List<BoxShadow> cardShadow(bool isDark) => [
        BoxShadow(
          color: isDark
              ? Colors.black.withValues(alpha: 0.45)
              : const Color(0xFFA3B1C6).withValues(alpha: 0.3),
          offset: const Offset(0, 4),
          blurRadius: 12,
        ),
      ];

  static List<BoxShadow> neumorphicRaised(bool isDark) => [
        BoxShadow(
          color: isDark
              ? Colors.black.withValues(alpha: 0.5)
              : const Color(0xFFA3B1C6).withValues(alpha: 0.35),
          offset: const Offset(4, 5),
          blurRadius: 10,
        ),
        BoxShadow(
          color: isDark
              ? Colors.white.withValues(alpha: 0.04)
              : Colors.white.withValues(alpha: 0.85),
          offset: const Offset(-3, -3),
          blurRadius: 8,
        ),
      ];
}
