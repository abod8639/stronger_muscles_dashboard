import 'package:flutter/material.dart';

import '../models/order_model.dart'; // تأكد من المسار الصحيح
import '../services/api_service.dart';

class OrderRepository {
  final ApiService _apiService;

  OrderRepository(this._apiService);

Future<List<OrderModel>> getOrders() async {
    try {
      final List<dynamic> data = await _apiService.fetchOrders();
      
      return data.map((json) {
        try {
          return OrderModel.fromJson(json as Map<String, dynamic>);
        } catch (e) {
          debugPrint('خطأ في تحويل هذا العنصر: $json');
          debugPrint('السبب: $e');
          rethrow;
        }
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<OrderModel> getOrderDetail(String orderId) async {
    try {
      final Map<String, dynamic> data = await _apiService.fetchOrderDetail(orderId);
      
      return OrderModel.fromJson(data);
    } catch (e) {
      debugPrint('Error in OrderRepository (getOrderDetail) for ID $orderId: $e');
      rethrow;
    }
  }
}