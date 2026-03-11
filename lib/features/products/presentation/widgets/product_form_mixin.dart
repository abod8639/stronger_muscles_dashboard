import 'package:get/get.dart';
import '../controllers/products_controller.dart';
import '../../domain/entities/product_entity.dart';

mixin ProductFormMixin {
  ProductsController get controller;
  ProductEntity? get product;

  void initializeProductFields() {
    if (product != null) {
      controller.textcontrollers['name_ar']?.text = product!.nameAr;
      controller.textcontrollers['name_en']?.text = product!.nameEn;
      controller.textcontrollers['desc_ar']?.text = product!.descriptionAr;
      controller.textcontrollers['desc_en']?.text = product!.descriptionEn;
      controller.textcontrollers['price']?.text = product!.price.toString();
      controller.textcontrollers['discount']?.text =
          product!.discountPrice?.toString() ?? '';
      controller.textcontrollers['stock']?.text =
          product!.stockQuantity.toString();
      controller.textcontrollers['brand']?.text = product!.brand ?? '';
      controller.textcontrollers['serving']?.text = product!.servingSize ?? '';
      controller.textcontrollers['sessions']?.text =
          product!.servingsPerContainer?.toString() ?? '';

      controller.productFlavors.assignAll(product!.flavors ?? []);
      controller.isActive.value = product!.isActive;
      controller.isFeatured.value = product!.isFeatured;
      controller.isBackgroundWhite.value = product!.isBackgroundWhite ?? false;
      controller.productSizes.assignAll(product!.productSizes ?? []);
      controller.variants.assignAll(product!.variants ?? []);
    } else {
      _clearFields();
    }
  }

  void _clearFields() {
    controller.textcontrollers.forEach((_, c) => c.clear());
    controller.productFlavors.clear();
    controller.imageUrls.clear();
    controller.isActive.value = true;
    controller.isFeatured.value = false;
    controller.isBackgroundWhite.value = false;
    controller.productSizes.clear();
    controller.variants.clear();
    controller.clearSizeControllers();
  }

  List<String> getInitialImageUrls() => product?.imageUrls ?? [];
  String? getInitialCategoryId() => product?.categoryId;

  void disposeProductControllers() {
    // We don't necessarily want to dispose here if they are managed by the controller
    // but we can clear them if needed.
  }
}
