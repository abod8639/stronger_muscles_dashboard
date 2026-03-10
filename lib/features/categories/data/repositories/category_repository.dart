import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/core/network/api_service.dart';
import 'package:stronger_muscles_dashboard/core/storage/cache_service.dart';
import 'package:stronger_muscles_dashboard/features/categories/data/models/category_model.dart';



class CategoryRepository {
  final ApiService _apiService;
  late final CacheService _cacheService;

  static const String _cacheKeyCategories = 'categories_list';
  static const String _cacheKeyCategoriesTree = 'categories_tree';

  CategoryRepository(this._apiService) {
    _cacheService = Get.put(CacheService(), permanent: true);
  }

  Future<List<CategoryModel>> getCategories({
    bool tree = false,
    bool forceRefresh = false,
  }) async {
    try {
      final cacheKey = tree ? _cacheKeyCategoriesTree : _cacheKeyCategories;

      if (forceRefresh) {
        _cacheService.remove(cacheKey);
      }

      // معادلة cache أولاً
      final cachedData = _cacheService.get<List<CategoryModel>>(cacheKey);
      if (cachedData != null && !forceRefresh) {
        debugPrint(
          '✓ تم استرجاع التصنيفات من الـ Cache (${cachedData.length} عنصر)',
        );
        return cachedData;
      }

      debugPrint('↓ جاري تحميل التصنيفات من الخادم (tree: $tree)...');
      final data = await _apiService.fetchCategories(tree: tree);
      debugPrint('📦 استلمنا ${data.length} تصنيف من الخام');

      final categories = <CategoryModel>[];
      for (var item in data) {
        try {
          categories.add(CategoryModel.fromJson(item as Map<String, dynamic>));
        } catch (e) {
          debugPrint('X خطأ في معالجة تصنيف واحد: $e');
          debugPrint('   البيانات التالفة: $item');
        }
      }

      debugPrint('✅ تم تحويل ${categories.length} تصنيف بنجاح');

      // حفظ البيانات في الـ Cache لمدة 5 دقائق
      _cacheService.set(cacheKey, categories, cacheDurationSeconds: 300);
      return categories;
    } catch (e) {
      debugPrint('X خطأ فادح في CategoryRepository: $e');
      rethrow;
    }
  }

  Future<CategoryModel> addCategory(Map<String, dynamic> categoryJson) async {
    try {
      final data = await _apiService.addCategory(categoryJson);
      // تنظيف الـ Cache بعد إضافة تصنيف جديد
      _cacheService.remove(_cacheKeyCategories);
      _cacheService.remove(_cacheKeyCategoriesTree);
      debugPrint('X تم حذف Cache التصنيفات بعد إضافة تصنيف جديد');
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
      debugPrint('X تم حذف Cache التصنيفات بعد تحديث تصنيف');
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
        debugPrint('X تم حذف Cache التصنيفات بعد حذف تصنيف');
      }
      return result;
    } catch (e) {
      print('خطأ في حذف التصنيف في المستودع: $e');
      return false;
    }
  }
}
