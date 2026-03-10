import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/config/api_config.dart';
import '../models/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getCategories({bool tree = false});
  Future<CategoryModel> addCategory(CategoryModel category);
  Future<CategoryModel> updateCategory(CategoryModel category);
  Future<bool> deleteCategory(String id);
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final Dio dio;

  CategoryRemoteDataSourceImpl(this.dio);

  @override
  Future<List<CategoryModel>> getCategories({bool tree = false}) async {
    final response = await dio.get(ApiConfig.adminCategories, queryParameters: {'tree': tree});
    if (response.statusCode == 200) {
      final List data = response.data;
      final categories = <CategoryModel>[];
      for (var item in data) {
        try {
          categories.add(CategoryModel.fromJson(item as Map<String, dynamic>));
        } catch (e) {
          print('X Error parsing category: $e');
          print('  Corrupted data: $item');
        }
      }
      return categories;
    }
    throw Exception('Failed to load categories');
  }

  @override
  Future<CategoryModel> addCategory(CategoryModel category) async {
    final response = await dio.post(ApiConfig.adminCategories, data: category.toJson());
    if (response.statusCode == 201 || response.statusCode == 200) {
      return CategoryModel.fromJson(response.data);
    }
    throw Exception('Failed to add category');
  }

  @override
  Future<CategoryModel> updateCategory(CategoryModel category) async {
    final response = await dio.put('${ApiConfig.adminCategories}/${category.id}', data: category.toJson());
    if (response.statusCode == 200) {
      return CategoryModel.fromJson(response.data);
    }
    throw Exception('Failed to update category');
  }

  @override
  Future<bool> deleteCategory(String id) async {
    final response = await dio.delete('${ApiConfig.adminCategories}/$id');
    return response.statusCode == 200 || response.statusCode == 204;
  }
}
