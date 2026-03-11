import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/core/storage/cache_service.dart';
import 'package:stronger_muscles_dashboard/features/orders/data/datasources/order_remote_datasource.dart';
import 'package:stronger_muscles_dashboard/features/orders/data/models/order_model.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource _remoteDataSource;
  late final CacheService _cacheService;

  static const String _cacheKeyOrders = 'orders_list';

  OrderRepositoryImpl(this._remoteDataSource) {
    _cacheService = Get.find<CacheService>();
  }

  @override
  Future<List<OrderEntity>> getOrders() async {
    try {
      // Check cache first
      final cachedData = _cacheService.get<List<OrderModel>>(_cacheKeyOrders);
      if (cachedData != null) {
        debugPrint('✓ تم استرجاع الطلبات من الـ Cache');
        return cachedData.map((m) => m.toEntity()).toList();
      }

      debugPrint('↓ جاري تحميل الطلبات من الخادم...');
      final orderModels = await _remoteDataSource.getOrders();

      // Save to cache for 5 minutes
      _cacheService.set(_cacheKeyOrders, orderModels, cacheDurationSeconds: 300);
      
      return orderModels.map((m) => m.toEntity()).toList();
    } catch (e) {
      debugPrint('Error in OrderRepositoryImpl (getOrders): $e');
      rethrow;
    }
  }

  @override
  Future<OrderEntity> getOrderDetails(String orderId) async {
    try {
      final model = await _remoteDataSource.getOrderById(orderId);
      return model.toEntity();
    } catch (e) {
      debugPrint('Error in OrderRepositoryImpl (getOrderDetails) for ID $orderId: $e');
      rethrow;
    }
  }

  @override
  Future<OrderEntity> updateOrderStatus(String orderId, OrderStatus status) async {
    try {
      final model = await _remoteDataSource.updateOrderStatus(orderId, status);
      
      // Clear cache after update
      _cacheService.remove(_cacheKeyOrders);
      
      return model.toEntity();
    } catch (e) {
      debugPrint('Error in OrderRepositoryImpl (updateOrderStatus): $e');
      rethrow;
    }
  }
}
