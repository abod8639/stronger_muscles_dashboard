import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/core/network/api_service.dart';
import 'package:stronger_muscles_dashboard/core/storage/cache_service.dart';
import 'package:stronger_muscles_dashboard/features/categories/data/models/category_model.dart';
import 'package:stronger_muscles_dashboard/features/categories/domain/entities/category_entity.dart';



class CategoryRepository {
  final ApiService _apiService;
  late final CacheService _cacheService;

  static const String _cacheKeyCategories = 'categories_list';
  static const String _cacheKeyCategoriesTree = 'categories_tree';

  CategoryRepository(this._apiService) {
    _cacheService = Get.put(CacheService(), permanent: true);
  }

  Future<List<CategoryEntity>> getCategories({
    bool tree = false,
    bool forceRefresh = false,
  }) async {
    try {
      final cacheKey = tree ? _cacheKeyCategoriesTree : _cacheKeyCategories;

      if (forceRefresh) {
        _cacheService.remove(cacheKey);
      }

      // 1. Get from Cache
      try {
        final cachedData = _cacheService.get<dynamic>(cacheKey);
        if (cachedData != null && cachedData is List && !forceRefresh) {
          if (cachedData.isEmpty || cachedData.first is CategoryModel) {
            debugPrint('✓ تم استرجاع التصنيفات من الـ Cache');
            return (cachedData as List<CategoryModel>).map((m) => m.toEntity()).toList();
          } else {
            _cacheService.remove(cacheKey);
          }
        }
      } catch (e) {
        _cacheService.remove(cacheKey);
      }

      // 2. Fetch from Remote
      debugPrint('↓ جاري تحميل التصنيفات من الخادم (tree: $tree)...');
      final data = await _apiService.fetchCategories(tree: tree);
      
      final models = <CategoryModel>[];
      for (var item in data) {
        try {
          models.add(CategoryModel.fromJson(item as Map<String, dynamic>));
        } catch (e) {
          debugPrint('X خطأ في معالجة تصنيف واحد: $e');
        }
      }

      // 3. Save to Cache
      _cacheService.set(cacheKey, models, cacheDurationSeconds: 300);
      
      return models.map((m) => m.toEntity()).toList();
    } catch (e) {
      debugPrint('X خطأ فادح في CategoryRepository: $e');
      rethrow;
    }
  }

  Future<CategoryEntity> addCategory(Map<String, dynamic> categoryJson) async {
    try {
      final data = await _apiService.addCategory(categoryJson);
      _cacheService.remove(_cacheKeyCategories);
      _cacheService.remove(_cacheKeyCategoriesTree);
      return CategoryModel.fromJson(data).toEntity();
    } catch (e) {
      print('خطأ في إضافة التصنيف: $e');
      rethrow;
    }
  }

  Future<CategoryEntity> updateCategory(
    String id,
    Map<String, dynamic> categoryJson,
  ) async {
    try {
      final data = await _apiService.updateCategory(id, categoryJson);
      _cacheService.remove(_cacheKeyCategories);
      _cacheService.remove(_cacheKeyCategoriesTree);
      return CategoryModel.fromJson(data).toEntity();
    } catch (e) {
      print('خطأ في تحديث التصنيف: $e');
      rethrow;
    }
  }

  Future<bool> deleteCategory(String id) async {
    try {
      final result = await _apiService.deleteCategory(id);
      if (result) {
        _cacheService.remove(_cacheKeyCategories);
        _cacheService.remove(_cacheKeyCategoriesTree);
      }
      return result;
    } catch (e) {
      print('خطأ في حذف التصنيف في المستودع: $e');
      return false;
    }
  }
}
