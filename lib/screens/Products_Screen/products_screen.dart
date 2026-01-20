import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/components/enhanced_error_widget.dart';
import 'package:stronger_muscles_dashboard/screens/Products_Screen/widgets/ProductFormPage.dart';
import 'package:stronger_muscles_dashboard/screens/Products_Screen/widgets/ProductListItem.dart';
import 'package:stronger_muscles_dashboard/screens/Products_Screen/widgets/ProductsCategoriesScreen.dart';
import '../../controllers/products_controller.dart';
import '../../config/theme.dart';
import '../../config/responsive.dart';
import '../../components/index.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductsController());
    final responsive = context.responsive;

    return Scaffold(
      appBar: _buildAppBar(context, controller, responsive),
      body: Column(
        children: [
          _buildSearchBar(context, controller, responsive),
          
          const ProductsCategoriesScreen(),

          const SizedBox(height: 8),

          Expanded(
            child: Obx(() {
              // حالة التحميل الأولى
              if (controller.isLoading.value && controller.products.isEmpty) {
                return const EnhancedLoadingWidget(message: 'جاري تحميل المنتجات...');
              }

              // حالة عدم وجود بيانات
              if (controller.filteredProducts.isEmpty) {
                return _buildEmptyState(controller);
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
                      onEdit: () => controller.showProductForm(context, product: product),
                      onDelete: () => controller.confirmDelete(product.id, product.name),
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

  // --- مكونات الواجهة المنفصلة ---

  PreferredSizeWidget _buildAppBar(BuildContext context, ProductsController controller, var responsive) {
    return AppBar(
      elevation: 0,
      title: Text(
        'إدارة المنتجات',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: responsive.getTitleFontSize() + 2,
        ),
      ),
      centerTitle: true,
      actions: [
        _buildAddButton(context, controller, responsive),
        SizedBox(width: responsive.itemSpacing),
      ],
    );
  }

  Widget _buildAddButton(BuildContext context, ProductsController controller, var responsive) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        onPressed: () => Get.to(ProductFormPage()), //controller.showProductForm(context),
        icon: Icon(Icons.add_circle, size: responsive.iconSize + 4, color: AppColors.primary),
        tooltip: 'إضافة منتج جديد',
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, ProductsController controller, var responsive) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: responsive.defaultPadding,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade300),
        ),
        child: TextField(
          onChanged: controller.onSearchChanged,
          decoration: InputDecoration(
            hintText: 'البحث عن منتج بالاسم أو الماركة...',
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            suffixIcon: Obx(() => controller.searchQuery.isNotEmpty 
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 20),
                  onPressed: () {
                    // تحتاج لإضافة دالة clearSearch في الكنترولر
                    controller.onSearchChanged(''); 
                  },
                ) 
              : const SizedBox.shrink()),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(ProductsController controller) {
    return EnhancedErrorWidget(
      title: 'لا توجد نتائج',
      message: controller.searchQuery.isEmpty && controller.selectedCategoryId.value == 'all'
          ? 'قائمة المنتجات فارغة حالياً'
          : 'لم نجد أي منتج يطابق بحثك: "${controller.searchQuery.value}"',
      icon: Icons.search_off_rounded,
      onRetry: () => controller.fetchData(),
    );
  }
}