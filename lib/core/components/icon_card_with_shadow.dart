import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';

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
      decoration: AppDesignTokens.softSurface(
        colorScheme,
        isDark: isDark,
        compact: true,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Icon(icon, size: size, color: iconColor ?? colorScheme.primary),
    );
  }
}
