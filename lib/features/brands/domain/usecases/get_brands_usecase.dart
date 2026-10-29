import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/brand_entity.dart';
import '../repositories/brand_repository.dart';

/// 100% Pure Dart UseCase for retrieving brands list.
class GetBrandsUseCase {
  final BrandRepository _repository;

  const GetBrandsUseCase(this._repository);

  Future<Either<Failure, List<BrandEntity>>> call({
    bool forceRefresh = false,
  }) async {
    return await _repository.getBrands(forceRefresh: forceRefresh);
  }
}
