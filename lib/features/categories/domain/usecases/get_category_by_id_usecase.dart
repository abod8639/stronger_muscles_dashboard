import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/category_entity.dart';
import '../repositories/category_repository.dart';

/// Pure Dart UseCase for retrieving a single category by ID.
class GetCategoryByIdUseCase {
  final CategoryRepository _repository;

  const GetCategoryByIdUseCase(this._repository);

  Future<Either<Failure, CategoryEntity>> call(String id) {
    return _repository.getCategoryById(id);
  }
}
