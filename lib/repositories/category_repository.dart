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
}
