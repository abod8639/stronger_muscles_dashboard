import 'package:hive_ce/hive.dart';
import 'package:stronger_muscles_dashboard/core/error/exceptions.dart';
import '../models/category_model.dart';

/// Contract for locally caching category data via Hive.
abstract class CategoryLocalDataSource {
  Future<List<CategoryModel>> getCachedCategories({bool tree = false});
  Future<void> cacheCategories(
    List<CategoryModel> categories, {
    bool tree = false,
  });
  Future<CategoryModel?> getCachedCategoryById(String id);
  Future<void> cacheCategory(CategoryModel category);
  Future<void> deleteCachedCategory(String id);
  Future<bool> isCacheValid({bool tree = false});
  Future<void> clearCache();
}

/// Production implementation of [CategoryLocalDataSource] using Hive [Box<CategoryModel>].
/// 100% testable via Constructor Dependency Injection.
class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  final Box<CategoryModel> _box;
  static const Duration _cacheTtl = Duration(hours: 4);

  // In-memory timestamp tracking to maintain strict Box<CategoryModel> type integrity
  static DateTime? _lastFetchTime;
  static DateTime? _lastTreeFetchTime;

  CategoryLocalDataSourceImpl({required Box<CategoryModel> box}) : _box = box;

  @override
  Future<List<CategoryModel>> getCachedCategories({bool tree = false}) async {
    try {
      if (tree) {
        // Return top-level root categories (those without parentId or with parentId == '')
        return _box.values
            .where((c) => c.parentId == null || c.parentId!.isEmpty)
            .toList();
      }
      return _box.values.toList();
    } catch (e) {
      throw CacheException(message: 'Failed to retrieve cached categories: $e');
    }
  }

  @override
  Future<void> cacheCategories(
    List<CategoryModel> categories, {
    bool tree = false,
  }) async {
    try {
      final map = <String, CategoryModel>{};
      void flatten(List<CategoryModel> list) {
        for (final item in list) {
          map[item.id] = item;
          if (item.children.isNotEmpty) {
            flatten(item.children);
          }
        }
      }

      flatten(categories);
      await _box.putAll(map);

      final now = DateTime.now();
      if (tree) {
        _lastTreeFetchTime = now;
      } else {
        _lastFetchTime = now;
      }
    } catch (e) {
      throw CacheException(message: 'Failed to cache categories: $e');
    }
  }

  @override
  Future<CategoryModel?> getCachedCategoryById(String id) async {
    try {
      return _box.get(id);
    } catch (e) {
      throw CacheException(
        message: 'Failed to retrieve cached category $id: $e',
      );
    }
  }

  @override
  Future<void> cacheCategory(CategoryModel category) async {
    try {
      await _box.put(category.id, category);
    } catch (e) {
      throw CacheException(message: 'Failed to update category in cache: $e');
    }
  }

  @override
  Future<void> deleteCachedCategory(String id) async {
    try {
      await _box.delete(id);
    } catch (e) {
      throw CacheException(message: 'Failed to delete cached category: $e');
    }
  }

  @override
  Future<bool> isCacheValid({bool tree = false}) async {
    final timestamp = tree ? _lastTreeFetchTime : _lastFetchTime;
    if (timestamp == null || _box.isEmpty) return false;
    return DateTime.now().difference(timestamp) < _cacheTtl;
  }

  @override
  Future<void> clearCache() async {
    try {
      await _box.clear();
      _lastFetchTime = null;
      _lastTreeFetchTime = null;
    } catch (e) {
      throw CacheException(message: 'Failed to clear categories cache: $e');
    }
  }
}
