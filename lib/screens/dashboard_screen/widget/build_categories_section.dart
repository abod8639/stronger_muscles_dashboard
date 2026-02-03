import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/controllers/dashboard_controller.dart';
import 'package:stronger_muscles_dashboard/models/category_model.dart';
import 'package:stronger_muscles_dashboard/screens/category_form_page/CategoryFormPage.dart';
import 'package:stronger_muscles_dashboard/screens/components/base_data_view.dart';
import 'package:stronger_muscles_dashboard/screens/components/category_card.dart';
import 'package:stronger_muscles_dashboard/controllers/navigation_controller.dart';

Widget buildCategoriesSection(ResponsiveLayout res) {
  final dashboardController = Get.find<DashboardController>();
  final navigationController = Get.find<NavigationController>();
  if (dashboardController.categories.isEmpty) return const SizedBox();
  return Builder(
    builder: (context) {
      return BaseDataView<CategoryModel>(
        title: 'التصنيفات',
        items: dashboardController.categories,
        onSeeAll: () => navigationController.changeIndex(1),
        itemBuilder: (context, category, index) => CategoryCard(
          category: category,
          index: index,
          onTap: () =>
          Get.to(() => CategoryFormPage( category: category ))
          //  handleCategoryTap(category),
        ),
      );
    },
  );
}
