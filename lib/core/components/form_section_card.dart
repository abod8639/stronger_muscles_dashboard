import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/theme/responsive.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';
import 'package:stronger_muscles_dashboard/core/components/icon_card_with_shadow.dart';
import 'package:stronger_muscles_dashboard/core/components/soft_surface.dart';

/// بطاقة حاوية لأقسام النماذج (عنوان + أيقونة + محتوى) بتصميم Soft UI
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

    return SoftSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 6,
            ),
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
            color: colorScheme.outlineVariant.withValues(
              alpha: isDark ? 0.25 : 0.4,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(
              context.isMobile
                  ? AppDesignTokens.space16
                  : AppDesignTokens.space20,
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}
