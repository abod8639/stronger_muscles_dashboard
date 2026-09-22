import '../entities/category_entity.dart';

abstract class CategoryRepository {
  Future<List<CategoryEntity>> getCategories({
    bool tree = false,
    bool forceRefresh = false,
  });
  Future<CategoryEntity> addCategory(Map<String, dynamic> categoryData);
  Future<CategoryEntity> updateCategory(String id, Map<String, dynamic> categoryData);
  Future<bool> deleteCategory(String id);
}
