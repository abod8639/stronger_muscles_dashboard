import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';

abstract class OrderRepository {
  Future<List<OrderEntity>> getOrders();
  Future<OrderEntity> getOrderDetails(String orderId);
  Future<OrderEntity> updateOrderStatus(String orderId, OrderStatus status);
}
