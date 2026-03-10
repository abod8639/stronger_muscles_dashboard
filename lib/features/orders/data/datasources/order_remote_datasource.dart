import 'package:dio/dio.dart';
import '../models/order_model.dart';
import '../../domain/entities/order_entity.dart';

abstract class OrderRemoteDataSource {
  Future<List<OrderModel>> getOrders();
  Future<OrderModel> getOrderById(String id);
  Future<OrderModel> updateOrderStatus(String id, OrderStatus status);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final Dio dio;

  OrderRemoteDataSourceImpl(this.dio);

  @override
  Future<List<OrderModel>> getOrders() async {
    final response = await dio.get('/orders');
    if (response.statusCode == 200) {
      final List data = response.data;
      final orders = <OrderModel>[];
      for (var item in data) {
        try {
          orders.add(OrderModel.fromJson(item as Map<String, dynamic>));
        } catch (e) {
          print('X Error parsing order: $e');
          print('  Corrupted data: $item');
        }
      }
      return orders;
    }
    throw Exception('Failed to load orders');
  }

  @override
  Future<OrderModel> getOrderById(String id) async {
    final response = await dio.get('/orders/$id');
    if (response.statusCode == 200) {
      return OrderModel.fromJson(response.data);
    }
    throw Exception('Failed to load order detail');
  }

  @override
  Future<OrderModel> updateOrderStatus(String id, OrderStatus status) async {
    final response = await dio.patch('/orders/$id/status', data: {
      'status': status.name,
    });
    if (response.statusCode == 200) {
      return OrderModel.fromJson(response.data);
    }
    throw Exception('Failed to update order status');
  }
}
