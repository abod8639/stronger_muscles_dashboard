import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';

/// شارة صغيرة (أيقونة + نص) لعرض تصنيف أو حالة بلون مميز
/// عند ترك [color] فارغاً تُستخدم ألوان السطح المحايدة من الثيم
class InfoPill extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? color;

  const InfoPill({super.key, required this.label, this.icon, this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final foreground = color ?? colorScheme.onSurfaceVariant;
    final background =
        color?.withValues(alpha: 0.15) ??
        colorScheme.surfaceContainerHighest.withValues(alpha: 0.5);
    final borderColor =
        color?.withValues(alpha: 0.3) ??
        colorScheme.outlineVariant.withValues(alpha: 0.3);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDesignTokens.space10,
        vertical: AppDesignTokens.space4,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppDesignTokens.radiusSmall,
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: foreground),
            const SizedBox(width: AppDesignTokens.space4),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                color: foreground,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
