import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/controllers/dashboard_controller.dart';
// import 'package:stronger_muscles_dashboard/screens/categories_screen/categories_screen.dart';
import 'package:stronger_muscles_dashboard/screens/components/recent_orders_list.dart';
// import 'package:stronger_muscles_dashboard/screens/orders_screen/orders_screen.dart';

Widget buildRecentOrders(ResponsiveLayout res) {
  final controller = Get.find<DashboardController>();
  // final categorController = Get.find<CategoriesController>();

  return Builder(
    builder: (context) {
      return RecentOrdersList(
        orders: controller.orders.take(res.isMobile ? 3 : 6).toList(),
        onSeeAll: () {},

      );
    },
  );
}
