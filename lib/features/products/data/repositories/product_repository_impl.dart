import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import 'package:stronger_muscles_dashboard/core/error/network_error_handler.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_datasource.dart';
import '../datasources/product_remote_datasource.dart';
import '../mappers/product_mapper.dart';

/// Production implementation of [ProductRepository] acting as Single Source of Truth.
/// Orchestrates calls between Hive local cache [ProductLocalDataSource] and Dio remote datasource [ProductRemoteDataSource].
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts({
    bool forceRefresh = false,
  }) async {
    // 1. Try reading from Hive local cache if not forced
    if (!forceRefresh) {
      try {
        final isCacheValid = await localDataSource.isCacheValid();
        if (isCacheValid) {
          final cachedModels = await localDataSource.getCachedProducts();
          if (cachedModels.isNotEmpty) {
            debugPrint(
              '✓ Products retrieved from Hive cache (${cachedModels.length} products)',
            );
            return Right(cachedModels.map((m) => m.toEntity()).toList());
          }
        }
      } catch (e) {
        debugPrint('⚠️ ProductRepositoryImpl: Hive cache read failed: $e');
      }
    }

    // 2. Fetch fresh data from remote endpoint
    try {
      debugPrint('↓ Fetching products from remote API...');
      final models = await remoteDataSource.getProducts();

      // 3. Cache into Hive
      try {
        await localDataSource.cacheProducts(models);
      } catch (e) {
        debugPrint('⚠️ ProductRepositoryImpl: Hive caching failed: $e');
      }

      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e, stackTrace) {
      debugPrint('❌ ProductRepositoryImpl (getProducts) Exception: $e');

      // Resilient fallback to cached products during offline/network failure
      try {
        final cachedModels = await localDataSource.getCachedProducts();
        if (cachedModels.isNotEmpty) {
          debugPrint('✓ Falling back to cached products during network error');
          return Right(cachedModels.map((m) => m.toEntity()).toList());
        }
      } catch (_) {}

      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> getProductById(String id) async {
    try {
      final model = await remoteDataSource.getProductById(id);
      try {
        await localDataSource.cacheProduct(model);
      } catch (e) {
        debugPrint(
          '⚠️ ProductRepositoryImpl: Hive caching single product failed: $e',
        );
      }
      return Right(model.toEntity());
    } catch (e, stackTrace) {
      debugPrint('❌ ProductRepositoryImpl (getProductById) Exception: $e');

      try {
        final cached = await localDataSource.getCachedProductById(id);
        if (cached != null) {
          debugPrint('✓ Found cached product for offline details view ($id)');
          return Right(cached.toEntity());
        }
      } catch (_) {}

      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> addProduct(
    Map<String, dynamic> productData,
  ) async {
    try {
      final model = await remoteDataSource.addProduct(productData);
      try {
        await localDataSource.cacheProduct(model);
      } catch (e) {
        debugPrint(
          '⚠️ ProductRepositoryImpl: Hive caching newly added product failed: $e',
        );
      }
      return Right(model.toEntity());
    } catch (e, stackTrace) {
      debugPrint('❌ ProductRepositoryImpl (addProduct) Exception: $e');
      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> updateProduct(
    String id,
    Map<String, dynamic> productData,
  ) async {
    try {
      final model = await remoteDataSource.updateProduct(id, productData);
      try {
        await localDataSource.cacheProduct(model);
      } catch (e) {
        debugPrint(
          '⚠️ ProductRepositoryImpl: Hive updating product failed: $e',
        );
      }
      return Right(model.toEntity());
    } catch (e, stackTrace) {
      debugPrint('❌ ProductRepositoryImpl (updateProduct) Exception: $e');
      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, bool>> deleteProduct(String id) async {
    try {
      final result = await remoteDataSource.deleteProduct(id);
      if (result) {
        try {
          await localDataSource.deleteCachedProduct(id);
        } catch (e) {
          debugPrint(
            '⚠️ ProductRepositoryImpl: Hive removing deleted product failed: $e',
          );
        }
      }
      return Right(result);
    } catch (e, stackTrace) {
      debugPrint('❌ ProductRepositoryImpl (deleteProduct) Exception: $e');
      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, String>> uploadImage(String filePath) async {
    try {
      final url = await remoteDataSource.uploadImage(filePath);
      return Right(url);
    } catch (e, stackTrace) {
      debugPrint('❌ ProductRepositoryImpl (uploadImage) Exception: $e');
      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      return Left(failure);
    }
  }
}
