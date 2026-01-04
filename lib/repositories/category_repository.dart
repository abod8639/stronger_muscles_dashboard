import '../models/index.dart';
import '../services/api_service.dart';

class CategoryRepository {
  final ApiService _apiService;

  CategoryRepository(this._apiService);

  Future<List<CategoryModel>> getCategories() async {
    try {
      final data = await _apiService.fetchCategories();
      return data
          .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('خطأ في CategoryRepository: $e');
      rethrow;
    }
  }

  Future<CategoryModel> addCategory(Map<String, dynamic> categoryJson) async {
    try {
      final data = await _apiService.addCategory(categoryJson);
      return CategoryModel.fromJson(data );
    } catch (e) {
      print('خطأ في إضافة التصنيف: $e');
      rethrow;
    }
  }

  Future<CategoryModel> updateCategory(String id, Map<String, dynamic> categoryJson) async {
    try {
      final data = await _apiService.updateCategory(id, categoryJson);
      return CategoryModel.fromJson(data);
    } catch (e) {
      print('خطأ في تحديث التصنيف: $e');
      rethrow;
    }
  }

  Future<bool> deleteCategory(String id) async {
    try {
      return await _apiService.deleteCategory(id);
    } catch (e) {
      print('خطأ في حذف التصنيف في المستودع: $e');
      return false;
    }
  }
}
