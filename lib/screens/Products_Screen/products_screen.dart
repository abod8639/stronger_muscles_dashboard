import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/components/enhanced_error_widget.dart';
import 'package:stronger_muscles_dashboard/screens/Products_Screen/widgets/ProductListItem.dart';
import 'package:stronger_muscles_dashboard/screens/Products_Screen/widgets/ProductsCategoriesScreen.dart';
import '../../controllers/products_controller.dart';
import '../../config/theme.dart';
import '../../config/responsive.dart';
import '../../components/index.dart';

class ProductsScreen extends GetView<ProductsController> {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductsController());
    final responsive = context.responsive;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'إدارة المنتجات',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: responsive.getTitleFontSize() + 2,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Material(
              shape: const CircleBorder(),
              color: AppColors.primary.withValues(alpha: 0.1),
              child: IconButton(
                onPressed: () => controller.showProductForm(context),
                icon: Icon(
                  Icons.add_circle_outline,
                  size: responsive.iconSize + 2,
                  color: AppColors.primary,
                ),
                tooltip: 'إضافة منتج جديد',
              ),
            ),
          ),
          SizedBox(width: responsive.itemSpacing),
        ],
      ),
      body: Column(
        children: [
          // شريط البحث المحسّن
          Padding(
            padding: responsive.defaultPadding,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark 
                    ? Colors.white.withValues(alpha: 0.05) 
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark 
                      ? Colors.white10 
                      : Colors.grey.shade300
                ),
              ),
              child: TextField(
                onChanged: controller.onSearchChanged,
                decoration: const InputDecoration(
                  hintText: 'البحث عن منتج بالاسم أو الماركة...',
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Colors.grey),
                ),
              ),
            ),
          ),

          // اختيار التصنيفات المحسّن
          SizedBox(height: responsive.itemSpacing),

          ProductsCategoriesScreen(),

          SizedBox(height: responsive.itemSpacing),

          // قائمة المنتجات
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.products.isEmpty) {
                return const EnhancedLoadingWidget(
                  message: 'جاري تحميل المنتجات...',
                );
              }

              if (controller.filteredProducts.isEmpty) {
                return EnhancedErrorWidget(
                  title: 'لا توجد منتجات',
                  message:
                      controller.searchQuery.isEmpty &&
                          controller.selectedCategoryId.value == 'all'
                      ? 'لا يوجد منتجات حالياً'
                      : 'لم يتم العثور على نتائج للبحث',
                  icon: Icons.inventory_2_outlined,
                  onRetry: () => controller.fetchData(),
                  // onRetry: () => controller.fetchProducts(),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.only(
                  // top: responsive.itemSpacing / 2,
                  // bottom: responsive.itemSpacing * 2,
                ),
                itemCount: controller.filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = controller.filteredProducts[index];
                  return ProductListItem(
                    product: product,
                    index: index,
                    onEdit: () => 
                    controller.showProductForm(context, product: product),
                    onDelete: () => controller.confirmDelete(product.id, product.name),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }


}
