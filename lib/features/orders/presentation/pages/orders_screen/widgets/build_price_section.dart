import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';

/// قسم عرض السعر الإجمالي المتوافق بالكامل مع ألوان وثيم Material Design 3
Widget buildPriceSection(OrderEntity order) {
  return Builder(
    builder: (context) {
      final responsive = ResponsiveLayout(context);
      final theme = Theme.of(context);
      final colorScheme = theme.colorScheme;
      final isDark = theme.brightness == Brightness.dark;

      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: responsive.isDesktop ? 8 : 6,
        ),
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer.withValues(alpha: isDark ? 0.35 : 0.22),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.primary.withValues(alpha: 0.25),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'الإجمالي',
              style: theme.textTheme.labelSmall?.copyWith(
                fontSize: 10,
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  order.totalAmount.toStringAsFixed(2),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    letterSpacing: -0.5,
                  ) ??
                      TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                ),
                const SizedBox(width: 4),
                Text(
                  'ريال',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontSize: 11,
                    color: colorScheme.primary.withValues(alpha: 0.8),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
