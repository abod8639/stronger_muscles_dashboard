import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/exceptions.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import 'package:stronger_muscles_dashboard/core/error/network_error_handler.dart';
import 'package:stronger_muscles_dashboard/features/categories/data/datasources/category_local_datasource.dart';
import 'package:stronger_muscles_dashboard/features/categories/data/datasources/category_remote_datasource.dart';
import 'package:stronger_muscles_dashboard/features/categories/data/mappers/category_mapper.dart';
import 'package:stronger_muscles_dashboard/features/categories/domain/entities/category_entity.dart';
import 'package:stronger_muscles_dashboard/features/categories/domain/repositories/category_repository.dart';

/// Single Source of Truth for Categories.
/// Orchestrates calls between [CategoryRemoteDataSource] (Dio) and [CategoryLocalDataSource] (Hive).
/// Zero unhandled exceptions: maps raw exceptions to strongly-typed [Failure] instances via [fpdart].
class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource _remoteDataSource;
  final CategoryLocalDataSource _localDataSource;

  CategoryRepositoryImpl({
    required CategoryRemoteDataSource remoteDataSource,
    required CategoryLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories({
    bool tree = false,
    bool forceRefresh = false,
  }) async {
    // 1. Check local Hive cache if refresh is not forced
    if (!forceRefresh) {
      final isCacheValid = await _localDataSource.isCacheValid(tree: tree);
      if (isCacheValid) {
        try {
          final cachedModels = await _localDataSource.getCachedCategories(tree: tree);
          if (cachedModels.isNotEmpty) {
            return Right(cachedModels.toEntities());
          }
        } catch (_) {
          // If local cache read fails, seamlessly fall through to remote fetch
        }
      }
    }

    // 2. Fetch fresh data from remote source
    try {
      final remoteModels = await _remoteDataSource.getCategories(tree: tree);
      // Cache asynchronously without blocking remote return
      try {
        await _localDataSource.cacheCategories(remoteModels, tree: tree);
      } catch (_) {}
      return Right(remoteModels.toEntities());
    } on AppException catch (e) {
      // 3. Resilient fallback: If remote fails, attempt to serve stale cached data
      try {
        final fallbackCache = await _localDataSource.getCachedCategories(tree: tree);
        if (fallbackCache.isNotEmpty) {
          return Right(fallbackCache.toEntities());
        }
      } catch (_) {}
      return Left(NetworkErrorHandler.handleException(e));
    } catch (e) {
      return Left(NetworkErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, CategoryEntity>> getCategoryById(String id) async {
    try {
      // Check local cache first
      final cachedModel = await _localDataSource.getCachedCategoryById(id);
      if (cachedModel != null) {
        return Right(cachedModel.toEntity());
      }

      // Fetch from remote
      final remoteModel = await _remoteDataSource.getCategoryById(id);
      try {
        await _localDataSource.cacheCategory(remoteModel);
      } catch (_) {}
      return Right(remoteModel.toEntity());
    } on AppException catch (e) {
      return Left(NetworkErrorHandler.handleException(e));
    } catch (e) {
      return Left(NetworkErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, CategoryEntity>> addCategory(CategoryEntity category) async {
    try {
      final remoteJson = category.toRemoteJson();
      final newModel = await _remoteDataSource.addCategory(remoteJson);
      try {
        await _localDataSource.cacheCategory(newModel);
      } catch (_) {}
      return Right(newModel.toEntity());
    } on AppException catch (e) {
      return Left(NetworkErrorHandler.handleException(e));
    } catch (e) {
      return Left(NetworkErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, CategoryEntity>> updateCategory(CategoryEntity category) async {
    try {
      final remoteJson = category.toRemoteJson();
      final updatedModel = await _remoteDataSource.updateCategory(category.id, remoteJson);
      try {
        await _localDataSource.cacheCategory(updatedModel);
      } catch (_) {}
      return Right(updatedModel.toEntity());
    } on AppException catch (e) {
      return Left(NetworkErrorHandler.handleException(e));
    } catch (e) {
      return Left(NetworkErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteCategory(String id) async {
    try {
      await _remoteDataSource.deleteCategory(id);
      try {
        await _localDataSource.deleteCachedCategory(id);
      } catch (_) {}
      return const Right(unit);
    } on AppException catch (e) {
      return Left(NetworkErrorHandler.handleException(e));
    } catch (e) {
      return Left(NetworkErrorHandler.handleException(e));
    }
  }
}
