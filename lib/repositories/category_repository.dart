import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../models/index.dart';
import '../services/api_service.dart';
import '../services/cache_service.dart';

class CategoryRepository {
  final ApiService _apiService;
  late final CacheService _cacheService;

  static const String _cacheKeyCategories = 'categories_list';
  static const String _cacheKeyCategoriesTree = 'categories_tree';

  CategoryRepository(this._apiService) {
    _cacheService = Get.put(CacheService(), permanent: true);
  }

  Future<List<CategoryModel>> getCategories({bool tree = false}) async {
    try {
      final cacheKey = tree ? _cacheKeyCategoriesTree : _cacheKeyCategories;

      // معادلة cache أولاً
      final cachedData = _cacheService.get<List<CategoryModel>>(cacheKey);
      if (cachedData != null) {
        debugPrint('✓ تم استرجاع التصنيفات من الـ Cache');
        return cachedData;
      }

      debugPrint('↓ جاري تحميل التصنيفات من الخادم...');
      final data = await _apiService.fetchCategories(tree: tree);
      final categories = data
          .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
          .toList();

      // حفظ البيانات في الـ Cache لمدة 5 دقائق
      _cacheService.set(cacheKey, categories, cacheDurationSeconds: 300);
      return categories;
    } catch (e) {
      print('خطأ في CategoryRepository: $e');
      rethrow;
    }
  }

  Future<CategoryModel> addCategory(Map<String, dynamic> categoryJson) async {
    try {
      final data = await _apiService.addCategory(categoryJson);
      // تنظيف الـ Cache بعد إضافة تصنيف جديد
      _cacheService.remove(_cacheKeyCategories);
      _cacheService.remove(_cacheKeyCategoriesTree);
      debugPrint('✗ تم حذف Cache التصنيفات بعد إضافة تصنيف جديد');
      return CategoryModel.fromJson(data);
    } catch (e) {
      print('خطأ في إضافة التصنيف: $e');
      rethrow;
    }
  }

  Future<CategoryModel> updateCategory(
    String id,
    Map<String, dynamic> categoryJson,
  ) async {
    try {
      final data = await _apiService.updateCategory(id, categoryJson);
      // تنظيف الـ Cache بعد تحديث تصنيف
      _cacheService.remove(_cacheKeyCategories);
      _cacheService.remove(_cacheKeyCategoriesTree);
      debugPrint('✗ تم حذف Cache التصنيفات بعد تحديث تصنيف');
      return CategoryModel.fromJson(data);
    } catch (e) {
      print('خطأ في تحديث التصنيف: $e');
      rethrow;
    }
  }

  Future<bool> deleteCategory(String id) async {
    try {
      final result = await _apiService.deleteCategory(id);
      if (result) {
        // تنظيف الـ Cache بعد حذف تصنيف
        _cacheService.remove(_cacheKeyCategories);
        _cacheService.remove(_cacheKeyCategoriesTree);
        debugPrint('✗ تم حذف Cache التصنيفات بعد حذف تصنيف');
      }
      return result;
    } catch (e) {
      print('خطأ في حذف التصنيف في المستودع: $e');
      return false;
    }
  }
}
