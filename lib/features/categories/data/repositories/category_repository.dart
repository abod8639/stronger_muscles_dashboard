import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import 'package:stronger_muscles_dashboard/core/error/network_error_handler.dart';
import 'package:stronger_muscles_dashboard/core/storage/cache_service.dart';
import 'package:stronger_muscles_dashboard/features/categories/data/datasources/category_remote_datasource.dart';
import 'package:stronger_muscles_dashboard/features/categories/data/models/category_model.dart';
import 'package:stronger_muscles_dashboard/features/categories/domain/entities/category_entity.dart';
import 'package:stronger_muscles_dashboard/features/categories/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;
  CacheService? _cacheService;

  static const String _cacheKeyCategories = 'categories_list';
  static const String _cacheKeyCategoriesTree = 'categories_tree';

  CategoryRepositoryImpl({required this.remoteDataSource}) {
    if (Get.isRegistered<CacheService>()) {
      _cacheService = Get.find<CacheService>();
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories({
    bool tree = false,
    bool forceRefresh = false,
    CancelToken? cancelToken,
  }) async {
    final cacheKey = tree ? _cacheKeyCategoriesTree : _cacheKeyCategories;

    // 1. القراءة الآمنة من الذاكرة المؤقتة (Cache)
    if (!forceRefresh && _cacheService != null) {
      try {
        final cachedData = _cacheService!.get<dynamic>(cacheKey);
        if (cachedData is List && cachedData.isNotEmpty) {
          if (cachedData.first is CategoryModel) {
            final entities =
                (cachedData as List<CategoryModel>).map((m) => m.toEntity()).toList();
            return Right(entities);
          }
        }
      } catch (e) {
        _cacheService?.remove(cacheKey);
      }
    }

    // 2. الجلب من الخادم
    try {
      final models = await remoteDataSource.getCategories(
        tree: tree,
        cancelToken: cancelToken,
      );

      // 3. التخزين المؤقت
      _cacheService?.set(cacheKey, models, cacheDurationSeconds: 300);

      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } catch (e, stackTrace) {
      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, CategoryEntity>> addCategory(
    Map<String, dynamic> categoryData, {
    CancelToken? cancelToken,
  }) async {
    try {
      final model = await remoteDataSource.addCategory(
        categoryData,
        cancelToken: cancelToken,
      );
      _invalidateCache();
      return Right(model.toEntity());
    } catch (e, stackTrace) {
      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, CategoryEntity>> updateCategory(
    String id,
    Map<String, dynamic> categoryData, {
    CancelToken? cancelToken,
  }) async {
    try {
      final model = await remoteDataSource.updateCategory(
        id,
        categoryData,
        cancelToken: cancelToken,
      );
      _invalidateCache();
      return Right(model.toEntity());
    } catch (e, stackTrace) {
      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteCategory(
    String id, {
    CancelToken? cancelToken,
  }) async {
    try {
      final success = await remoteDataSource.deleteCategory(
        id,
        cancelToken: cancelToken,
      );
      if (success) {
        _invalidateCache();
        return const Right(unit);
      }
      return const Left(
        ServerFailure(message: 'تعذر حذف التصنيف من الخادم'),
      );
    } catch (e, stackTrace) {
      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      return Left(failure);
    }
  }

  void _invalidateCache() {
    try {
      _cacheService?.remove(_cacheKeyCategories);
      _cacheService?.remove(_cacheKeyCategoriesTree);
    } catch (e) {
      debugPrint('X Error invalidating categories cache: $e');
    }
  }
}
