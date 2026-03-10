import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_remote_datasource.dart';
import '../models/order_model.dart';
import 'package:stronger_muscles_dashboard/core/storage/cache_service.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;
  late final CacheService _cacheService;

  static const String _cacheKeyOrders = 'orders_list';

  OrderRepositoryImpl(this.remoteDataSource) {
    _cacheService = Get.find<CacheService>();
  }

  @override
  Future<List<OrderEntity>> getOrders({bool forceRefresh = false}) async {
    try {
      if (forceRefresh) {
        _cacheService.remove(_cacheKeyOrders);
      }

      if (!forceRefresh && _cacheService.hasValid(_cacheKeyOrders)) {
        final cachedData = _cacheService.get<List<OrderModel>>(_cacheKeyOrders);
        if (cachedData != null) {
          debugPrint('✓ Retrieved orders from cache');
          return cachedData;
        }
      }

      debugPrint('↓ Fetching orders from remote...');
      final orders = await remoteDataSource.getOrders();
      
      _cacheService.set(_cacheKeyOrders, orders);
      return orders;
    } catch (e) {
      debugPrint('X Error in OrderRepositoryImpl: $e');
      rethrow;
    }
  }

  @override
  Future<OrderEntity> getOrderById(String id) async {
    return await remoteDataSource.getOrderById(id);
  }

  @override
  Future<OrderEntity> updateOrderStatus(String id, OrderStatus status) async {
    final updatedOrder = await remoteDataSource.updateOrderStatus(id, status);
    _cacheService.remove(_cacheKeyOrders);
    return updatedOrder;
  }
}
