import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/app_colors.dart';
import 'package:stronger_muscles_dashboard/screens/category_form_page/category_form_page.dart';
import 'package:stronger_muscles_dashboard/screens/components/enhanced_loading_widget.dart';
import 'package:stronger_muscles_dashboard/screens/components/my_refreshIndicator.dart';
import 'package:stronger_muscles_dashboard/screens/components/enhanced_error_widget.dart';
import 'package:stronger_muscles_dashboard/screens/components/top_section.dart';
import 'package:stronger_muscles_dashboard/screens/categories_screen/widgets/category_form_sheet.dart';
import 'package:stronger_muscles_dashboard/screens/components/generic_grid_card.dart';
import 'package:stronger_muscles_dashboard/screens/components/generic_list_card.dart';
import 'package:stronger_muscles_dashboard/screens/components/base_app_bar.dart';
import 'package:stronger_muscles_dashboard/screens/components/custom_search_bar.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import '../../controllers/categories_controller.dart';
import '../../data/models/index.dart';
import '../../config/responsive.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // استخدام Get.find() بدلاً من Get.put() لتجنب إنشاء instances جديدة
    final controller = Get.find<CategoriesController>();
    final responsive = context.responsive;
    final padding = responsive.defaultPadding;

    return Scaffold(
      backgroundColor:
            AppColorsExtended.darkBg.withAlpha(100),

      //  Colors.transparent,
      appBar: BaseAppBar(
        title: 'إدارة التصنيفات',
        onPressed: () => showCategoryForm(context, controller),
        icon: Icons.add_circle_outline,
      ),
      body: Column(
        children: [
          TopSection(
            children: [
              // شريط البحث المتطور
              CustomSearchBar(
                hintText: 'ابحث عن تصنيف بالاسم أو الكود...',
                padding: padding,
                onSearch: (value) => controller.onSearchChanged(value),
              ),
            ],
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
                  ? MyRefreshIndicator(
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
                          return GenericListCard<CategoryModel>(
                            title: category.displayName,
                            metadata: 'ID: ${category.id}',
                            imageUrl: category.imageUrl,
                            fallbackIcon: Icons.category_outlined,
                            statusWidget: !category.isActive
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.error.withValues(
                                        alpha: 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'معطل',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: AppColors.error,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                : null,
                            actions: [
                              ActionButtonConfig(
                                icon: Icons.edit_outlined,
                                color: Colors.blue,
                                onPressed: () => Get.to(
                                  () => CategoryFormPage(category: category),
                                ),
                              ),
                              ActionButtonConfig(
                                icon: Icons.delete_outline,
                                color: AppColors.error,
                                onPressed: () =>
                                    controller.deleteCategory(category.id),
                              ),
                            ],
                            onTap: () => Get.to(
                              () => CategoryFormPage(category: category),
                            ),
                            data: category,
                            index: index,
                          );
                        },
                      ),
                    )
                  : MyRefreshIndicator(
                      onRefresh: () => controller.fetchCategories(),
                      child: GridView.builder(
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
                          return GenericGridCard<CategoryModel>(
                            title: category.displayName,
                            imageUrl: category.imageUrl,
                            icon: Icons.category_rounded,
                            statusWidget: !category.isActive
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.error.withValues(
                                        alpha: 0.9,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'معطل',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                : null,
                            actions: [
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                onPressed: () =>
                                    controller.deleteCategory(category.id),
                                constraints: const BoxConstraints(
                                  minWidth: 32,
                                  minHeight: 32,
                                ),
                                padding: EdgeInsets.zero,
                              ),
                            ],
                            onTap: () => Get.to(
                              () => CategoryFormPage(category: category),
                            ),
                            data: category,
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

void showCategoryForm(
  BuildContext context,
  CategoriesController controller, {
  CategoryModel? category,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => CategoryFormSheet(category: category),
  );
}
