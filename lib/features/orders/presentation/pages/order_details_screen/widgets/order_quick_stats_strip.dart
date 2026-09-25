import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/icon_card_with_shadow.dart';
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

/// شريط الإحصائيات السريعة للطلب بتصميم Neumorphism / Soft UI (بدون أنيميشن)
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
    final isDark = theme.brightness == Brightness.dark;
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

    final tileDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark
            ? [
                Color.lerp(colorScheme.surfaceContainerHigh, Colors.white, 0.02)!,
                Color.lerp(colorScheme.surfaceContainerHigh, Colors.black, 0.12)!,
              ]
            : [
                Colors.white,
                Color.lerp(colorScheme.surfaceContainerLow, Colors.black, 0.03)!,
              ],
      ),
      boxShadow: [
        BoxShadow(
          color: isDark
              ? Colors.black.withValues(alpha: 0.35)
              : const Color(0xFFA3B1C6).withValues(alpha: 0.35),
          offset: const Offset(2, 2.5),
          blurRadius: 4,
        ),
        BoxShadow(
          color: isDark
              ? Colors.white.withValues(alpha: 0.02)
              : Colors.white.withValues(alpha: 0.90),
          offset: const Offset(-1.5, -1.5),
          blurRadius: 3,
        ),
      ],
      border: Border.all(
        color: isDark
            ? Colors.white.withValues(alpha: 0.03)
            : Colors.white.withValues(alpha: 0.85),
        width: 1.0,
      ),
    );

    if (isMobile) {
      return Column(
        children: stats
            .map((stat) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: tileDecoration,
                  child: Row(
                    children: [
                      IconCardWithShadow(
                        icon: stat.icon,
                        size: 16,
                        padding: const EdgeInsets.all(6),
                      ),
                      const SizedBox(width: 10),
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
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: tileDecoration,
                  child: Row(
                    children: [
                      IconCardWithShadow(icon: stat.icon),
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
                                fontWeight: FontWeight.w500,
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

