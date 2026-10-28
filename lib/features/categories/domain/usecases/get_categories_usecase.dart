import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/category_entity.dart';
import '../repositories/category_repository.dart';

/// Pure Dart UseCase for retrieving categories list or hierarchical tree.
class GetCategoriesUseCase {
  final CategoryRepository _repository;

  const GetCategoriesUseCase(this._repository);

  Future<Either<Failure, List<CategoryEntity>>> call({
    bool tree = false,
    bool forceRefresh = false,
  }) {
    return _repository.getCategories(tree: tree, forceRefresh: forceRefresh);
  }
}
