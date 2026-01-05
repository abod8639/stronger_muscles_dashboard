import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/screens/Products_Screen/widgets/ProductFormSheet.dart';
import 'package:stronger_muscles_dashboard/screens/Products_Screen/widgets/ProductListItem.dart';
import '../../models/index.dart';
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
    final padding = responsive.defaultPadding;

    return Scaffold(
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
                onPressed: () => _showProductForm(context),
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

          // اختيار التصنيفات المحسّن
          SizedBox(height: responsive.itemSpacing),
          SizedBox(
            height: 50,
            child: Obx(
              () => ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: padding.left),
                itemCount: controller.categories.length + 1,
                itemBuilder: (context, index) {
                  final isAll = index == 0;
                  final category = isAll
                      ? null
                      : controller.categories[index - 1];
                  final id = isAll ? 'all' : category!.id;
                  final name = isAll ? 'الكل' : category!.name;
                  final isSelected = controller.selectedCategoryId.value == id;

                  return Padding(
                    padding: EdgeInsets.only(left: responsive.itemSpacing),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: isSelected
                            ? LinearGradient(
                                colors: [
                                  AppColors.primary.withValues(alpha: 0.8),
                                  AppColors.secondary.withValues(alpha: 0.6),
                                ],
                              )
                            : null,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => controller.setCategory(id),
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: padding.left,
                              vertical: padding.top / 3,
                            ),
                            child: Center(
                              child: Text(
                                name,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.textLight,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  fontSize: responsive.getBodyFontSize(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
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
                        _showProductForm(context, product: product),
                    onDelete: () => controller.deleteProduct(product.id),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showProductForm(
    BuildContext context,
     {
    ProductModel? product,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          ProductFormSheet( product: product),
    );
  }
}
