import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/screens/Products_Screen/widgets/ProductListItem.dart';
import 'package:stronger_muscles_dashboard/screens/Products_Screen/widgets/ProductsCategoriesScreen.dart';
import 'package:stronger_muscles_dashboard/screens/Products_Screen/widgets/build_app_bar.dart';
import 'package:stronger_muscles_dashboard/screens/Products_Screen/widgets/build_empty_state.dart';
import 'package:stronger_muscles_dashboard/screens/widgets/search_bar.dart';
import '../../controllers/products_controller.dart';
import '../../config/responsive.dart';
import '../../components/index.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductsController());
    final responsive = context.responsive;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: buildAppBar(context, controller, responsive),
      body: Column(
        children: [

          Search_Bar(
            hintText: 'ابحث عن منتج بالاسم أو الماركة...',
            padding: responsive.defaultPadding,
            isDark: true,
            controller: controller,
            responsive: responsive,
          ),

          const ProductsCategoriesScreen(),

          const SizedBox(height: 8),

          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.products.isEmpty) {
                return const EnhancedLoadingWidget(
                  message: 'جاري تحميل المنتجات...',
                );
              }

              // حالة عدم وجود بيانات
              if (controller.filteredProducts.isEmpty) {
                return buildEmptyState(controller);
              }

              // القائمة مع دعم "السحب للتحديث"
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
