import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/controllers/products_controller.dart';
import 'package:stronger_muscles_dashboard/models/product_model.dart';

/// Mixin to handle common product form initialization logic
/// Eliminates code duplication between ProductFormPage and ProductFormSheet
mixin ProductFormMixin<T extends StatefulWidget> on State<T> {
  ProductsController get controller;
  ProductModel? get product;
  
  /// Initialize all text controllers and form state
  void initializeProductFields() {
    // Initialize text controllers
    controller.textcontrollers['name'] = TextEditingController(
      text: product?.name,
    );
    controller.textcontrollers['price'] = TextEditingController(
      text: product?.price.toString(),
    );
    controller.textcontrollers['discount'] = TextEditingController(
      text: product?.discountPrice?.toString(),
    );
    controller.textcontrollers['stock'] = TextEditingController(
      text: product?.stockQuantity.toString(),
    );
    controller.textcontrollers['desc'] = TextEditingController(
      text: product?.description,
    );
    controller.textcontrollers['brand'] = TextEditingController(
      text: product?.brand,
    );
    controller.textcontrollers['serving'] = TextEditingController(
      text: product?.servingSize,
    );
    controller.textcontrollers['sessions'] = TextEditingController(
      text: product?.servingsPerContainer.toString(),
    );

    // Initialize GetX reactive values
    controller.productFlavors.value = product?.flavor ?? [];
    controller.productSizes.value = product?.size ?? [];
    controller.isFeatured.value = product?.isActive ?? true;
    controller.isBackgroundWhite.value = product?.isBackgroundWhite ?? false;
  }

  /// Get the initial category ID
  String? getInitialCategoryId() {
    return product?.categoryId ??
        (controller.categories.isNotEmpty
            ? controller.categories.first.id
            : null);
  }

  /// Get the initial image URLs
  List<String> getInitialImageUrls() {
    return List<String>.from(product?.imageUrls ?? []);
  }

  /// Dispose all text controllers
  void disposeProductControllers() {
    controller.textcontrollers.forEach((_, c) => c.dispose());
  }
}
