import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/core/router/app_routes.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/base_app_bar.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/confirm_dialog.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/custom_search_bar.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/enhanced_error_widget.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/enhanced_loading_widget.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/my_refresh_indicator.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/top_section.dart';
import 'package:stronger_muscles_dashboard/core/utils/ui_feedback.dart';
import 'package:stronger_muscles_dashboard/features/auth/presentation/widgets/auth_error_card.dart';
import 'package:stronger_muscles_dashboard/features/categories/domain/entities/category_entity.dart';
import 'package:stronger_muscles_dashboard/features/categories/presentation/controllers/categories_providers.dart';
import 'package:stronger_muscles_dashboard/features/categories/presentation/controllers/categories_state.dart';
import 'package:stronger_muscles_dashboard/features/categories/presentation/page/categories_screen/widgets/category_grid_card.dart';
import 'package:stronger_muscles_dashboard/features/categories/presentation/page/categories_screen/widgets/category_list_item.dart';

/// Categories management and presentation screen.
/// Uses selective Riverpod listening via `.select(...)` to eliminate redundant rebuilds.
class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  void _confirmDelete(BuildContext context, WidgetRef ref, String categoryId) {
    showDialog(
      context: context,
      builder: (ctx) => ConfirmDialog(
        title: 'حذف التصنيف',
        message:
            'هل أنت متأكد من رغبتك في حذف هذا التصنيف؟ لا يمكن التراجع عن هذا الإجراء.',
        confirmText: 'حذف',
        confirmColor: AppColors.error,
        onConfirm: () async {
          Navigator.of(ctx).pop();
          final success = await ref
              .read(categoriesNotifierProvider.notifier)
              .deleteCategory(categoryId);
          if (success) {
            AppFeedback.showSuccess('تم حذف التصنيف بنجاح');
          } else {
            AppFeedback.showError('تعذر حذف التصنيف. قد يكون مرتبطاً بمنتجات.');
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(categoriesNotifierProvider.select((s) => s.status));
    final errorMessage = ref.watch(categoriesNotifierProvider.select((s) => s.errorMessage));
    final filteredCategories =
        ref.watch(categoriesNotifierProvider.select((s) => s.filteredCategories));
    final searchQuery = ref.watch(categoriesNotifierProvider.select((s) => s.searchQuery));

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
                onSearch: (value) => ref
                    .read(categoriesNotifierProvider.notifier)
                    .updateSearchQuery(value),
              ),
            ],
          ),
          Expanded(
            child: _buildBody(
              context: context,
              ref: ref,
              status: status,
              errorMessage: errorMessage,
              filteredCategories: filteredCategories,
              searchQuery: searchQuery,
              responsive: responsive,
              padding: padding,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody({
    required BuildContext context,
    required WidgetRef ref,
    required CategoriesStatus status,
    required String? errorMessage,
    required List<CategoryEntity> filteredCategories,
    required String searchQuery,
    required ResponsiveLayout responsive,
    required EdgeInsets padding,
  }) {
    if (status == CategoriesStatus.loading && filteredCategories.isEmpty) {
      return const EnhancedLoadingWidget(
        message: 'جاري تحميل التصنيفات...',
      );
    }

    if (status == CategoriesStatus.error && filteredCategories.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: AuthErrorCard(
              error: errorMessage ?? 'فشل في تحميل التصنيفات',
              onRetry: () => ref
                  .read(categoriesNotifierProvider.notifier)
                  .fetchCategories(forceRefresh: true),
              onDismiss: () => ref
                  .read(categoriesNotifierProvider.notifier)
                  .fetchCategories(forceRefresh: false),
            ),
          ),
        ),
      );
    }

    if (filteredCategories.isEmpty) {
      return EnhancedErrorWidget(
        title: 'لا توجد تصنيفات',
        message: searchQuery.isEmpty
            ? 'لا يوجد تصنيفات متاحة حالياً'
            : 'لم يتم العثور على نتائج للبحث',
        icon: Icons.category_outlined,
        onRetry: () => ref
            .read(categoriesNotifierProvider.notifier)
            .fetchCategories(forceRefresh: true),
      );
    }

    final screenWidth = MediaQuery.sizeOf(context).width;

    if (responsive.isMobile) {
      return MyRefreshIndicator(
        onRefresh: () => ref
            .read(categoriesNotifierProvider.notifier)
            .fetchCategories(forceRefresh: true),
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
              onDelete: () => _confirmDelete(context, ref, category.id),
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
          .read(categoriesNotifierProvider.notifier)
          .fetchCategories(forceRefresh: true),
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
            onDelete: () => _confirmDelete(context, ref, category.id),
          );
        },
      ),
    );
  }
}

/// Helper function to push CategoryFormPage.
void showCategoryForm(
  BuildContext context, {
  CategoryEntity? category,
}) {
  context.push(AppRoutes.categoryForm, extra: category);
}
