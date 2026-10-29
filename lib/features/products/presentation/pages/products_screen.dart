import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:stronger_muscles_dashboard/core/theme/responsive.dart';
import 'package:stronger_muscles_dashboard/core/router/app_routes.dart';
import 'package:stronger_muscles_dashboard/core/components/base_app_bar.dart';
import 'package:stronger_muscles_dashboard/core/components/custom_search_bar.dart';
import 'package:stronger_muscles_dashboard/core/components/enhanced_loading_widget.dart';
import 'package:stronger_muscles_dashboard/core/components/generic_empty_state.dart';
import 'package:stronger_muscles_dashboard/core/components/horizontal_chips_selector.dart';
import 'package:stronger_muscles_dashboard/core/components/my_refresh_indicator.dart';
import 'package:stronger_muscles_dashboard/core/components/top_section.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/controllers/products_providers.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/widgets/product_bulk_actions_bar.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/widgets/product_list_item.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/widgets/products_error_card.dart';

/// شاشة عرض وإدارة المنتجات
/// ترتبط بـ Riverpod [productsControllerProvider] و [productsUIControllerProvider]
/// وتستخدم [AsyncValue.when] لعرض حالات التحميل والأخطاء بأمان
class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsControllerProvider);
    final controller = ref.watch(productsUIControllerProvider);
    final responsive = context.responsive;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: BaseAppBar(
        title: 'المنتجات',
        onPressed: () => context.push(AppRoutes.productForm),
        icon: Icons.add,
        extraActions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'تحديث المنتجات',
            onPressed: () {
              ref
                  .read(productsControllerProvider.notifier)
                  .refreshProducts(forceRefresh: true);
              controller.fetchData(forceRefresh: true);
            },
          ),
          ListenableBuilder(
            listenable: controller,
            builder: (context, _) => IconButton(
              icon: Icon(
                controller.isSelectionMode
                    ? Icons.checklist_rounded
                    : Icons.checklist_outlined,
                color: controller.isSelectionMode
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              tooltip: controller.isSelectionMode
                  ? 'إلغاء وضع التحديد'
                  : 'تحديد متعدد',
              onPressed: () => controller.toggleSelectionMode(),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          TopSection(
            children: [
              CustomSearchBar(
                hintText: 'ابحث عن منتج بالاسم أو الماركة...',
                padding: responsive.defaultPadding,
                onSearch: (value) => controller.onSearchChanged(value),
              ),
              ListenableBuilder(
                listenable: controller,
                builder: (context, _) => HorizontalChipsSelector(
                  items: controller.categories,
                  selectedId: controller.selectedCategoryId,
                  onSelect: (id) => controller.setCategory(id),
                  labelBuilder: (item) => item.displayName,
                  idKey: 'id',
                  showAllOption: true,
                  allLabel: 'الكل',
                ),
              ),
            ],
          ),

          // شريط الإجراءات الجماعية يظهر بسلاسة عند تفعيل وضع التحديد
          ListenableBuilder(
            listenable: controller,
            builder: (context, _) {
              if (controller.isSelectionMode) {
                return const ProductBulkActionsBar();
              }
              return const SizedBox.shrink();
            },
          ),

          const SizedBox(height: 4),

          Expanded(
            child: productsAsync.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: EnhancedLoadingWidget(
                    message: 'جاري تحميل المنتجات...',
                  ),
                ),
              ),
              error: (error, stackTrace) => Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ProductsErrorCard(
                    error: error,
                    onRetry: () {
                      ref
                          .read(productsControllerProvider.notifier)
                          .refreshProducts(forceRefresh: true);
                      controller.fetchData(forceRefresh: true);
                    },
                  ),
                ),
              ),
              data: (_) {
                return ListenableBuilder(
                  listenable: controller,
                  builder: (context, _) {
                    if (controller.isLoading && controller.products.isEmpty) {
                      return const EnhancedLoadingWidget(
                        message: 'جاري تحميل المنتجات...',
                      );
                    }

                    if (controller.filteredProducts.isEmpty) {
                      return GenericEmptyState(
                        title: 'لا توجد نتائج',
                        message:
                            controller.searchQuery.isEmpty &&
                                    controller.selectedCategoryId == 'all'
                                ? 'قائمة المنتجات فارغة حالياً'
                                : 'لم نجد أي منتج يطابق بحثك: "${controller.searchQuery}"',
                        icon: Icons.search_off_rounded,
                        onAction: () {
                          ref
                              .read(productsControllerProvider.notifier)
                              .refreshProducts(forceRefresh: true);
                          controller.fetchData(forceRefresh: true);
                        },
                        actionLabel: 'إعادة المحاولة',
                      );
                    }

                    return MyRefreshIndicator(
                      onRefresh: () async {
                        await ref
                            .read(productsControllerProvider.notifier)
                            .refreshProducts(forceRefresh: true);
                        await controller.fetchData(forceRefresh: true);
                      },
                      child: ListView.separated(
                        padding: EdgeInsets.symmetric(
                          horizontal: responsive.defaultPadding.left,
                          vertical: 10,
                        ),
                        itemCount: controller.filteredProducts.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final product = controller.filteredProducts[index];
                          final isSelected =
                              controller.isProductSelected(product.id);
                          final isSelectionMode = controller.isSelectionMode;

                          return ProductListItem(
                            product: product,
                            index: index,
                            isSelectionMode: isSelectionMode,
                            isSelected: isSelected,
                            onToggleSelect: () =>
                                controller.toggleProductSelection(product.id),
                            onLongPress: () {
                              if (!isSelectionMode) {
                                controller.toggleSelectionMode(true);
                              }
                              controller.toggleProductSelection(product.id);
                            },
                            onEdit: () => controller.showProductForm(
                              context,
                              product: product,
                            ),
                            onDelete: () => controller.confirmDelete(
                              context,
                              product.id,
                              product.displayName,
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
