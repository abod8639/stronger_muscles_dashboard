import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository repository;

  const GetProductsUseCase(this.repository);

  Future<Either<Failure, List<ProductEntity>>> call({
    bool forceRefresh = false,
  }) {
    return repository.getProducts(forceRefresh: forceRefresh);
  }
}
