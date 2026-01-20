import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/controllers/products_controller.dart';

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

              return _CategoryItem(
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

class _CategoryItem extends StatelessWidget {
  final String name;
  final bool isSelected;
  final VoidCallback onTap;
  final ResponsiveLayout responsive; 

  const _CategoryItem({
    required this.name,
    required this.isSelected,
    required this.onTap,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.only(left: responsive.itemSpacing),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          border: isSelected 
              ? null 
              : Border.all(color: AppColors.textLight.withOpacity(0.2)),
          color: isSelected ? null : Colors.white.withOpacity(0.05),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 250),
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textLight,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: responsive.getTitleFontSize(),
                  fontFamily: 'Cairo', 
                ),
                child: Text(name),
              ),
            ),
          ),
        ),
      ),
    
    );
  }
}