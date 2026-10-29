import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/controllers/products_controller.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/widgets/flavor_multi_select.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/widgets/product_size_selector.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/widgets/product_variant_manager.dart';
import 'package:stronger_muscles_dashboard/core/components/form_section_card.dart';

/// قسم الخيارات والتنويعات (الأحجام، النكهات، ومصفوفة الـ SKU)
class ProductVariantsSection extends StatelessWidget {
  final ProductsController controller;

  const ProductVariantsSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return FormSectionCard(
      title: 'الأحجام والنكهات والتنويعات',
      subtitle: 'تحديد خيارات المنتج وربطها برمز SKU الخاص بالمخزن',
      icon: Icons.tune_rounded,
      child: ListenableBuilder(
        listenable: controller,
        builder: (context, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sizes Selector
            ProductSizeSelector(
              selectedSizes: controller.productSizes.toList(),
              selectedIndex: controller.selectedSizeIndex,
              onSelectSize: controller.selectSize,
              defaultPrice: double.tryParse(
                    controller.textcontrollers['price']?.text ?? '0',
                  ) ??
                  0.0,
              onSelectionChanged: (newList) {
                controller.productSizes
                  ..clear()
                  ..addAll(newList);
                controller.syncSizeControllers();
              },
            ),
            const SizedBox(height: 18),

            // Flavors Selector
            ProductFlavorSelector(
              selectedFlavors: controller.productFlavors.toList(),
              onSelectionChanged: (newList) {
                controller.updateProductFlavors(newList);
              },
            ),
            const SizedBox(height: 20),

            // SKU Variants Manager
            ProductVariantManager(controller: controller),
          ],
        ),
      ),
    );
  }
}
