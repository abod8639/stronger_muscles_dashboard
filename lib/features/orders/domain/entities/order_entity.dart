import 'address_entity.dart';

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

/// Pure Dart Domain Entity representing a customer order.
/// 100% pure Dart - decoupled from Flutter UI, Hive, and Dio.
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
  final AddressEntity? shippingAddress;
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

  OrderEntity copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userEmail,
    String? userPhoto,
    String? phoneNumber,
    double? totalAmount,
    double? subtotal,
    double? shippingCost,
    double? discount,
    OrderStatus? status,
    PaymentStatus? paymentStatus,
    String? paymentMethod,
    String? addressId,
    AddressEntity? shippingAddress,
    String? trackingNumber,
    String? notes,
    DateTime? orderDate,
    List<OrderItemEntity>? items,
  }) {
    return OrderEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      userPhoto: userPhoto ?? this.userPhoto,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      totalAmount: totalAmount ?? this.totalAmount,
      subtotal: subtotal ?? this.subtotal,
      shippingCost: shippingCost ?? this.shippingCost,
      discount: discount ?? this.discount,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      addressId: addressId ?? this.addressId,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      notes: notes ?? this.notes,
      orderDate: orderDate ?? this.orderDate,
      items: items ?? this.items,
    );
  }

  static bool _itemsEquals(List<OrderItemEntity> a, List<OrderItemEntity> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          totalAmount == other.totalAmount &&
          status == other.status &&
          paymentStatus == other.paymentStatus &&
          _itemsEquals(items, other.items);

  @override
  int get hashCode =>
      id.hashCode ^
      userId.hashCode ^
      totalAmount.hashCode ^
      status.hashCode ^
      paymentStatus.hashCode ^
      items.length.hashCode;

  @override
  String toString() =>
      'OrderEntity(id: $id, user: $userName, total: $totalAmount, status: ${status.name})';
}

/// Pure Dart Domain Entity representing a single purchased item in an order.
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

  OrderItemEntity copyWith({
    String? id,
    String? productId,
    String? productName,
    int? quantity,
    double? unitPrice,
    double? subtotal,
    String? imageUrl,
    String? selectedFlavor,
    String? selectedSize,
  }) {
    return OrderItemEntity(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      subtotal: subtotal ?? this.subtotal,
      imageUrl: imageUrl ?? this.imageUrl,
      selectedFlavor: selectedFlavor ?? this.selectedFlavor,
      selectedSize: selectedSize ?? this.selectedSize,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderItemEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          productId == other.productId &&
          quantity == other.quantity &&
          unitPrice == other.unitPrice;

  @override
  int get hashCode =>
      id.hashCode ^
      productId.hashCode ^
      quantity.hashCode ^
      unitPrice.hashCode;

  @override
  String toString() =>
      'OrderItemEntity(id: $id, product: $productName, qty: $quantity, price: $unitPrice)';
}
