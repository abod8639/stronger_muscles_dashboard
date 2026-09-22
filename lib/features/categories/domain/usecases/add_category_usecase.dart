import '../entities/category_entity.dart';
import '../repositories/category_repository.dart';

class AddCategoryUseCase {
  final CategoryRepository repository;

  AddCategoryUseCase(this.repository);

  Future<CategoryEntity> call(Map<String, dynamic> categoryData) async {
    return await repository.addCategory(categoryData);
  }
}
