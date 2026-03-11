import '../entities/product_entity.dart';

abstract class ProductRepository {
  Future<List<ProductEntity>> getProducts({bool forceRefresh = false});
  Future<ProductEntity> getProductById(String id);
  Future<ProductEntity> addProduct(Map<String, dynamic> productData);
  Future<ProductEntity> updateProduct(String id, Map<String, dynamic> productData);
  Future<bool> deleteProduct(String id);
  Future<String> uploadImage(String filePath);
}
