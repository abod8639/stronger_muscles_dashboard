import '../repositories/product_repository.dart';

class DeleteProductUseCase {
  final ProductRepository repository;

  DeleteProductUseCase(this.repository);

  Future<bool> call(String id) async {
    return await repository.deleteProduct(id);
  }
}
