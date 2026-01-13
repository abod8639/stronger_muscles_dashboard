import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/components/enhanced_error_widget.dart';
import 'package:stronger_muscles_dashboard/screens/Categories_Screen/widgets/CategoryFormSheet.dart';
import 'package:stronger_muscles_dashboard/screens/Categories_Screen/widgets/CategoryGridItem.dart';
import 'package:stronger_muscles_dashboard/screens/Categories_Screen/widgets/CategoryListItem.dart';
import '../../controllers/categories_controller.dart';
import '../../models/index.dart';
import '../../config/responsive.dart';
import '../../components/index.dart';
import '../../config/theme.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoriesController());
    final responsive = context.responsive;
    final padding = responsive.defaultPadding;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          'إدارة التصنيفات',
          style: TextStyle(
            fontSize: responsive.getTitleFontSize(),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _showCategoryForm(context, controller),
            icon: Icon(Icons.add_circle_outline, size: responsive.iconSize),
            tooltip: 'إضافة تصنيف جديد',
          ),
          SizedBox(width: responsive.itemSpacing),
        ],
      ),
      body: Column(
        children: [
          // شريط البحث المتطور
          Padding(
            padding: padding,
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: isDark ? 0.1 : 0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: TextField(
                onChanged: controller.onSearchChanged,
                cursorColor: AppColors.primary,
                style: TextStyle(
                  color: isDark ? Colors.white : AppColors.textDark,
                  fontSize: responsive.getBodyFontSize(),
                ),
                decoration: InputDecoration(
                  hintText: 'ابحث عن تصنيف بالاسم أو الكود...',
                  hintStyle: TextStyle(
                    color: isDark ? Colors.white54 : Colors.grey.shade400,
                    fontSize: responsive.getBodyFontSize(),
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: AppColors.primary.withValues(alpha: 0.7),
                    size: responsive.iconSize,
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: padding.left,
                    vertical: padding.top / 1.5,
                  ),
                ),
              ),
            ),
          ),

          // قائمة التصنيفات
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.categories.isEmpty) {
                return const EnhancedLoadingWidget(
                  message: 'جاري تحميل التصنيفات...',
                );
              }

              if (controller.filteredCategories.isEmpty) {
                return EnhancedErrorWidget(
                  title: 'لا توجد تصنيفات',
                  message: controller.searchQuery.isEmpty
                      ? 'لا يوجد تصنيفات متاحة حالياً'
                      : 'لم يتم العثور على نتائج للبحث',
                  icon: Icons.category_outlined,
                  onRetry: () => controller.fetchCategories(),
                );
              }

              return responsive.isMobile
                  ? ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: padding.left,
                        vertical: padding.top / 2,
                      ),
                      itemCount: controller.filteredCategories.length,
                      itemBuilder: (context, index) {
                        final category = controller.filteredCategories[index];
                        return CategoryListItem(
                          category: category,
                          index: index,
                          onEdit: () =>
                              _showCategoryForm(context, controller, category: category),
                          onDelete: () => controller.deleteCategory(category.id),
                        );
                      },
                    )
                  : GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: padding,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: responsive.isTablet ? 2 : 3,
                        crossAxisSpacing: responsive.itemSpacing,
                        mainAxisSpacing: responsive.itemSpacing,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: controller.filteredCategories.length,
                      itemBuilder: (context, index) {
                        final category = controller.filteredCategories[index];
                        return CategoryGridItem(
                          category: category,
                          onEdit: () =>
                              _showCategoryForm(context, controller, category: category),
                          onDelete: () => controller.deleteCategory(category.id),
                        );
                      },
                    );
            }),
          ),
        ],
      ),
    );
  }

  void _showCategoryForm(BuildContext context, CategoriesController controller, {CategoryModel? category}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CategoryFormSheet(
        controller: controller,
        category: category,
      ),
    );
  }
}
