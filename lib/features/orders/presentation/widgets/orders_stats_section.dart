import 'dart:math' as math;
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

    final cards = [
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
    ];

    // على الهواتف: عرض شريط أفقي انسيابي ومريح يوفر المساحة ويمنع التكدس
    if (res.isMobile) {
      final cardWidth = math.max(160.0, (res.screenWidth - 32 - 12) / 2.2);
      return SizedBox(
        height: 108,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          clipBehavior: Clip.none,
          itemCount: cards.length,
          separatorBuilder: (_, _) => const SizedBox(width: 10),
          itemBuilder: (context, index) {
            return SizedBox(
              width: cardWidth,
              child: cards[index],
            );
          },
        ),
      );
    }

    // على الأجهزة اللوحية والحواسب: شبكة أعمدة متناسقة
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: res.isDesktop ? 4 : 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        mainAxisExtent: 125,
      ),
      children: cards,
    );
  }
}
