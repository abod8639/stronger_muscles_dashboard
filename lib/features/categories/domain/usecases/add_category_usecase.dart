import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/category_entity.dart';
import '../repositories/category_repository.dart';

/// Pure Dart UseCase for creating a new category.
class AddCategoryUseCase {
  final CategoryRepository _repository;

  const AddCategoryUseCase(this._repository);

  Future<Either<Failure, CategoryEntity>> call(CategoryEntity category) {
    return _repository.addCategory(category);
  }
}
