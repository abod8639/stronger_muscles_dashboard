import '../entities/order_entity.dart';

abstract class OrderRepository {
  Future<List<OrderEntity>> getOrders();
  Future<OrderEntity> getOrderById(String id);
  Future<OrderEntity> updateOrderStatus(String id, OrderStatus status);
}
