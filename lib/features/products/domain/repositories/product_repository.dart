import '../entities/product_entity.dart';

abstract class ProductRepository {
  Future<List<ProductEntity>> getProducts({bool forceRefresh = false});
  Future<ProductEntity> getProductById(String id);
  Future<ProductEntity> addProduct(ProductEntity product);
  Future<ProductEntity> updateProduct(ProductEntity product);
  Future<bool> deleteProduct(String id);
}
