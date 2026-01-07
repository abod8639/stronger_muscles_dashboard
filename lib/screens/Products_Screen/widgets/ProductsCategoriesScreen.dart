
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/controllers/products_controller.dart';

class ProductsCategoriesScreen extends GetView<ProductsController> {
  const ProductsCategoriesScreen({ super.key });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final padding = responsive.defaultPadding;
    return SizedBox(
      height: 50,
      child: Obx(
        () => ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: padding.left),
          itemCount: controller.categories.length + 1,
          itemBuilder: (context, index) {
            final isAll = index == 0;
            final category = isAll
                ? null
                : controller.categories[index - 1];
            final id = isAll ? 'all' : category!.id;
            final name = isAll ? 'الكل' : category!.name;
            final isSelected = controller.selectedCategoryId.value == id;
    
            return Padding(
              padding: EdgeInsets.only(left: responsive.itemSpacing),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: isSelected
                      ? LinearGradient(
                          colors: [
                            AppColors.primary.withValues(alpha: 0.8),
                            AppColors.primary.withValues(alpha: 0.6),
                          ],
                        )
                      : null,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => controller.setCategory(id),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: padding.left,
                        vertical: padding.top / 3,
                      ),
                      child: Center(
                        child: Text(
                          name,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : AppColors.textLight,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                            fontSize: responsive.getTitleFontSize(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
