import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:stronger_muscles_dashboard/core/utils/components/base_app_bar.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/custom_search_bar.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/enhanced_loading_widget.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/generic_empty_state.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/horizontal_chips_selector.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/my_refresh_indicator.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/top_section.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/widgets/product_form_page.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/controllers/products_controller.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/widgets/product_list_item.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/widgets/product_bulk_actions_bar.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';


class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductsController>();
    final responsive = context.responsive;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: BaseAppBar(
        title: 'المنتجات',
        onPressed: () => Get.to(ProductFormPage()),
        icon: Icons.add,
        extraActions: [
          Obx(
            () => IconButton(
              icon: Icon(
                controller.isSelectionMode.value
                    ? Icons.checklist_rounded
                    : Icons.checklist_outlined,
                color: controller.isSelectionMode.value
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              tooltip: controller.isSelectionMode.value
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
              Obx(
                () => HorizontalChipsSelector(
                  items: controller.categories,
                  selectedId: controller.selectedCategoryId.value,
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
          Obx(() {
            if (controller.isSelectionMode.value) {
              return const ProductBulkActionsBar();
            }
            return const SizedBox.shrink();
          }),

          const SizedBox(height: 4),

          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.products.isEmpty) {
                return const EnhancedLoadingWidget(
                  message: 'جاري تحميل المنتجات...',
                );
              }

              if (controller.filteredProducts.isEmpty) {
                return GenericEmptyState(
                  title: 'لا توجد نتائج',
                  message:
                      controller.searchQuery.value.isEmpty &&
                              controller.selectedCategoryId.value == 'all'
                          ? 'قائمة المنتجات فارغة حالياً'
                          : 'لم نجد أي منتج يطابق بحثك: "${controller.searchQuery.value}"',
                  icon: Icons.search_off_rounded,
                  onAction: () => controller.fetchData(),
                  actionLabel: 'إعادة المحاولة',
                );
              }

              return MyRefreshIndicator(
                onRefresh: () => controller.fetchData(),
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.defaultPadding.left,
                    vertical: 10,
                  ),
                  itemCount: controller.filteredProducts.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final product = controller.filteredProducts[index];
                    return Obx(() {
                      final isSelected =
                          controller.isProductSelected(product.id);
                      final isSelectionMode =
                          controller.isSelectionMode.value;

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
                          product.id,
                          product.displayName,
                        ),
                      );
                    });
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
