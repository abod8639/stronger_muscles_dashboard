import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/controllers/products_controller.dart';
import 'package:stronger_muscles_dashboard/screens/Products_Screen/widgets/CategoryItem.dart';

class ProductsCategoriesScreen extends GetView<ProductsController> {
  const ProductsCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final controller = Get.find<ProductsController>();
    final responsive = context.responsive;
    
    return SizedBox(
      height: 50,
      child: Obx(
        () {
          final categories = controller.categories;
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: responsive.defaultPadding.left),
            itemCount: categories.length + 1,
            itemBuilder: (context, index) {
              final isAll = index == 0;
              final id = isAll ? 'all' : categories[index - 1].id;
              final name = isAll ? 'الكل' : categories[index - 1].name;
              final isSelected = controller.selectedCategoryId.value == id;

              return CategoryItem(
                name: name,
                isSelected: isSelected,
                onTap: () => controller.setCategory(id),
                responsive: responsive,
              );
            },
          );
        },
      ),
    );
  }
}
