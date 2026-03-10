import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/core/network/api_service.dart';
import 'package:stronger_muscles_dashboard/core/storage/cache_service.dart';

import '../models/order_model.dart';


class OrderRepository {
  final ApiService _apiService;
  late final CacheService _cacheService;

  static const String _cacheKeyOrders = 'orders_list';

  OrderRepository(this._apiService) {
    _cacheService = Get.put(CacheService(), permanent: true);
  }

  Future<List<OrderModel>> getOrders() async {
    try {
      // معادلة cache أولاً
      final cachedData = _cacheService.get<List<OrderModel>>(_cacheKeyOrders);
      if (cachedData != null) {
        debugPrint('✓ تم استرجاع الطلبات من الـ Cache');
        return cachedData;
      }

      debugPrint('↓ جاري تحميل الطلبات من الخادم...');
      final List<dynamic> data = await _apiService.fetchOrders();

      final orders = data.map((json) {
        try {
          return OrderModel.fromJson(json as Map<String, dynamic>);
        } catch (e) {
          debugPrint('خطأ في تحويل هذا العنصر: $json');
          debugPrint('السبب: $e');
          rethrow;
        }
      }).toList();

      // حفظ البيانات في الـ Cache لمدة 5 دقائق
      _cacheService.set(_cacheKeyOrders, orders, cacheDurationSeconds: 300);
      return orders;
    } catch (e) {
      rethrow;
    }
  }

  Future<OrderModel> getOrderDetail(String orderId) async {
    try {
      final Map<String, dynamic> data = await _apiService.fetchOrderDetail(
        orderId,
      );

      return OrderModel.fromJson(data);
    } catch (e) {
      debugPrint(
        'Error in OrderRepository (getOrderDetail) for ID $orderId: $e',
      );
      rethrow;
    }
  }
}
