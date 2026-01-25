import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/components/animated_stat_card.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/controllers/dashboard_controller.dart';

class DashboardStatsGrid extends GetView<DashboardController> {
  const DashboardStatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final res = context.responsive;

    int crossAxisCount = 4;
    if (res.isMobile)
      crossAxisCount = 2;
    else if (res.isTablet)
      crossAxisCount = 3;

    return Obx(() {
      final List<Map<String, dynamic>> statsData = [
        {
          'title': 'إجمالي الإيرادات',
          'value': '${controller.totalRevenue.value.toStringAsFixed(0)} L.E',
          'icon': Icons.account_balance_wallet_rounded,
          'color': const Color(0xFF6366F1),
          'trend': true,
        },
        {
          'title': 'إجمالي الطلبات',
          'value': controller.totalOrders.value.toString(),
          'icon': Icons.shopping_cart_rounded,
          'color': const Color(0xFFF59E0B),
          'trend': true,
        },
        {
          'title': 'إجمالي المستخدمين',
          'value': controller.totalUsers.value.toString(),
          'icon': Icons.people_alt_rounded,
          'color': const Color(0xFF10B981),
          'trend': true,
        },
        {
          'title': 'إجمالي المنتجات',
          'value': controller.totalProducts.value.toString(),
          'icon': Icons.layers_rounded,
          'color': const Color(0xFF8B5CF6),
          'trend': false,
        },
      ];

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: res.defaultPadding.left),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: statsData.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: res.itemSpacing,
            mainAxisSpacing: res.itemSpacing,
            mainAxisExtent: res.isMobile ? 140 : 160,
          ),
          itemBuilder: (context, index) {
            final data = statsData[index];
            return AnimatedStatCard(
              title: data['title'],
              value: data['value'],
              icon: data['icon'],
              color: data['color'],
              showTrendIcon: data['trend'],
              isTrendPositive: index != 1,
            );
          },
        ),
      );
    });
  }
}
