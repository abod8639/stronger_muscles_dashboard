import '../../data/repositories/product_repository.dart';

class UpdateProductUseCase {
  final ProductRepository repository;

  UpdateProductUseCase(this.repository);

  // Future<ProductEntity> call(ProductEntity product) async {
  //   return await repository.updateProduct(product);
  // }
}
