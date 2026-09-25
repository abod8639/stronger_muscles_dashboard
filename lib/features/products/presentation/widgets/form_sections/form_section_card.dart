import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/icon_card_with_shadow.dart';

/// بطاقة حاوية لأقسام استمارة المنتج بتصميم Neumorphism / Soft UI
/// خالية من الأنيميشن وذات ظلال ناعمة وتدرج محدب متناسق مع الوضعين الداكن والفاتح
class FormSectionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Widget child;
  final Widget? trailing;

  const FormSectionCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  Color.lerp(colorScheme.surfaceContainer, Colors.white, 0.02)!,
                  Color.lerp(colorScheme.surfaceContainer, Colors.black, 0.09)!,
                ]
              : [
                  Colors.white,
                  Color.lerp(colorScheme.surfaceContainerLow, Colors.black, 0.035)!,
                ],
        ),
        boxShadow: [
          // الظل السفلي الغامق للعمق (Drop Shadow)
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.45)
                : const Color(0xFFA3B1C6).withValues(alpha: 0.40),
            offset: const Offset(3, 4),
            blurRadius: 10,
          ),
          // الظل العلوي الفاتح العاكس للضوء (Highlight Glow)
          BoxShadow(
            color: isDark
                ? Colors.white.withValues(alpha: 0.02)
                : Colors.white.withValues(alpha: 0.95),
            offset: const Offset(-2.5, -2.5),
            blurRadius: 8,
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
        children: [
          // Header
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
            leading: IconCardWithShadow(icon: icon),
            title: Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            subtitle: subtitle != null
                ? Text(
                    subtitle!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  )
                : null,
            trailing: trailing,
          ),
          Divider(
            height: 1,
            color: colorScheme.outlineVariant.withValues(alpha: isDark ? 0.25 : 0.4),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: child,
          ),
        ],
      ),
    );
  }
}
