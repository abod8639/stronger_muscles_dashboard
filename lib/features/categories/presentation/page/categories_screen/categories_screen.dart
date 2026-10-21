import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/core/router/app_routes.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/base_app_bar.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/confirm_dialog.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/custom_search_bar.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/enhanced_error_widget.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/enhanced_loading_widget.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/my_refresh_indicator.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/top_section.dart';
import 'package:stronger_muscles_dashboard/features/auth/presentation/widgets/auth_error_card.dart';
import 'package:stronger_muscles_dashboard/features/categories/domain/entities/category_entity.dart';
import 'package:stronger_muscles_dashboard/features/categories/presentation/controllers/categories_providers.dart';
import 'package:stronger_muscles_dashboard/features/categories/presentation/page/categories_screen/widgets/category_grid_card.dart';
import 'package:stronger_muscles_dashboard/features/categories/presentation/page/categories_screen/widgets/category_list_item.dart';

/// شاشة استعراض وإدارة التصنيفات المتوافقة بالكامل مع Material Design 3
/// والمعتمدة على Riverpod [AsyncValue.when] لمنع أي تجميد أو انهيار للشاشة
class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  void _confirmDelete(BuildContext context, WidgetRef ref, String categoryId) {
    Get.dialog(
      ConfirmDialog(
        title: 'حذف التصنيف',
        message:
            'هل أنت متأكد من رغبتك في حذف هذا التصنيف؟ لا يمكن التراجع عن هذا الإجراء.',
        confirmText: 'حذف',
        confirmColor: AppColors.error,
        onConfirm: () async {
          Get.back();
          final success = await ref
              .read(categoriesControllerProvider.notifier)
              .deleteCategory(categoryId);
          if (success) {
            Get.snackbar('نجاح', 'تم حذف التصنيف بنجاح');
          } else {
            Get.snackbar('خطأ', 'تعذر حذف التصنيف. قد يكون مرتبطاً بمنتجات.');
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesControllerProvider);
    final filteredCategories = ref.watch(filteredCategoriesProvider);
    final searchQuery = ref.watch(categoriesSearchQueryProvider);
    final responsive = context.responsive;
    final padding = responsive.defaultPadding;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: BaseAppBar(
        title: 'إدارة التصنيفات',
        onPressed: () => context.push(AppRoutes.categoryForm),
        icon: Icons.add_circle_outline,
      ),
      body: Column(
        children: [
          TopSection(
            children: [
              CustomSearchBar(
                hintText: 'ابحث عن تصنيف بالاسم أو الكود...',
                padding: padding,
                onSearch: (value) =>
                    ref.read(categoriesSearchQueryProvider.notifier).setQuery(value),
              ),
            ],
          ),
          Expanded(
            child: categoriesAsync.when(
              loading: () => const EnhancedLoadingWidget(
                message: 'جاري تحميل التصنيفات...',
              ),
              error: (error, stackTrace) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: AuthErrorCard(
                      error: error,
                      onRetry: () => ref
                          .read(categoriesControllerProvider.notifier)
                          .refreshCategories(forceRefresh: true),
                      onDismiss: () => ref
                          .read(categoriesControllerProvider.notifier)
                          .clearError(),
                    ),
                  ),
                ),
              ),
              data: (_) {
                if (filteredCategories.isEmpty) {
                  return EnhancedErrorWidget(
                    title: 'لا توجد تصنيفات',
                    message: searchQuery.isEmpty
                        ? 'لا يوجد تصنيفات متاحة حالياً'
                        : 'لم يتم العثور على نتائج للبحث',
                    icon: Icons.category_outlined,
                    onRetry: () => ref
                        .read(categoriesControllerProvider.notifier)
                        .refreshCategories(forceRefresh: true),
                  );
                }

                final screenWidth = MediaQuery.sizeOf(context).width;

                if (responsive.isMobile) {
                  return MyRefreshIndicator(
                    onRefresh: () => ref
                        .read(categoriesControllerProvider.notifier)
                        .refreshCategories(forceRefresh: true),
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: padding.left,
                        vertical: padding.top / 2,
                      ),
                      itemCount: filteredCategories.length,
                      itemBuilder: (context, index) {
                        final category = filteredCategories[index];
                        return CategoryListItem(
                          category: category,
                          onTap: () => context.push(
                            AppRoutes.categoryForm,
                            extra: category,
                          ),
                          onEdit: () => context.push(
                            AppRoutes.categoryForm,
                            extra: category,
                          ),
                          onDelete: () =>
                              _confirmDelete(context, ref, category.id),
                        );
                      },
                    ),
                  );
                }

                final int crossAxisCount = screenWidth >= 1400
                    ? 5
                    : (screenWidth >= 1050
                        ? 4
                        : (screenWidth >= 700 ? 3 : 2));

                return MyRefreshIndicator(
                  onRefresh: () => ref
                      .read(categoriesControllerProvider.notifier)
                      .refreshCategories(forceRefresh: true),
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: padding,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 1.05,
                    ),
                    itemCount: filteredCategories.length,
                    itemBuilder: (context, index) {
                      final category = filteredCategories[index];
                      return CategoryGridCard(
                        category: category,
                        onTap: () => context.push(
                          AppRoutes.categoryForm,
                          extra: category,
                        ),
                        onEdit: () => context.push(
                          AppRoutes.categoryForm,
                          extra: category,
                        ),
                        onDelete: () =>
                            _confirmDelete(context, ref, category.id),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// فتح نموذج إنشاء أو تعديل التصنيف في صفحة كاملة متخصصة
void showCategoryForm(
  BuildContext context, {
  CategoryEntity? category,
}) {
  context.push(AppRoutes.categoryForm, extra: category);
}
