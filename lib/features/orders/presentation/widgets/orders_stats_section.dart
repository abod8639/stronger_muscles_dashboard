import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/core/components/premium_indicator_card.dart';
import 'package:stronger_muscles_dashboard/core/components/price_text.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';
import 'package:stronger_muscles_dashboard/features/settings/settings_feature.dart';
import 'package:stronger_muscles_dashboard/core/components/responsive_stats_grid.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/controllers/orders_providers.dart';

class OrdersStatsSection extends ConsumerWidget {
  const OrdersStatsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(ordersStatsProvider);
    final ordersAsync = ref.watch(ordersControllerProvider);

    if (ordersAsync.isLoading && stats.totalOrders == 0) {
      return const SizedBox.shrink();
    }

    final currency = ref.watch(storeCurrencyProvider);
    final colorScheme = Theme.of(context).colorScheme;

    final cards = [
      PremiumIndicatorCard(
        title: 'إجمالي الطلبات',
        value: stats.totalOrders.toString(),
        accentColor: AppColors.info,
        icon: Icons.shopping_basket_rounded,
      ),
      PremiumIndicatorCard(
        title: 'قيد الانتظار',
        value: stats.pendingOrders.toString(),
        accentColor: AppColors.warning,
        icon: Icons.timer_rounded,
      ),
      PremiumIndicatorCard(
        title: 'تم التوصيل',
        value: stats.deliveredOrders.toString(),
        accentColor: AppColors.success,
        icon: Icons.check_circle_rounded,
      ),
      PremiumIndicatorCard(
        title: 'الإيرادات',
        value: formatPrice(stats.totalRevenue, currency),
        accentColor: colorScheme.primary,
        icon: Icons.payments_rounded,
      ),
    ];

    return ResponsiveStatsGrid(cards: cards);
  }
}
