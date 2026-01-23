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
  return {
    ...json,
    // نستخدم الـ casting الآمن مع توفير قيمة افتراضية لتجنب خطأ الـ Null
    'id': (json['id'] ?? '').toString(), 
    'user_id': (json['userId'] ?? json['user_id'] ?? '').toString(),
    'order_date': json['orderDate'] ?? json['order_date'] ?? DateTime.now().toIso8601String(),
    'payment_status': json['paymentStatus'] ?? json['payment_status'],
    'payment_method': json['paymentMethod'] ?? json['payment_method'] ?? 'card',
    'address_id': (json['addressId'] ?? json['address_id'] ?? '').toString(),
    'shipping_cost': json['shippingCost'] ?? json['shipping_cost'] ?? 0.0,
    'total_amount': json['totalAmount'] ?? json['total_amount'] ?? 0.0,
    'tracking_number': json['trackingNumber'] ?? json['tracking_number'],
    'phone_number': json['phoneNumber'] ?? json['phone_number'],
    'order_items': json['items'] ?? json['order_items'],
  };
}

Map<String, dynamic> _mapItemJson(Map<String, dynamic> json) {
  return {
    ...json,
    'order_id': json['orderId'] ?? json['order_id'],
    'product_id': json['productId'] ?? json['product_id'],
    'product_name': json['productName'] ?? json['product_name'],
    'unit_price': json['unitPrice'] ?? json['unit_price'],
    'image_url': json['imageUrl'] ?? json['image_url'],
  };
}