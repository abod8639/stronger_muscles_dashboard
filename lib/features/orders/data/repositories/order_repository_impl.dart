import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import 'package:stronger_muscles_dashboard/core/error/network_error_handler.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_local_datasource.dart';
import '../datasources/order_remote_datasource.dart';
import '../mappers/order_mapper.dart';

/// Production implementation of [OrderRepository] acting as Single Source of Truth.
/// Orchestrates calls between Hive local cache [OrderLocalDataSource] and Dio remote datasource [OrderRemoteDataSource].
class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;
  final OrderLocalDataSource localDataSource;

  OrderRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrders({
    bool forceRefresh = false,
  }) async {
    // 1. Try reading from Hive local cache if not forced
    if (!forceRefresh) {
      try {
        final isCacheValid = await localDataSource.isCacheValid();
        if (isCacheValid) {
          final cachedModels = await localDataSource.getCachedOrders();
          if (cachedModels.isNotEmpty) {
            debugPrint('✓ Orders retrieved from Hive cache (${cachedModels.length} orders)');
            return Right(cachedModels.map((m) => m.toEntity()).toList());
          }
        }
      } catch (e) {
        debugPrint('⚠️ OrderRepositoryImpl: Hive cache read failed: $e');
      }
    }

    // 2. Fetch fresh data from remote endpoint
    try {
      debugPrint('↓ Fetching orders from remote API...');
      final models = await remoteDataSource.getOrders();

      // 3. Cache into Hive
      try {
        await localDataSource.cacheOrders(models);
      } catch (e) {
        debugPrint('⚠️ OrderRepositoryImpl: Hive caching failed: $e');
      }

      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e, stackTrace) {
      debugPrint('❌ OrderRepositoryImpl (getOrders) Exception: $e');

      // Resilient fallback to cached orders if available
      try {
        final cachedModels = await localDataSource.getCachedOrders();
        if (cachedModels.isNotEmpty) {
          debugPrint('✓ Falling back to cached orders during offline/network failure');
          return Right(cachedModels.map((m) => m.toEntity()).toList());
        }
      } catch (_) {}

      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> getOrderDetails(
    String orderId,
  ) async {
    try {
      final model = await remoteDataSource.getOrderById(orderId);

      // Update cached order in Hive
      try {
        await localDataSource.cacheOrder(model);
      } catch (_) {}

      return Right(model.toEntity());
    } catch (e, stackTrace) {
      debugPrint('❌ OrderRepositoryImpl (getOrderDetails) Exception: $e');

      // Fallback to cached order if available
      try {
        final cached = await localDataSource.getCachedOrderById(orderId);
        if (cached != null) {
          return Right(cached.toEntity());
        }
      } catch (_) {}

      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> updateOrderStatus(
    String orderId,
    OrderStatus status,
  ) async {
    try {
      final model = await remoteDataSource.updateOrderStatus(orderId, status);

      // Update cached order in Hive
      try {
        await localDataSource.cacheOrder(model);
      } catch (_) {}

      return Right(model.toEntity());
    } catch (e, stackTrace) {
      debugPrint('❌ OrderRepositoryImpl (updateOrderStatus) Exception: $e');
      final failure = NetworkErrorHandler.handleException(e, stackTrace);
      return Left(failure);
    }
  }
}
