enum OrderStatus { pending, processing, shipped, delivered, cancelled }
enum PaymentStatus { pending, paid, failed, refunded }

class OrderModel {
  final String id;
  final String userId;
  final DateTime orderDate;
  final OrderStatus status;
  final PaymentStatus paymentStatus;
  final String paymentMethod;
  final String addressId;
  final Map<String, dynamic>? shippingAddressSnapshot;
  final double subtotal;
  final double shippingCost;
  final double discount;
  final double totalAmount;
  final String? trackingNumber;
  final String? notes;
  final List<OrderItemModel>? items;

  OrderModel({
    required this.id,
    required this.userId,
    required this.orderDate,
    this.status = OrderStatus.pending,
    this.paymentStatus = PaymentStatus.pending,
    this.paymentMethod = 'card',
    required this.addressId,
    this.shippingAddressSnapshot,
    required this.subtotal,
    this.shippingCost = 0.0,
    this.discount = 0.0,
    required this.totalAmount,
    this.trackingNumber,
    this.notes,
    this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: (json['id'] ?? '').toString(),
      userId: (json['userId'] ?? json['user_id'] ?? '').toString(),
      orderDate: DateTime.tryParse((json['orderDate'] ?? json['order_date'] ?? '').toString()) ?? DateTime.now(),
      status: OrderStatus.values.firstWhere(
        (e) => e.name == (json['status'] ?? ''),
        orElse: () => OrderStatus.pending,
      ),
      paymentStatus: PaymentStatus.values.firstWhere(
        (e) => e.name == (json['paymentStatus'] ?? json['payment_status'] ?? ''),
        orElse: () => PaymentStatus.pending,
      ),
      paymentMethod: (json['paymentMethod'] ?? json['payment_method'] ?? 'card').toString(),
      addressId: (json['addressId'] ?? json['address_id'] ?? '').toString(),
      shippingAddressSnapshot: json['shippingAddressSnapshot'] ?? json['shipping_address_snapshot'],
      subtotal: double.tryParse((json['subtotal'] ?? 0).toString()) ?? 0.0,
      shippingCost: double.tryParse((json['shippingCost'] ?? json['shipping_cost'] ?? 0).toString()) ?? 0.0,
      discount: double.tryParse((json['discount'] ?? 0).toString()) ?? 0.0,
      totalAmount: double.tryParse((json['totalAmount'] ?? json['total_amount'] ?? 0).toString()) ?? 0.0,
      trackingNumber: (json['trackingNumber'] ?? json['tracking_number'])?.toString(),
      notes: (json['notes'])?.toString(),
      items: (json['items'] ?? json['order_items']) != null
          ? (json['items'] ?? json['order_items'] as List)
              .map((i) => OrderItemModel.fromJson(i as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'order_date': orderDate.toIso8601String(),
      'status': status.name,
      'payment_status': paymentStatus.name,
      'payment_method': paymentMethod,
      'address_id': addressId,
      'shipping_address_snapshot': shippingAddressSnapshot,
      'subtotal': subtotal,
      'shipping_cost': shippingCost,
      'discount': discount,
      'total_amount': totalAmount,
      'tracking_number': trackingNumber,
      'notes': notes,
      'order_items': items?.map((item) => item.toJson()).toList(),
    };
  }
}

class OrderItemModel {
  final String id;
  final String orderId;
  final String productId;
  final String productName;
  final double unitPrice;
  final int quantity;
  final double subtotal;
  final String? imageUrl;

  OrderItemModel({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.unitPrice,
    required this.quantity,
    required this.subtotal,
    this.imageUrl,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: (json['id'] ?? '').toString(),
      orderId: (json['orderId'] ?? json['order_id'] ?? '').toString(),
      productId: (json['productId'] ?? json['product_id'] ?? '').toString(),
      productName: (json['productName'] ?? json['product_name'] ?? '').toString(),
      unitPrice: double.tryParse((json['unitPrice'] ?? json['unit_price'] ?? 0).toString()) ?? 0.0,
      quantity: int.tryParse((json['quantity'] ?? 0).toString()) ?? 0,
      subtotal: double.tryParse((json['subtotal'] ?? 0).toString()) ?? 0.0,
      imageUrl: (json['imageUrl'] ?? json['image_url'])?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'product_id': productId,
      'product_name': productName,
      'unit_price': unitPrice,
      'quantity': quantity,
      'subtotal': subtotal,
      'image_url': imageUrl,
    };
  }
}
