import '../models/index.dart';
import '../services/api_service.dart';

class OrderRepository {
  final ApiService _apiService;

  OrderRepository(this._apiService);

  Future<List<OrderModel>> getOrders() async {
    try {
      final data = await _apiService.fetchOrders();
      return data
          .map((json) => OrderModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('خطأ في OrderRepository: $e');
      rethrow;
    }
  }

  Future<OrderModel> getOrderDetail(String orderId) async {
    try {
      final data = await _apiService.fetchOrderDetail(orderId);
      return OrderModel.fromJson(data );
    } catch (e) {
      print('خطأ في جلب تفاصيل الطلب: $e');
      rethrow;
    }
  }
}
