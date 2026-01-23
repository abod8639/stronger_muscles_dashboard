import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

enum OrderStatus { pending, processing, shipped, delivered, cancelled }
enum PaymentStatus { pending, paid, failed, refunded }

@freezed
class OrderModel with _$OrderModel {
  const factory OrderModel({
    required String id,
    required String userId,
    required DateTime orderDate,
    @Default(OrderStatus.pending) OrderStatus status,
    @Default(PaymentStatus.pending) PaymentStatus paymentStatus,
    @Default('card') String paymentMethod,
    required String addressId,
    Map<String, dynamic>? shippingAddressSnapshot,
    required double subtotal,
    @Default(0.0) double shippingCost,
    @Default(0.0) double discount,
    required double totalAmount,
    String? trackingNumber,
    String? notes,
    String? phoneNumber,
    List<OrderItemModel>? items,
  }) = _OrderModel;

  factory OrderModel.fromJson(Map<String, dynamic> json) => 
      _$OrderModelFromJson(_mapOrderJson(json));
}

@freezed
class OrderItemModel with _$OrderItemModel {
  const factory OrderItemModel({
    required String id,
    required String orderId,
    required String productId,
    required String productName,
    required double unitPrice,
    required int quantity,
    required double subtotal,
    String? imageUrl,
  }) = _OrderItemModel;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) => 
      _$OrderItemModelFromJson(_mapItemJson(json));
}

// --- دالات معالجة البيانات لضمان التوافق مع أسماء الحقول المختلفة (Mapping) ---

Map<String, dynamic> _mapOrderJson(Map<String, dynamic> json) {
  // استخراج معرف المستخدم بشكل آمن من عدة أماكن محتملة
  String extractUserId() {
    if (json['userId'] != null) return json['userId'].toString();
    if (json['user_id'] != null) return json['user_id'].toString();
    if (json['user'] != null && json['user'] is Map) {
      return (json['user']['id'] ?? '').toString();
    }
    return '';
  }

  return {
    ...json,
    'id': (json['id'] ?? '').toString(),
    'userId': extractUserId(),
    'orderDate': json['orderDate'] ?? json['order_date'] ?? DateTime.now().toIso8601String(),
    'addressId': (json['addressId'] ?? json['address_id'] ?? '').toString(),
    'shippingCost': json['shippingCost'] ?? json['shipping_cost'] ?? 0.0,
    'totalAmount': json['totalAmount'] ?? json['total_amount'] ?? 0.0,
    'items': json['items'] ?? json['order_items'],
    // الحفاظ على الأسماء الأصلية لضمان عمل الحقول الأخرى
    'paymentStatus': json['paymentStatus'] ?? json['payment_status'],
    'paymentMethod': json['paymentMethod'] ?? json['payment_method'] ?? 'card',
    'trackingNumber': json['trackingNumber'] ?? json['tracking_number'],
    'phoneNumber': json['phoneNumber'] ?? json['phone_number'],
    'shippingAddressSnapshot': json['shippingAddressSnapshot'] ?? json['shipping_address_snapshot'] ?? {
       'address': json['shipping_address'] // Fallback if backend sends plain string
    },
  };
}

Map<String, dynamic> _mapItemJson(Map<String, dynamic> json) {
  return {
    ...json,
    'orderId': json['orderId'] ?? json['order_id'],
    'productId': json['productId'] ?? json['product_id'],
    'productName': json['productName'] ?? json['product_name'],
    'unitPrice': json['unitPrice'] ?? json['unit_price'],
    'imageUrl': json['imageUrl'] ?? json['image_url'],
  };
}