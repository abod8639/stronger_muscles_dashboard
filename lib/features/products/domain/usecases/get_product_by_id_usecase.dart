import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class GetProductByIdUseCase {
  final ProductRepository repository;

  const GetProductByIdUseCase(this.repository);

  Future<Either<Failure, ProductEntity>> call(String id) {
    return repository.getProductById(id);
  }
}
