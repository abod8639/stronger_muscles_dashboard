import 'package:stronger_muscles_dashboard/features/products/data/models/product_model.dart';

import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_remote_datasource.dart';
import '../models/category_model.dart';
import 'package:stronger_muscles_dashboard/core/storage/cache_service.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;
  late final CacheService _cacheService;

  static const String _cacheKeyCategories = 'categories_list';
  static const String _cacheKeyCategoriesTree = 'categories_tree';

  CategoryRepositoryImpl(this.remoteDataSource) {
    _cacheService = Get.find<CacheService>();
  }

  @override
  Future<List<CategoryEntity>> getCategories({
    bool tree = false,
    bool forceRefresh = false,
  }) async {
    try {
      final cacheKey = tree ? _cacheKeyCategoriesTree : _cacheKeyCategories;

      if (forceRefresh) {
        _cacheService.remove(cacheKey);
      }

      // Check cache first
      if (!forceRefresh && _cacheService.hasValid(cacheKey)) {
        final cachedData = _cacheService.get<List<CategoryModel>>(cacheKey);
        if (cachedData != null) {
          debugPrint(
            '✓ Retrieved categories from cache (${cachedData.length} items)',
          );
          return cachedData;
        }
      }

      debugPrint('↓ Fetching categories from remote (tree: $tree)...');
      final categories = await remoteDataSource.getCategories(tree: tree);
      debugPrint('📦 Received ${categories.length} categories');

      // Save to cache
      _cacheService.set(cacheKey, categories);
      return categories;
    } catch (e) {
      debugPrint('X Error in CategoryRepositoryImpl: $e');
      rethrow;
    }
  }

  @override
  Future<CategoryEntity> addCategory(CategoryEntity category) async {
    try {
      final model = _toModel(category);
      final newCategory = await remoteDataSource.addCategory(model);
      
      _clearCache();
      return newCategory;
    } catch (e) {
      debugPrint('X Error adding category: $e');
      rethrow;
    }
  }

  @override
  Future<CategoryEntity> updateCategory(CategoryEntity category) async {
    try {
      final model = _toModel(category);
      final updatedCategory = await remoteDataSource.updateCategory(model);
      
      _clearCache();
      return updatedCategory;
    } catch (e) {
      debugPrint('X Error updating category: $e');
      rethrow;
    }
  }

  @override
  Future<bool> deleteCategory(String id) async {
    try {
      final success = await remoteDataSource.deleteCategory(id);
      if (success) {
        _clearCache();
      }
      return success;
    } catch (e) {
      debugPrint('X Error deleting category: $e');
      rethrow;
    }
  }

  void _clearCache() {
    _cacheService.remove(_cacheKeyCategories);
    _cacheService.remove(_cacheKeyCategoriesTree);
    debugPrint('✗ Category cache cleared');
  }

  CategoryModel _toModel(CategoryEntity category) {
    return CategoryModel(
      id: category.id,
      nameAr: category.nameAr,
      nameEn: category.nameEn,
      descriptionAr: category.descriptionAr,
      descriptionEn: category.descriptionEn,
      imageUrl: category.imageUrl,
      parentId: category.parentId,
      isActive: category.isActive,
      name: TranslatableString(ar: category.nameAr, en: category.nameEn),
    );
  }
}
