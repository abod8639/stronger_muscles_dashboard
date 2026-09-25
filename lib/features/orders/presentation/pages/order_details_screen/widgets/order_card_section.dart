import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/icon_card_with_shadow.dart';

/// بطاقة السكشن بتصميم Neumorphism / Soft UI (بدون أنيميشن)
/// متوافقة ديناميكياً مع سمة التطبيق في الوضعين الفاتح والداكن بظلال ثنائية ناعمة وتدرج محدب مستمر.
class OrderCardSection extends StatelessWidget {
  final String? title;
  final IconData? icon;
  final Widget child;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;

  const OrderCardSection({
    super.key,
    this.title,
    this.icon,
    required this.child,
    this.trailing,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final borderRadius = BorderRadius.circular(20);

    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  Color.lerp(colorScheme.surfaceContainer, Colors.white, 0.02)!,
                  Color.lerp(colorScheme.surfaceContainer, Colors.black, 0.09)!,
                ]
              : [
                  Color.lerp(colorScheme.surfaceContainer, Colors.white, 0.70)!,
                  Color.lerp(colorScheme.surfaceContainer, Colors.black, 0.03)!,
                ],
        ),
        boxShadow: [
          // الظل السفلي الغامق (Drop Shadow)
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.55)
                : const Color(0xFFA3B1C6).withValues(alpha: 0.42),
            offset: const Offset(4, 6),
            blurRadius: 14,
            spreadRadius: 0,
          ),
          // الظل العلوي الفاتح العاكس للضوء (Highlight Glow)
          BoxShadow(
            color: isDark
                ? Colors.white.withValues(alpha: 0.02)
                : Colors.white.withValues(alpha: 0.95),
            offset: const Offset(-3, -3),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.03)
              : Colors.white.withValues(alpha: 0.85),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Row(
                children: [
                  if (icon != null) ...[
                    IconCardWithShadow(icon: icon),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Text(
                      title!,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  ?trailing,
                ],
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: colorScheme.outlineVariant.withValues(alpha: isDark ? 0.25 : 0.4),
            ),

          ],
           
          Padding(
            padding: padding ?? const EdgeInsets.all(18),
            child: child,
          ),
        ],
      ),
    );
  }
}
             
