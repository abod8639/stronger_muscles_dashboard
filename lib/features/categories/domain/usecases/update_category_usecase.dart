import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/category_entity.dart';
import '../repositories/category_repository.dart';

/// Pure Dart UseCase for updating an existing category.
class UpdateCategoryUseCase {
  final CategoryRepository _repository;

  const UpdateCategoryUseCase(this._repository);

  Future<Either<Failure, CategoryEntity>> call(CategoryEntity category) {
    return _repository.updateCategory(category);
  }
}
