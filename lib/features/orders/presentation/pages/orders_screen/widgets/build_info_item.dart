import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/components/icon_card_with_shadow.dart';

/// عنصر عرض المعلومات الإحصائية المصغرة المتوافق مع Material Design 3 ومتجاوب بالكامل لمنع أي overflow
Widget buildInfoItem({
  required IconData icon,
  required String label,
  required String sublabel,
  bool isCompact = false,
}) {
  return Builder(
    builder: (context) {
      final theme = Theme.of(context);
      final colorScheme = theme.colorScheme;

      return Row(
        children: [
          IconCardWithShadow(
            icon: icon,
            size: isCompact ? 14 : 16,
            padding: EdgeInsets.all(isCompact ? 6 : 7),
            borderRadius: 8,
          ),
          SizedBox(width: isCompact ? 6 : 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                    fontSize: isCompact ? 11 : 12,
                    height: 1.15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1),
                Text(
                  sublabel,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: isCompact ? 9 : 10,
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                    height: 1.1,
                  ),
                  maxLines: 1,
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
