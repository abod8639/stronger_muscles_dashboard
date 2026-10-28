import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../repositories/category_repository.dart';

/// Pure Dart UseCase for deleting a category by ID.
class DeleteCategoryUseCase {
  final CategoryRepository _repository;

  const DeleteCategoryUseCase(this._repository);

  Future<Either<Failure, Unit>> call(String id) {
    return _repository.deleteCategory(id);
  }
}
