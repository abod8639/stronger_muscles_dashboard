import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/core/components/price_text.dart';
import 'package:stronger_muscles_dashboard/core/components/soft_surface.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';
import 'package:stronger_muscles_dashboard/features/settings/settings_feature.dart';
import 'package:stronger_muscles_dashboard/core/theme/responsive.dart';
import 'package:stronger_muscles_dashboard/core/components/icon_card_with_shadow.dart';
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
class OrderQuickStatsStrip extends ConsumerWidget {
  final OrderEntity order;

  const OrderQuickStatsStrip({super.key, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isMobile = context.isMobile;

    final totalItems = order.items.fold<int>(
      0,
      (sum, item) => sum + item.quantity,
    );

    final stats = [
      _QuickStatData(
        icon: Icons.payments_outlined,
        title: 'الإجمالي',
        value: formatPrice(order.totalAmount, ref.watch(storeCurrencyProvider)),
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
            .map(
              (stat) => SoftSurface(
                compact: true,
                borderRadius: AppDesignTokens.radiusMedium,
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
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
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        stat.value,
                        textAlign: TextAlign.end,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: stat.valueColor ?? colorScheme.onSurface,
                          fontWeight: stat.isBold
                              ? FontWeight.bold
                              : FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      );
    }

    return Row(
      children: stats
          .map(
            (stat) => Expanded(
              child: SoftSurface(
                compact: true,
                borderRadius: AppDesignTokens.radiusMedium,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                margin: const EdgeInsets.symmetric(horizontal: 4),
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
            ),
          )
          .toList(),
    );
  }
}
