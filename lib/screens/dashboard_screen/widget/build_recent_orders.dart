import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/controllers/dashboard_controller.dart';
import 'package:stronger_muscles_dashboard/controllers/navigation_controller.dart';
import 'package:stronger_muscles_dashboard/screens/components/recent_orders_list.dart';

Widget buildRecentOrders(ResponsiveLayout res) {
  final controller = Get.find<DashboardController>();
  final navigationController = Get.put(NavigationController());

  return Builder(
    builder: (context) {
      return RecentOrdersList(
        orders: controller.orders.take(res.isMobile ? 3 : 6).toList(),
        onSeeAll: () {
          navigationController.changeIndex(3);
        },
      );
    },
  );
}
