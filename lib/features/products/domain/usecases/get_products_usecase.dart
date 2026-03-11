import '../../data/repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository repository;

  const GetProductsUseCase(this.repository);

  // Future<List<ProductEntity>> call({bool forceRefresh = false}) async {
  //   return await repository.getProducts(forceRefresh: forceRefresh);
  // }
}
