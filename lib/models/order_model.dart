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
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'order_date') required DateTime orderDate,
    @Default(OrderStatus.pending) OrderStatus status,
    @JsonKey(name: 'payment_status') @Default(PaymentStatus.pending) PaymentStatus paymentStatus,
    @JsonKey(name: 'payment_method') @Default('card') String paymentMethod,
    @JsonKey(name: 'address_id') required String addressId,
    @JsonKey(name: 'shipping_address_snapshot') Map<String, dynamic>? shippingAddressSnapshot,
    required double subtotal,
    @JsonKey(name: 'shipping_cost') @Default(0.0) double shippingCost,
    @Default(0.0) double discount,
    @JsonKey(name: 'total_amount') required double totalAmount,
    @JsonKey(name: 'tracking_number') String? trackingNumber,
    String? notes,
    @JsonKey(name: 'phone_number') String? phoneNumber,
    @JsonKey(name: 'order_items') List<OrderItemModel>? items,
  }) = _OrderModel;

  factory OrderModel.fromJson(Map<String, dynamic> json) => 
      _$OrderModelFromJson(_mapOrderJson(json));
}

@freezed
class OrderItemModel with _$OrderItemModel {
  const factory OrderItemModel({
    required String id,
    @JsonKey(name: 'order_id') required String orderId,
    @JsonKey(name: 'product_id') required String productId,
    @JsonKey(name: 'product_name') required String productName,
    @JsonKey(name: 'unit_price') required double unitPrice,
    required int quantity,
    required double subtotal,
    @JsonKey(name: 'image_url') String? imageUrl,
  }) = _OrderItemModel;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) => 
      _$OrderItemModelFromJson(_mapItemJson(json));
}

// --- دالات معالجة البيانات لضمان التوافق مع أسماء الحقول المختلفة (Mapping) ---

Map<String, dynamic> _mapOrderJson(Map<String, dynamic> json) {
  return {
    ...json,
    'user_id': json['userId'] ?? json['user_id'],
    'order_date': json['orderDate'] ?? json['order_date'],
    'payment_status': json['paymentStatus'] ?? json['payment_status'],
    'payment_method': json['paymentMethod'] ?? json['payment_method'],
    'address_id': json['addressId'] ?? json['address_id'],
    'shipping_cost': json['shippingCost'] ?? json['shipping_cost'],
    'total_amount': json['totalAmount'] ?? json['total_amount'],
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