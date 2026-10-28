import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../repositories/promo_repository.dart';

/// Pure Dart use case for deleting a promotional banner by ID.
class DeletePromoUseCase {
  final PromoRepository _repository;

  const DeletePromoUseCase(this._repository);

  Future<Either<Failure, Unit>> call(String id) {
    return _repository.deletePromo(id);
  }
}
