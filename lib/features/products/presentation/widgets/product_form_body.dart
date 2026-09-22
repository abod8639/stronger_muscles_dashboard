import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/controllers/products_controller.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/widgets/product_form_sections.dart';

class ProductFormBody extends StatelessWidget {
  final ProductsController controller;
  final List<String> imageUrls;
  final void Function(String url) onAddImageUrl;
  final void Function(int index) onRemoveImage;
  final void Function(int oldIdx, int newIdx) onReorderImage;
  final String? selectedCategoryId;
  final void Function(String id) onCategorySelected;

  const ProductFormBody({
    super.key,
    required this.controller,
    required this.imageUrls,
    required this.onAddImageUrl,
    required this.onRemoveImage,
    required this.onReorderImage,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. قسم صور المنتج
        ProductMediaSection(
          controller: controller,
          imageUrls: imageUrls,
          onAddImageUrl: onAddImageUrl,
          onRemoveImage: onRemoveImage,
          onReorderImage: onReorderImage,
        ),
        const SizedBox(height: 20),

        // 2. قسم البيانات الأساسية
        ProductBasicInfoSection(
          controller: controller,
          selectedCategoryId: selectedCategoryId,
          onCategorySelected: onCategorySelected,
        ),
        const SizedBox(height: 20),

        // 3. قسم التسعير والمخزون
        ProductPricingStockSection(controller: controller),
        const SizedBox(height: 20),

        // 4. قسم الخيارات والتنويعات
        ProductVariantsSection(controller: controller),
        const SizedBox(height: 20),

        // 5. قسم إعدادات النشر والعرض
        ProductSettingsSection(controller: controller),
      ],
    );
  }
}
