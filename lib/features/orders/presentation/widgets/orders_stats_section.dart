import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/premium_indicator_card.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/controllers/orders_controller.dart';

class OrdersStatsSection extends GetView<OrdersController> {
  const OrdersStatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.totalOrders == 0) {
        return const SizedBox.shrink();
      }
      final res = context.responsive ;
      return GridView.count(
        
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: res.isDesktop ? 4 : 2,
        crossAxisSpacing: 10,
        childAspectRatio: 1.9,
        
        children: [
          PremiumIndicatorCard(
            title: 'إجمالي الطلبات',
            value: controller.totalOrders.toString(),
            trend: '+12%',
            trendUp: true,
            accentColor: Colors.blue,
            chartColor: Colors.blueAccent,
            icon: Icons.shopping_basket_rounded,
          ),
          PremiumIndicatorCard(
            title: 'قيد الانتظار',
            value: controller.pendingOrders.toString(),
            trend: '-2%',
            trendUp: false,
            accentColor: Colors.orange,
            chartColor: Colors.orangeAccent,
            icon: Icons.timer_rounded,
          ),
          PremiumIndicatorCard(
            title: 'تم التوصيل',
            value: controller.deliveredOrders.toString(),
            trend: '+5%',
            trendUp: true,
            accentColor: Colors.green,
            chartColor: Colors.greenAccent,
            icon: Icons.check_circle_rounded,
          ),
          PremiumIndicatorCard(
            title: 'الإيرادات',
            value: controller.totalRevenue.toStringAsFixed(0),
            // subtitle: 'SAR',
            trend: '+18%',
            trendUp: true,
            accentColor: Colors.purple,
            chartColor: Colors.purpleAccent,
            icon: Icons.payments_rounded,
          ),
        ],
      );
    });
  }
}
