import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/promo_entity.dart';
import '../repositories/promo_repository.dart';

/// Pure Dart use case for fetching promotional banners.
class GetPromosUseCase {
  final PromoRepository _repository;

  const GetPromosUseCase(this._repository);

  Future<Either<Failure, List<PromoEntity>>> call() {
    return _repository.getPromos();
  }
}
