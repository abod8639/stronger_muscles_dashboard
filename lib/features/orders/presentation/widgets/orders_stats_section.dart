import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/premium_indicator_card.dart';
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
    final res = context.responsive;

    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: res.isDesktop ? 4 : 2,
        crossAxisSpacing: res.isMobile ? 10 : 14,
        mainAxisSpacing: res.isMobile ? 10 : 14,
        mainAxisExtent: res.isMobile ? 130 : 148,
      ),
      children: [
        PremiumIndicatorCard(
          title: 'إجمالي الطلبات',
          value: stats.totalOrders.toString(),
          trend: '+12%',
          trendUp: true,
          accentColor: Colors.blue,
          chartColor: Colors.blueAccent,
          icon: Icons.shopping_basket_rounded,
        ),
        PremiumIndicatorCard(
          title: 'قيد الانتظار',
          value: stats.pendingOrders.toString(),
          trend: '-2%',
          trendUp: false,
          accentColor: Colors.orange,
          chartColor: Colors.orangeAccent,
          icon: Icons.timer_rounded,
        ),
        PremiumIndicatorCard(
          title: 'تم التوصيل',
          value: stats.deliveredOrders.toString(),
          trend: '+5%',
          trendUp: true,
          accentColor: Colors.green,
          chartColor: Colors.greenAccent,
          icon: Icons.check_circle_rounded,
        ),
        PremiumIndicatorCard(
          title: 'الإيرادات',
          value: stats.totalRevenue.toStringAsFixed(0),
          trend: '+18%',
          trendUp: true,
          accentColor: Colors.purple,
          chartColor: Colors.purpleAccent,
          icon: Icons.payments_rounded,
        ),
      ],
    );
  }
}
