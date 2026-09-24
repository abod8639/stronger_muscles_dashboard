import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/base_app_bar.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/custom_search_bar.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/enhanced_error_widget.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/enhanced_loading_widget.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/my_refresh_indicator.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/top_section.dart';
import 'package:stronger_muscles_dashboard/features/categories/domain/entities/category_entity.dart';
import 'package:stronger_muscles_dashboard/features/categories/presentation/page/categories_screen/widgets/category_grid_card.dart';
import 'package:stronger_muscles_dashboard/features/categories/presentation/page/categories_screen/widgets/category_list_item.dart';
import 'package:stronger_muscles_dashboard/features/categories/presentation/page/category_form_page/category_form_page.dart';
import '../../controllers/categories_controller.dart';

/// شاشة استعراض وإدارة التصنيفات المتوافقة بالكامل مع Material Design 3
class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CategoriesController>();
    final responsive = context.responsive;
    final padding = responsive.defaultPadding;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: BaseAppBar(
        title: 'إدارة التصنيفات',
        onPressed: () => Get.to(() => const CategoryFormPage()),
        icon: Icons.add_circle_outline,
      ),
      body: Column(
        children: [
          TopSection(
            children: [
              CustomSearchBar(
                hintText: 'ابحث عن تصنيف بالاسم أو الكود...',
                padding: padding,
                onSearch: (value) => controller.onSearchChanged(value),
              ),
            ],
          ),
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

              final screenWidth = MediaQuery.sizeOf(context).width;

              if (responsive.isMobile) {
                // عرض قائمة الموبايل بنمط Material 3
                return MyRefreshIndicator(
                  onRefresh: () => controller.fetchCategories(),
                  child: ListView.builder(
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
                        onTap: () => Get.to(
                          () => CategoryFormPage(category: category),
                        ),
                        onEdit: () => Get.to(
                          () => CategoryFormPage(category: category),
                        ),
                        onDelete: () => controller.deleteCategory(category.id),
                      );
                    },
                  ),
                );
              }

              // عدد الأعمدة المتجاوب مع مقاسات الشاشات المختلفة
              final int crossAxisCount = screenWidth >= 1400
                  ? 5
                  : (screenWidth >= 1050
                      ? 4
                      : (screenWidth >= 700 ? 3 : 2));

              // عرض شبكي للمكتب والأجهزة اللوحية (Material 3 GridView)
              return MyRefreshIndicator(
                onRefresh: () => controller.fetchCategories(),
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: padding,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 1.05,
                  ),
                  itemCount: controller.filteredCategories.length,
                  itemBuilder: (context, index) {
                    final category = controller.filteredCategories[index];
                    return CategoryGridCard(
                      category: category,
                      onTap: () => Get.to(
                        () => CategoryFormPage(category: category),
                      ),
                      onEdit: () => Get.to(
                        () => CategoryFormPage(category: category),
                      ),
                      onDelete: () => controller.deleteCategory(category.id),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

/// فتح نموذج إنشاء أو تعديل التصنيف في صفحة كاملة متخصصة
void showCategoryForm(
  BuildContext context,
  CategoriesController controller, {
  CategoryEntity? category,
}) {
  Get.to(() => CategoryFormPage(category: category));
}
