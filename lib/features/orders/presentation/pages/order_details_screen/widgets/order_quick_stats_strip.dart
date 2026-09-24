import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';

class _QuickStatData {
  final IconData icon;
  final String title;
  final String value;
  final Color? valueColor;
  final bool isBold;

  const _QuickStatData({
    required this.icon,
    required this.title,
    required this.value,
    this.valueColor,
    this.isBold = false,
  });
}

/// شريط الإحصائيات السريعة للطلب (الإجمالي، عدد العناصر، طريقة الدفع)
class OrderQuickStatsStrip extends StatelessWidget {
  final OrderEntity order;

  const OrderQuickStatsStrip({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isMobile = context.isMobile;

    final totalItems =
        order.items.fold<int>(0, (sum, item) => sum + item.quantity);

    final stats = [
      _QuickStatData(
        icon: Icons.payments_outlined,
        title: 'الإجمالي',
        value: '${order.totalAmount.toStringAsFixed(2)} ر.س',
        valueColor: colorScheme.primary,
        isBold: true,
      ),
      _QuickStatData(
        icon: Icons.shopping_bag_outlined,
        title: 'المنتجات',
        value:
            '$totalItems ${totalItems == 1 ? 'عنصر' : 'عناصر'} (${order.items.length} ${order.items.length == 1 ? 'منتج' : 'منتجات'})',
      ),
      _QuickStatData(
        icon: Icons.credit_card_outlined,
        title: 'طريقة الدفع',
        value: order.paymentMethod.isNotEmpty
            ? order.paymentMethod
            : 'غير محدد',
      ),
    ];

    if (isMobile) {
      return Column(
        children: stats
            .map((stat) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(stat.icon,
                          size: 15, color: colorScheme.onSurfaceVariant),
                      const SizedBox(width: 8),
                      Text(
                        '${stat.title}:',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        stat.value,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: stat.valueColor ?? colorScheme.onSurface,
                          fontWeight:
                              stat.isBold ? FontWeight.bold : FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      );
    }

    return Row(
      children: stats
          .map((stat) => Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(stat.icon,
                            size: 16, color: colorScheme.primary),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              stat.title,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              stat.value,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: stat.isBold
                                    ? FontWeight.bold
                                    : FontWeight.w600,
                                color: stat.valueColor ?? colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ))
          .toList(),
    );
  }
}
