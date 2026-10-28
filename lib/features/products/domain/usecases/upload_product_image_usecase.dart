import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../repositories/product_repository.dart';

class UploadProductImageUseCase {
  final ProductRepository repository;

  const UploadProductImageUseCase(this.repository);

  Future<Either<Failure, String>> call(String filePath) {
    return repository.uploadImage(filePath);
  }
}
