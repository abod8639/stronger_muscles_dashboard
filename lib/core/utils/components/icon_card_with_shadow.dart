import 'package:flutter/material.dart';

/// بطاقة الأيقونة بتصميم Neumorphism / Soft UI (بدون أنيميشن)
class IconCardWithShadow extends StatelessWidget {
  const IconCardWithShadow({
    super.key,
    required this.icon,
    this.size = 18,
    this.padding = const EdgeInsets.all(8),
    this.borderRadius = 10,
    this.iconColor,
  });

  final IconData? icon;
  final double size;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  Color.lerp(colorScheme.surfaceContainerHigh, Colors.white, 0.02)!,
                  Color.lerp(colorScheme.surfaceContainerHigh, Colors.black, 0.12)!,
                ]
              : [
                  Colors.white,
                  Color.lerp(colorScheme.surfaceContainerLow, Colors.black, 0.03)!,
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.40)
                : const Color(0xFFA3B1C6).withValues(alpha: 0.35),
            offset: const Offset(2, 2.5),
            blurRadius: 4,
          ),
          BoxShadow(
            color: isDark
                ? Colors.white.withValues(alpha: 0.02)
                : Colors.white.withValues(alpha: 0.90),
            offset: const Offset(-1.5, -1.5),
            blurRadius: 3,
          ),
        ],
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.02)
              : Colors.white.withValues(alpha: 0.85),
          width: 1.0,
        ),
      ),
      child: Icon(
        icon,
        size: size,
        color: iconColor ?? colorScheme.primary,
      ),
    );
  }
}
