import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/components/icon_card_with_shadow.dart';

/// بطاقة قسم موحدة بنمط Bento Grid تجمع بين معايير Material Design 3 و Soft UI
class PromoSectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? subtitle;
  final Widget? trailing;
  final Widget child;
  final bool isHero;
  final EdgeInsetsGeometry contentPadding;

  const PromoSectionCard({
    super.key,
    required this.title,
    required this.icon,
    this.subtitle,
    this.trailing,
    required this.child,
    this.isHero = false,
    this.contentPadding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isHero
              ? colorScheme.primary.withValues(alpha: isDark ? 0.45 : 0.4)
              : colorScheme.outlineVariant.withValues(alpha: isDark ? 0.25 : 0.5),
          width: isHero ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: isHero ? 0.35 : 0.20)
                : (isHero
                    ? colorScheme.primary.withValues(alpha: 0.08)
                    : const Color(0xFFA3B1C6).withValues(alpha: 0.18)),
            offset: const Offset(0, 4),
            blurRadius: isHero ? 16 : 10,
          ),
          if (isHero)
            BoxShadow(
              color: isDark
                  ? colorScheme.primary.withValues(alpha: 0.08)
                  : colorScheme.primary.withValues(alpha: 0.04),
              offset: const Offset(0, 0),
              blurRadius: 20,
              spreadRadius: 1,
            ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ترويسة بطاقة Bento
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isHero
                  ? (isDark
                      ? colorScheme.primary.withValues(alpha: 0.08)
                      : colorScheme.primary.withValues(alpha: 0.04))
                  : colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
              border: Border(
                bottom: BorderSide(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                  width: 1.0,
                ),
              ),
            ),
            child: Row(
              children: [
                IconCardWithShadow(
                  icon: icon,
                  iconColor: isHero ? colorScheme.primary : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                          fontSize: 15,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: 8),
                  trailing!,
                ],
              ],
            ),
          ),

          // محتوى القسم
          Padding(
            padding: contentPadding,
            child: child,
          ),
        ],
      ),
    );
  }
}
