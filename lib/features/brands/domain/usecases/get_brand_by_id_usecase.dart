import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/brand_entity.dart';
import '../repositories/brand_repository.dart';

/// 100% Pure Dart UseCase for retrieving a single brand by ID.
class GetBrandByIdUseCase {
  final BrandRepository _repository;

  const GetBrandByIdUseCase(this._repository);

  Future<Either<Failure, BrandEntity>> call(String id) async {
    return await _repository.getBrandById(id);
  }
}
