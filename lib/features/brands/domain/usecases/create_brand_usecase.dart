import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/brand_entity.dart';
import '../repositories/brand_repository.dart';

/// 100% Pure Dart UseCase for creating a new brand.
class CreateBrandUseCase {
  final BrandRepository _repository;

  const CreateBrandUseCase(this._repository);

  Future<Either<Failure, BrandEntity>> call(Map<String, dynamic> brandData) {
    return _repository.createBrand(brandData);
  }
}

