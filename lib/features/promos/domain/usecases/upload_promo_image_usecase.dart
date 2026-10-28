import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../repositories/promo_repository.dart';

/// Pure Dart use case for uploading a promotional image.
class UploadPromoImageUseCase {
  final PromoRepository _repository;

  const UploadPromoImageUseCase(this._repository);

  Future<Either<Failure, String>> call(String filePath) {
    return _repository.uploadImage(filePath);
  }
}
