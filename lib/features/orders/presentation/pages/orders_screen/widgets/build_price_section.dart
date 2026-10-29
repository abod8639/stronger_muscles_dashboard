import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';

/// قسم عرض السعر الإجمالي المتوافق بالكامل مع ألوان وثيم Material Design 3 ومتجاوب بالكامل لمنع أي overflow
Widget buildPriceSection(OrderEntity order, {bool isCompact = false}) {
  return Builder(
    builder: (context) {
      final responsive = ResponsiveLayout(context);
      final theme = Theme.of(context);
      final colorScheme = theme.colorScheme;
      final isDark = theme.brightness == Brightness.dark;
      final isMobile = responsive.isMobile || isCompact;

      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 8 : 10,
          vertical: isMobile ? 4 : 6,
        ),
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer.withValues(
            alpha: isDark ? 0.35 : 0.22,
          ),
          borderRadius: BorderRadius.circular(10),
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
                fontSize: isMobile ? 9.5 : 10,
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerStart,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    order.totalAmount.toStringAsFixed(2),
                    style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w900,
                          fontSize: isMobile ? 15 : 17,
                          letterSpacing: -0.5,
                        ) ??
                        TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w900,
                          fontSize: isMobile ? 15 : 17,
                        ),
                  ),
                  const SizedBox(width: 3),
                  Text(
                    'ريال',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontSize: isMobile ? 9.5 : 10.5,
                      color: colorScheme.primary.withValues(alpha: 0.8),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
