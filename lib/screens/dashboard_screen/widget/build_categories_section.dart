import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/controllers/dashboard_controller.dart';
import 'package:stronger_muscles_dashboard/screens/dashboard_screen/widget/categories_grid.dart';
import 'package:stronger_muscles_dashboard/controllers/navigation_controller.dart';

Widget buildCategoriesSection(ResponsiveLayout res) {
  final dashboardController = Get.find<DashboardController>();
  final navigationController = Get.find<NavigationController>();
  if (dashboardController.categories.isEmpty) return const SizedBox();
  return Builder(
    builder: (context) {
      return CategoriesGrid(
        categories: dashboardController.categories,
        title: 'التصنيفات',
        onSeeAll: () {
          navigationController.changeIndex(1);
        },
      );
    },
  );
}
