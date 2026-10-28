import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../repositories/product_repository.dart';

class DeleteProductUseCase {
  final ProductRepository repository;

  const DeleteProductUseCase(this.repository);

  Future<Either<Failure, bool>> call(String id) {
    return repository.deleteProduct(id);
  }
}