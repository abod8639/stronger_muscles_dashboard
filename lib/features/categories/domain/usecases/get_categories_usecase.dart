import '../entities/category_entity.dart';
import '../repositories/category_repository.dart';

class GetCategoriesUseCase {
  final CategoryRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<List<CategoryEntity>> call({bool tree = true, bool forceRefresh = false}) async {
    return await repository.getCategories(tree: tree, forceRefresh: forceRefresh);
  }
}
