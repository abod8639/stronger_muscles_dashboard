import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/app_colors.dart';
import 'package:stronger_muscles_dashboard/screens/components/enhanced_loading_widget.dart';
import 'package:stronger_muscles_dashboard/screens/components/my_refreshIndicator.dart';
import 'package:stronger_muscles_dashboard/screens/components/top_section.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/widgets/product_form_page.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/widgets/product_list_item.dart';
import 'package:stronger_muscles_dashboard/screens/components/generic_empty_state.dart';
import 'package:stronger_muscles_dashboard/screens/components/base_app_bar.dart';
import 'package:stronger_muscles_dashboard/screens/components/horizontal_chips_selector.dart';
import 'package:stronger_muscles_dashboard/screens/components/custom_search_bar.dart';
import '../../controllers/products_controller.dart';
import '../../config/responsive.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductsController>();
    final responsive = context.responsive;

    return Scaffold(
      backgroundColor: AppColorsExtended.backgroundColor,

      //  Colors.transparent,
      appBar: BaseAppBar(
        title: 'المنتجات',
        onPressed: () => Get.to(ProductFormPage()),
        icon: Icons.add,
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

          const SizedBox(height: 8),

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
                    return ProductListItem(
                      product: product,
                      index: index,
                      onEdit: () =>
                          controller.showProductForm(context, product: product),
                      onDelete: () =>
                          controller.confirmDelete(product.id, product.name.ar),
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
