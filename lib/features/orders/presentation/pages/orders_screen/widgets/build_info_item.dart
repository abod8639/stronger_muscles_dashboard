import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/icon_card_with_shadow.dart';

/// عنصر عرض المعلومات الإحصائية المصغرة المتوافق مع Material Design 3
Widget buildInfoItem({
  required IconData icon,
  required String label,
  required String sublabel,
}) {
  return Builder(
    builder: (context) {
      final theme = Theme.of(context);
      final colorScheme = theme.colorScheme;

      return Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          IconCardWithShadow(icon: icon),
          const SizedBox(width: 8),
          Flexible(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(width: 4),
                Text(
                  sublabel,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 10,
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}
