enum OrderStatus {
  pending,
  processing,
  shipped,
  delivered,
  cancelled,
}

class OrderEntity {
  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final String? phoneNumber;
  final double totalAmount;
  final OrderStatus status;
  final DateTime orderDate;
  final List<OrderItemEntity> items;

  const OrderEntity({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    this.phoneNumber,
    required this.totalAmount,
    required this.status,
    required this.orderDate,
    required this.items,
  });
}

class OrderItemEntity {
  final String productId;
  final String productName;
  final int quantity;
  final double price;
  final String? imageUrl;

  const OrderItemEntity({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    this.imageUrl,
  });
}
