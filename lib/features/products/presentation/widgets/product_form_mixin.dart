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
      controller.textcontrollers['stock']?.text = product!.stockQuantity
          .toString();
      controller.textcontrollers['brand']?.text = product!.brand ?? '';
      controller.textcontrollers['serving']?.text = product!.servingSize ?? '';
      controller.textcontrollers['sessions']?.text =
          product!.servingsPerContainer?.toString() ?? '';

      controller.productFlavors.clear();
      controller.productFlavors.addAll(product!.flavors ?? []);
      controller.isActive = product!.isActive;
      controller.isFeatured = product!.isFeatured;
      controller.isBackgroundWhite = product!.isBackgroundWhite ?? false;
      controller.productSizes.clear();
      controller.productSizes.addAll(product!.productSizes ?? []);
      controller.variants.clear();
      controller.variants.addAll(product!.variants ?? []);
    } else {
      _clearFields();
    }
  }

  void _clearFields() {
    controller.textcontrollers.forEach((_, c) => c.clear());
    controller.productFlavors.clear();
    controller.imageUrls.clear();
    controller.isActive = true;
    controller.isFeatured = false;
    controller.isBackgroundWhite = false;
    controller.productSizes.clear();
    controller.variants.clear();
    controller.clearSizeControllers();
  }

  List<String> getInitialImageUrls() => product?.imageUrls ?? [];
  String? getInitialCategoryId() => product?.categoryId;

  void disposeProductControllers() {}
}
