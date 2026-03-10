import 'package:stronger_muscles_dashboard/data/models/address_model.dart';

enum OrderStatus {
  pending,
  processing,
  shipped,
  delivered,
  cancelled,
}

enum PaymentStatus {
  pending,
  paid,
  failed,
  refunded,
}

class OrderEntity {
  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final String? userPhoto;
  final String? phoneNumber;
  final double totalAmount;
  final double subtotal;
  final double shippingCost;
  final double discount;
  final OrderStatus status;
  final PaymentStatus paymentStatus;
  final String paymentMethod;
  final String addressId;
  final AddressModel? shippingAddress;
  final String? trackingNumber;
  final String? notes;
  final DateTime orderDate;
  final List<OrderItemEntity> items;

  const OrderEntity({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    this.userPhoto,
    this.phoneNumber,
    required this.totalAmount,
    required this.subtotal,
    this.shippingCost = 0.0,
    this.discount = 0.0,
    required this.status,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.addressId,
    this.shippingAddress,
    this.trackingNumber,
    this.notes,
    required this.orderDate,
    required this.items,
  });
}

class OrderItemEntity {
  final String id;
  final String productId;
  final String productName;
  final int quantity;
  final double unitPrice;
  final double subtotal;
  final String? imageUrl;
  final String? selectedFlavor;
  final String? selectedSize;

  const OrderItemEntity({
    required this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
    this.imageUrl,
    this.selectedFlavor,
    this.selectedSize,
  });
}
