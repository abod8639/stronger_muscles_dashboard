import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/promo_entity.dart';
import '../repositories/promo_repository.dart';

/// Pure Dart use case for adding a new promotional banner.
class AddPromoUseCase {
  final PromoRepository _repository;

  const AddPromoUseCase(this._repository);

  Future<Either<Failure, PromoEntity>> call(PromoEntity promo) {
    return _repository.addPromo(promo);
  }
}
