import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/base_data_view.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/category_card.dart';
import 'package:stronger_muscles_dashboard/features/categories/domain/entities/category_entity.dart';
import 'package:stronger_muscles_dashboard/features/categories/presentation/page/category_form_page/category_form_page.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:stronger_muscles_dashboard/features/navigation/presentation/controllers/navigation_controller.dart';

class CategoriesSummarySection extends GetView<DashboardController> {
  const CategoriesSummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    final res = context.responsive;
    final navigationController = Get.find<NavigationController>();

    return Obx(() {
      final categories = controller.stats.value.categories;
      if (categories.isEmpty) return const SizedBox();

      return BaseDataView<CategoryEntity>(
        title: 'التصنيفات',
        crossAxisCount: res.isDesktop ? 3 : 2,
        items: categories,
        onSeeAll: () => navigationController.changeIndex(1), // Categories index
        itemBuilder: (context, category, index) {
          return CategoryCard(
            category: category,
            index: index,
            onTap: () => Get.to(() => CategoryFormPage(category: category)),
          );
        },
      );
    });
  }
}
