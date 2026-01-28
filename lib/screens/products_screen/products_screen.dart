import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/screens/components/top_section.dart';
import 'package:stronger_muscles_dashboard/screens/products_screen/widgets/ProductFormPage.dart';
import 'package:stronger_muscles_dashboard/screens/products_screen/widgets/ProductListItem.dart';
import 'package:stronger_muscles_dashboard/screens/products_screen/widgets/build_empty_state.dart';
import 'package:stronger_muscles_dashboard/screens/components/base_app_bar.dart';
import 'package:stronger_muscles_dashboard/screens/components/horizontal_chips_selector.dart';
import 'package:stronger_muscles_dashboard/screens/components/custom_search_bar.dart';
import '../../controllers/products_controller.dart';
import '../../config/responsive.dart';
import '../components/index.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductsController());
    final responsive = context.responsive;

    return Scaffold(
      backgroundColor: Colors.transparent,
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
                  // التعديل هنا: استدعاء الدالة التي تحتوي على منطق الفلترة
                  onSelect: (id) => controller.setCategory(id),
                  labelKey: 'name',
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
                return buildEmptyState(controller);
              }

              return RefreshIndicator(
                onRefresh: () => controller.fetchData(),
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.defaultPadding.left,
                    vertical: 10,
                  ),
                  itemCount: controller.filteredProducts.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final product = controller.filteredProducts[index];
                    return ProductListItem(
                      product: product,
                      index: index,
                      onEdit: () =>
                          controller.showProductForm(context, product: product),
                      onDelete: () =>
                          controller.confirmDelete(product.id, product.name),
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
