import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/screens/Products_Screen/widgets/ProductFormSheet.dart';
import 'package:stronger_muscles_dashboard/screens/Products_Screen/widgets/ProductListItem.dart';
import '../../models/index.dart';
import '../../controllers/products_controller.dart';
import '../../config/theme.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductsController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة المنتجات'),
        actions: [
          IconButton(
            onPressed: () => _showProductForm(context, controller),
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'إضافة منتج جديد',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // شريط البحث
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: controller.onSearchChanged,
              decoration: InputDecoration(
                hintText: 'ابحث عن منتج بالاسم، الماركة، أو الكود...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),

          // اختيار القسم
          SizedBox(
            height: 50,
            child: Obx(() => ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: controller.categories.length + 1,
              itemBuilder: (context, index) {
                final isAll = index == 0;
                final category = isAll ? null : controller.categories[index - 1];
                final id = isAll ? 'all' : category!.id;
                final name = isAll ? 'الكل' : category!.name;
                final isSelected = controller.selectedCategoryId.value == id;

                return Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: FilterChip(
                    label: Text(name),
                    selected: isSelected,
                    onSelected: (selected) => controller.setCategory(id),
                    selectedColor: AppColors.primary.withOpacity(0.2),
                    checkmarkColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.primary : null,
                      fontWeight: isSelected ? FontWeight.bold : null,
                    ),
                  ),
                );
              },
            )),
          ),
          const SizedBox(height: 8),

          // قائمة المنتجات
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.products.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.filteredProducts.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        controller.searchQuery.isEmpty && controller.selectedCategoryId.value == 'all'
                            ? 'لا يوجد منتجات حالياً'
                            : 'لم يتم العثور على نتائج للبحث',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = controller.filteredProducts[index];
                  return ProductListItem(
                    product: product,
                    onEdit: () => _showProductForm(context, controller, product: product),
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

  void _showProductForm(BuildContext context, ProductsController controller, {ProductModel? product}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProductFormSheet(
        controller: controller,
        product: product,
      ),
    );
  }
}



