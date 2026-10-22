import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import 'package:stronger_muscles_dashboard/core/error/network_error_handler.dart';
import 'package:stronger_muscles_dashboard/core/storage/cache_service.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final CacheService? _cacheService;

  static const String _cacheKeyProducts = 'products_list';

  ProductRepositoryImpl({
    required this.remoteDataSource,
    CacheService? cacheService,
  }) : _cacheService = cacheService ?? CacheService.instance;

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts({
    bool forceRefresh = false,
    CancelToken? cancelToken,
  }) async {
    // 1. فحص التخزين المؤقت (Cache)
    if (!forceRefresh && _cacheService != null) {
      try {
        final cachedData = _cacheService!.get<dynamic>(_cacheKeyProducts);
        if (cachedData != null && cachedData is List && cachedData.isNotEmpty) {
          if (cachedData.first is ProductModel) {
            debugPrint('✓ تم استرجاع المنتجات من الـ Cache بنجاح');
            return Right(
              (cachedData as List<ProductModel>).map((m) => m.toEntity()).toList(),
            );
          } else {
            _cacheService?.remove(_cacheKeyProducts);
          }
        }
      } catch (e) {
        debugPrint('⚠️ خطأ في قراءة Cache المنتجات: $e');
        _cacheService?.remove(_cacheKeyProducts);
      }
    }

    // 2. الجلب من الخادم
    try {
      debugPrint('↓ جاري تحميل المنتجات من الخادم...');
      final models = await remoteDataSource.getProducts(cancelToken: cancelToken);

      try {
        _cacheService?.set(_cacheKeyProducts, models, cacheDurationSeconds: 300);
      } catch (e) {
        debugPrint('⚠️ تعذر تخزين المنتجات في Cache: $e');
      }

      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } catch (e, stackTrace) {
      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      debugPrint('❌ [ProductRepositoryImpl] فشل في getProducts: ${failure.toMessage()}');
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> getProductById(
    String id, {
    CancelToken? cancelToken,
  }) async {
    try {
      final model = await remoteDataSource.getProductById(id, cancelToken: cancelToken);
      return Right(model.toEntity());
    } catch (e, stackTrace) {
      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      debugPrint('❌ [ProductRepositoryImpl] فشل في getProductById ($id): ${failure.toMessage()}');
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> addProduct(
    Map<String, dynamic> productData, {
    CancelToken? cancelToken,
  }) async {
    try {
      final model = await remoteDataSource.addProduct(productData, cancelToken: cancelToken);
      _cacheService?.remove(_cacheKeyProducts);
      return Right(model.toEntity());
    } catch (e, stackTrace) {
      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      debugPrint('❌ [ProductRepositoryImpl] فشل في addProduct: ${failure.toMessage()}');
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> updateProduct(
    String id,
    Map<String, dynamic> productData, {
    CancelToken? cancelToken,
  }) async {
    try {
      final model = await remoteDataSource.updateProduct(id, productData, cancelToken: cancelToken);
      _cacheService?.remove(_cacheKeyProducts);
      return Right(model.toEntity());
    } catch (e, stackTrace) {
      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      debugPrint('❌ [ProductRepositoryImpl] فشل في updateProduct ($id): ${failure.toMessage()}');
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, bool>> deleteProduct(
    String id, {
    CancelToken? cancelToken,
  }) async {
    try {
      final result = await remoteDataSource.deleteProduct(id, cancelToken: cancelToken);
      if (result) {
        _cacheService?.remove(_cacheKeyProducts);
      }
      return Right(result);
    } catch (e, stackTrace) {
      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      debugPrint('❌ [ProductRepositoryImpl] فشل في deleteProduct ($id): ${failure.toMessage()}');
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, String>> uploadImage(
    String filePath, {
    CancelToken? cancelToken,
  }) async {
    try {
      final url = await remoteDataSource.uploadImage(filePath, cancelToken: cancelToken);
      return Right(url);
    } catch (e, stackTrace) {
      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      debugPrint('❌ [ProductRepositoryImpl] فشل في uploadImage: ${failure.toMessage()}');
      return Left(failure);
    }
  }
}
