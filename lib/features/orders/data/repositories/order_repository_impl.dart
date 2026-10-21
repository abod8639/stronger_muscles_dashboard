import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import 'package:stronger_muscles_dashboard/core/error/network_error_handler.dart';
import 'package:stronger_muscles_dashboard/core/storage/cache_service.dart';
import 'package:stronger_muscles_dashboard/features/orders/data/datasources/order_remote_datasource.dart';
import 'package:stronger_muscles_dashboard/features/orders/data/models/order_model.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;
  CacheService? _cacheService;

  static const String _cacheKeyOrders = 'orders_list';

  OrderRepositoryImpl({required this.remoteDataSource}) {
    if (Get.isRegistered<CacheService>()) {
      _cacheService = Get.find<CacheService>();
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrders({
    bool forceRefresh = false,
    CancelToken? cancelToken,
  }) async {
    // 1. محاولة القراءة من الذاكرة المؤقتة (Cache) لتسريع الأداء وتوفير الموارد
    if (!forceRefresh && _cacheService != null) {
      try {
        final cachedData = _cacheService!.get<dynamic>(_cacheKeyOrders);
        if (cachedData is List && cachedData.isNotEmpty) {
          if (cachedData.first is OrderModel) {
            debugPrint('✓ تم استرجاع الطلبات من الـ Cache بنجاح');
            final entities = (cachedData as List<OrderModel>)
                .map((m) => m.toEntity())
                .toList();
            return Right(entities);
          }
        }
      } catch (e) {
        debugPrint('⚠️ فشل في قراءة Cache الطلبات: $e');
        _cacheService?.remove(_cacheKeyOrders);
      }
    }

    // 2. الجلب من الخادم مع عزل المعالجة والتقاط الأخطاء المركزية
    try {
      debugPrint('↓ جاري تحميل الطلبات من الخادم...');
      final models = await remoteDataSource.getOrders(cancelToken: cancelToken);

      // 3. تحديث الـ Cache لمدة 5 دقائق
      try {
        _cacheService?.set(_cacheKeyOrders, models, cacheDurationSeconds: 300);
      } catch (e) {
        debugPrint('⚠️ تعذر تخزين الطلبات في Cache: $e');
      }

      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } catch (e, stackTrace) {
      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      debugPrint('❌ [OrderRepositoryImpl] فشل في getOrders: ${failure.toMessage()}');
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> getOrderDetails(
    String orderId, {
    CancelToken? cancelToken,
  }) async {
    try {
      final model = await remoteDataSource.getOrderById(
        orderId,
        cancelToken: cancelToken,
      );
      return Right(model.toEntity());
    } catch (e, stackTrace) {
      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      debugPrint('❌ [OrderRepositoryImpl] فشل في getOrderDetails ($orderId): ${failure.toMessage()}');
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> updateOrderStatus(
    String orderId,
    OrderStatus status, {
    CancelToken? cancelToken,
  }) async {
    try {
      final model = await remoteDataSource.updateOrderStatus(
        orderId,
        status,
        cancelToken: cancelToken,
      );

      // مسح الـ Cache لضمان تحديث القائمة عند العودة
      _cacheService?.remove(_cacheKeyOrders);

      return Right(model.toEntity());
    } catch (e, stackTrace) {
      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      debugPrint('❌ [OrderRepositoryImpl] فشل في updateOrderStatus ($orderId): ${failure.toMessage()}');
      return Left(failure);
    }
  }
}
