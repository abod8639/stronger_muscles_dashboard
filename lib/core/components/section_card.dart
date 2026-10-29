import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/theme/responsive.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';
import 'package:stronger_muscles_dashboard/core/components/icon_card_with_shadow.dart';
import 'package:stronger_muscles_dashboard/core/components/soft_surface.dart';

/// بطاقة قسم موحدة (عنوان + أيقونة + محتوى) بتصميم Soft UI
/// تُستخدم في النماذج وصفحات التفاصيل
/// خالية من الأنيميشن وذات ظلال ناعمة وتدرج محدب متناسق مع الوضعين الداكن والفاتح
class SectionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Widget child;
  final Widget? trailing;

  /// حشوة المحتوى؛ مرّر EdgeInsets.zero للقوائم التي تملأ البطاقة
  final EdgeInsetsGeometry? padding;

  /// إبراز البطاقة بحد ولون primary (مثل بطاقة المعاينة الرئيسية)
  final bool highlighted;

  const SectionCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.child,
    this.trailing,
    this.padding,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return SoftSurface(
      selected: highlighted,
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
            padding:
                padding ??
                EdgeInsets.all(
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
