import 'package:flutter/material.dart';

/// عمق السطح الناعم: بارز (بطاقات وأزرار) أو غائر (حقول وحاويات إدخال)
enum SoftDepth { raised, inset }

/// ثوابت التصميم المركزية للظلال، نسب الانحناء، والمسافات عبر التطبيق
class AppDesignTokens {
  // ── نسب الانحناء (Border Radii) ──────────────────────────────────────────
  static const double radiusSmallValue = 8.0;
  static const double radiusMediumValue = 12.0;
  static const double radiusCardValue = 16.0;
  static const double radiusLargeValue = 20.0;
  static const double radiusPillValue = 24.0;
  static const double radiusCircularValue = 999.0;

  static final BorderRadius radiusSmall = BorderRadius.circular(
    radiusSmallValue,
  );
  static final BorderRadius radiusMedium = BorderRadius.circular(
    radiusMediumValue,
  );
  static final BorderRadius radiusCard = BorderRadius.circular(radiusCardValue);
  static final BorderRadius radiusLarge = BorderRadius.circular(
    radiusLargeValue,
  );
  static final BorderRadius radiusPill = BorderRadius.circular(radiusPillValue);
  static final BorderRadius radiusCircular = BorderRadius.circular(
    radiusCircularValue,
  );

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

  static const EdgeInsets paddingScreen = EdgeInsets.symmetric(
    horizontal: 24,
    vertical: 20,
  );
  static const EdgeInsets paddingCard = EdgeInsets.all(16);
  static const EdgeInsets paddingCompact = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 8,
  );

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

  // ── السطح الناعم الموحد (Soft UI / Neumorphism) ────────────────────────────
  static const Color _lightShadow = Color(0xFFA3B1C6);

  /// زخرفة السطح الناعم الموحدة: تدرج + ظل سفلي + لمعة علوية + حد خفيف
  /// - [compact] للعناصر الصغيرة (شارات، أزرار أيقونات، شرائح)
  /// - [selected] لإبراز العنصر المحدد بلون primary
  static BoxDecoration softSurface(
    ColorScheme colorScheme, {
    required bool isDark,
    BorderRadius? borderRadius,
    SoftDepth depth = SoftDepth.raised,
    bool compact = false,
    bool selected = false,
  }) {
    final base = compact
        ? colorScheme.surfaceContainerHigh
        : colorScheme.surfaceContainer;

    final List<Color> colors;
    if (selected) {
      colors = isDark
          ? [
              Color.lerp(colorScheme.primaryContainer, Colors.white, 0.03)!,
              Color.lerp(
                colorScheme.surfaceContainer,
                colorScheme.primary,
                0.12,
              )!,
            ]
          : [
              Color.lerp(colorScheme.primaryContainer, Colors.white, 0.60)!,
              Color.lerp(colorScheme.primaryContainer, Colors.black, 0.03)!,
            ];
    } else if (depth == SoftDepth.inset) {
      colors = isDark
          ? [
              Color.lerp(
                colorScheme.surfaceContainerLowest,
                Colors.black,
                0.20,
              )!,
              Color.lerp(colorScheme.surfaceContainerLow, Colors.black, 0.10)!,
            ]
          : [
              Color.lerp(colorScheme.surface, _lightShadow, 0.08)!,
              Color.lerp(colorScheme.surface, Colors.white, 0.85)!,
            ];
    } else {
      colors = isDark
          ? [
              Color.lerp(base, Colors.white, 0.02)!,
              Color.lerp(base, Colors.black, compact ? 0.10 : 0.09)!,
            ]
          : [
              Colors.white,
              Color.lerp(colorScheme.surfaceContainerLow, Colors.black, 0.035)!,
            ];
    }

    final shadowOffset = compact ? const Offset(1.5, 2) : const Offset(3, 4);
    final highlightOffset = compact
        ? const Offset(-1.5, -1.5)
        : const Offset(-2.5, -2.5);

    return BoxDecoration(
      borderRadius: borderRadius ?? (compact ? radiusSmall : radiusLarge),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: colors,
      ),
      boxShadow: [
        BoxShadow(
          color: isDark
              ? Colors.black.withValues(alpha: compact ? 0.35 : 0.45)
              : _lightShadow.withValues(alpha: compact ? 0.30 : 0.40),
          offset: depth == SoftDepth.inset ? shadowOffset / 2 : shadowOffset,
          blurRadius: compact ? 3 : 10,
        ),
        BoxShadow(
          color: isDark
              ? Colors.white.withValues(alpha: 0.02)
              : Colors.white.withValues(alpha: compact ? 0.90 : 0.95),
          offset: highlightOffset,
          blurRadius: compact ? 2.5 : 8,
        ),
        if (selected)
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: isDark ? 0.20 : 0.22),
            offset: const Offset(0, 2),
            blurRadius: compact ? 4 : 12,
          ),
      ],
      border: Border.all(
        color: selected
            ? colorScheme.primary.withValues(alpha: isDark ? 0.70 : 0.85)
            : (isDark
                  ? Colors.white.withValues(alpha: 0.03)
                  : Colors.white.withValues(alpha: 0.85)),
        width: selected && !compact ? 1.6 : 1.0,
      ),
    );
  }
}
