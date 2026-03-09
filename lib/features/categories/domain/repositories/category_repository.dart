import '../entities/category_entity.dart';

abstract class CategoryRepository {
  Future<List<CategoryEntity>> getCategories({bool tree = false});
  Future<CategoryEntity> addCategory(CategoryEntity category);
  Future<CategoryEntity> updateCategory(CategoryEntity category);
  Future<bool> deleteCategory(String id);
}
