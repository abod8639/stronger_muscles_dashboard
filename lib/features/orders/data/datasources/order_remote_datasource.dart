import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/config/api_config.dart';
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
    final response = await dio.get(ApiConfig.adminOrders);
    
    if (response.statusCode == 200) {
      dynamic data;
      // Handle Laravel wrapping (data: { data: [...] })
      if (response.data is Map && response.data.containsKey('data')) {
        final innerData = response.data['data'];
        if (innerData is Map && innerData.containsKey('data')) {
          data = innerData['data'];
        } else {
          data = innerData;
        }
      } else {
        data = response.data;
      }

      if (data is! List) {
        return [];
      }

      final orders = <OrderModel>[];
      for (var item in data) {
        try {
          orders.add(OrderModel.fromJson(item as Map<String, dynamic>));
        } catch (e) {
          print('X Error parsing order: $e');
        }
      }
      return orders;
    }
    throw Exception('Failed to load orders');
  }

  @override
  Future<OrderModel> getOrderById(String id) async {
    final response = await dio.get('${ApiConfig.adminOrders}/$id');
    if (response.statusCode == 200) {
      final data = (response.data is Map && response.data.containsKey('data'))
          ? response.data['data']
          : response.data;
      return OrderModel.fromJson(data as Map<String, dynamic>);
    }
    throw Exception('Failed to load order detail');
  }

  @override
  Future<OrderModel> updateOrderStatus(String id, OrderStatus status) async {
    final response = await dio.patch('${ApiConfig.adminOrders}/$id/status', data: {
      'status': status.name,
    });
    if (response.statusCode == 200) {
      return OrderModel.fromJson(response.data);
    }
    throw Exception('Failed to update order status');
  }
}
