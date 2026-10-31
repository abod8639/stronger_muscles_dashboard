import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:stronger_muscles_dashboard/core/components/base_app_bar.dart';
import 'package:stronger_muscles_dashboard/core/components/custom_search_bar.dart';
import 'package:stronger_muscles_dashboard/core/components/enhanced_error_widget.dart';
import 'package:stronger_muscles_dashboard/core/components/enhanced_loading_widget.dart';
import 'package:stronger_muscles_dashboard/core/components/generic_empty_state.dart';
import 'package:stronger_muscles_dashboard/core/components/horizontal_chips_selector.dart';
import 'package:stronger_muscles_dashboard/core/components/my_refresh_indicator.dart';
import 'package:stronger_muscles_dashboard/core/components/responsive_list_view.dart';
import 'package:stronger_muscles_dashboard/core/components/top_section.dart';
import 'package:stronger_muscles_dashboard/core/theme/responsive.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/controllers/products_providers.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/widgets/product_bulk_actions_bar.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/widgets/product_card.dart';

/// شاشة عرض وإدارة المنتجات
/// ترتبط بـ Riverpod [productsControllerProvider] و [productsUIControllerProvider]
/// وتستخدم [AsyncValue.when] لعرض حالات التحميل والأخطاء بأمان
class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});

  /// أقصى عرض للمحتوى على الشاشات العريضة حتى لا تتمدد البطاقات بشكل مبالغ
  static const double _maxContentWidth = 1400;

  /// ارتفاع بطاقة المنتج في شبكة الحاسوب (مريح لمنع أي تجاوز رأسي عند طول النصوص)
  static const double _gridCardExtent = 215;

  Future<void> _refresh(WidgetRef ref) async {
    await Future.wait([
      ref
          .read(productsControllerProvider.notifier)
          .refreshProducts(forceRefresh: true),
      ref.read(productsUIControllerProvider).fetchData(forceRefresh: true),
    ]);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsControllerProvider);
    final controller = ref.watch(productsUIControllerProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: BaseAppBar(
        title: 'المنتجات',
        onPressed: () => _refresh(ref),
        extraActions: [
          ListenableBuilder(
            listenable: controller,
            builder: (context, _) => IconButton(
              icon: Icon(
                controller.isSelectionMode
                    ? Icons.checklist_rounded
                    : Icons.checklist_outlined,
                color: controller.isSelectionMode
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
              tooltip: controller.isSelectionMode
                  ? 'إلغاء وضع التحديد'
                  : 'تحديد متعدد',
              onPressed: () => controller.toggleSelectionMode(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'fab_products_add',
        onPressed: () => controller.showProductForm(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('منتج جديد'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _maxContentWidth),
          child: Column(
            children: [
              TopSection(
                children: [
                  CustomSearchBar(
                    hintText: 'ابحث عن منتج بالاسم أو الماركة...',
                    padding: context.responsive.defaultPadding,
                    onSearch: controller.onSearchChanged,
                  ),
                  ListenableBuilder(
                    listenable: controller,
                    builder: (context, _) => HorizontalChipsSelector(
                      items: controller.categories,
                      selectedId: controller.selectedCategoryId,
                      onSelect: controller.setCategory,
                      labelBuilder: (item) => item.displayName,
                    ),
                  ),
                ],
              ),

              // شريط الإجراءات الجماعية يظهر عند تفعيل وضع التحديد
              ListenableBuilder(
                listenable: controller,
                builder: (context, _) => controller.isSelectionMode
                    ? const ProductBulkActionsBar()
                    : const SizedBox.shrink(),
              ),

              Expanded(
                child: productsAsync.when(
                  loading: () => const EnhancedLoadingWidget(
                    message: 'جاري تحميل المنتجات...',
                  ),
                  error: (error, _) => EnhancedErrorWidget.fromError(
                    error,
                    fallbackTitle: 'حدث خطأ أثناء تحميل المنتجات',
                    onRetry: () => _refresh(ref),
                  ),
                  data: (_) => ListenableBuilder(
                    listenable: controller,
                    builder: (context, _) =>
                        _buildProductsList(context, ref, controller),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductsList(
    BuildContext context,
    WidgetRef ref,
    ProductsController controller,
  ) {
    if (controller.isLoading && controller.products.isEmpty) {
      return const EnhancedLoadingWidget(message: 'جاري تحميل المنتجات...');
    }

    final products = controller.filteredProducts;

    if (products.isEmpty) {
      final isSearching = controller.searchQuery.isNotEmpty;
      final isCategoryFiltered = controller.selectedCategoryId != 'all';

      // البحث يُمسح من زر المسح في شريط البحث نفسه، لذا لا نعرض إجراءً له هنا
      if (isSearching) {
        return GenericEmptyState(
          title: 'لا توجد نتائج',
          message: 'لم نجد أي منتج يطابق بحثك: "${controller.searchQuery}"',
          icon: Icons.search_off_rounded,
        );
      }

      return isCategoryFiltered
          ? GenericEmptyState(
              title: 'لا توجد نتائج',
              message: 'لا توجد منتجات في هذا القسم',
              icon: Icons.category_outlined,
              actionLabel: 'عرض كل المنتجات',
              onAction: () => controller.setCategory('all'),
            )
          : GenericEmptyState(
              title: 'لا توجد منتجات',
              message: 'قائمة المنتجات فارغة حالياً',
              icon: Icons.inventory_2_outlined,
              actionLabel: 'إضافة منتج',
              actionIcon: Icons.add_rounded,
              onAction: () => controller.showProductForm(context),
            );
    }

    final responsive = context.responsive;

    return MyRefreshIndicator(
      onRefresh: () => _refresh(ref),
      child: ResponsiveListView(
        itemCount: products.length,
        gridItemExtent: _gridCardExtent,
        // مساحة سفلية حتى لا يغطي الزر العائم آخر بطاقة
        padding: EdgeInsets.fromLTRB(
          responsive.defaultPadding.left,
          AppDesignTokens.space10,
          responsive.defaultPadding.right,
          96,
        ),
        itemBuilder: (context, index) {
          final product = products[index];
          final isSelectionMode = controller.isSelectionMode;

          return ProductCard(
            key: ValueKey(product.id),
            product: product,
            isSelectionMode: isSelectionMode,
            isSelected: controller.isProductSelected(product.id),
            onToggleSelect: () => controller.toggleProductSelection(product.id),
            onLongPress: () {
              if (!isSelectionMode) controller.toggleSelectionMode(true);
              controller.toggleProductSelection(product.id);
            },
            onEdit: () => controller.showProductForm(context, product: product),
            onDelete: () => controller.confirmDelete(
              context,
              product.id,
              product.displayName,
            ),
          );
        },
      ),
    );
  }
}
