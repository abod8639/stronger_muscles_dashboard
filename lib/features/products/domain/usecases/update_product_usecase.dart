import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class UpdateProductUseCase {
  final ProductRepository repository;

  const UpdateProductUseCase(this.repository);

  Future<Either<Failure, ProductEntity>> call(
    String id,
    Map<String, dynamic> productData,
  ) {
    return repository.updateProduct(id, productData);
  }
}
