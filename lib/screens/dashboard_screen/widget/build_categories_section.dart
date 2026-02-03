import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/controllers/dashboard_controller.dart';
import 'package:stronger_muscles_dashboard/screens/dashboard_screen/widget/categories_grid.dart';
// import 'package:stronger_muscles_dashboard/controllers/categories_controller.dart';
// import 'package:stronger_muscles_dashboard/screens/categories_screen/categories_screen.dart';

Widget buildCategoriesSection(ResponsiveLayout res) {
  final dashboardController = Get.find<DashboardController>();
  // final categorController = Get.find<CategoriesController>();

  if (dashboardController.categories.isEmpty) return const SizedBox();
  return Builder(
    builder: (context) {
      return CategoriesGrid(
        categories: dashboardController.categories,
        onSeeAll: () {
          debugPrint("=============onSeeAll==========");
        },
        // Get.to(CategoriesScreen())
        //       showCategoryForm(
        //         context,
        //         categorController,
        //         category: dashboardController.categories.first,
        //       ),
      );
    },
  );
}
