import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/controllers/orders_controller.dart';
import 'package:stronger_muscles_dashboard/screens/components/premium_indicator_card.dart';

Widget buildStatsSection() {
  final controller = Get.find<OrdersController>();
  return Obx(() {
    if (controller.isLoading.value && controller.totalOrders == 0) {
      return const SizedBox.shrink();
    }
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      crossAxisSpacing: 10,
      // mainAxisSpacing: 10,
      childAspectRatio: 1.5,

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
          subtitle: 'SAR',
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
