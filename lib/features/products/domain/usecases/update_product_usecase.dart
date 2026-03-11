import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class UpdateProductUseCase {
  final ProductRepository repository;

  UpdateProductUseCase(this.repository);

  Future<ProductEntity> call(String id, Map<String, dynamic> productData) async {
    return await repository.updateProduct(id, productData);
  }
}
