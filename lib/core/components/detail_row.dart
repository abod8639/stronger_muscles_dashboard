import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/components/icon_card_with_shadow.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';

/// صف تفاصيل موحد: أيقونة اختيارية + عنوان + قيمة (أو عنصر مخصص في نهاية الصف)
class DetailRow extends StatelessWidget {
  final IconData? icon;
  final String label;
  final String value;
  final Widget? trailing;

  const DetailRow({
    super.key,
    this.icon,
    required this.label,
    required this.value,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDesignTokens.space8),
      child: Row(
        children: [
          if (icon != null) ...[
            IconCardWithShadow(icon: icon, size: 16),
            const SizedBox(width: AppDesignTokens.space12),
          ],
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: AppDesignTokens.space12),
          Expanded(
            flex: 5,
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child:
                  trailing ??
                  SelectableText(
                    value,
                    textAlign: TextAlign.end,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
