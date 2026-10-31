import '../controllers/products_controller.dart';
import '../../domain/entities/product_entity.dart';

mixin ProductFormMixin {
  ProductsController get controller;
  ProductEntity? get product;

  void initializeProductFields() {
    controller.initForForm(product: product);
  }

  List<String> getInitialImageUrls() => product?.imageUrls ?? [];
  String? getInitialCategoryId() => product?.categoryId;

  void disposeProductControllers() {}
}
