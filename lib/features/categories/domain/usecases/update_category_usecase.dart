import '../entities/category_entity.dart';
import '../repositories/category_repository.dart';

class UpdateCategoryUseCase {
  final CategoryRepository repository;

  UpdateCategoryUseCase(this.repository);

  Future<CategoryEntity> call(String id, Map<String, dynamic> categoryData) async {
    return await repository.updateCategory(id, categoryData);
  }
}
