import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles_dashboard/data/models/address_model.dart';
import 'package:stronger_muscles_dashboard/features/users/data/models/user_model.dart';
import '../../domain/entities/order_entity.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

@freezed
@HiveType(typeId: 11)
class OrderModel with _$OrderModel {
  const OrderModel._();

  const factory OrderModel({
    @HiveField(0) required String id,
    @HiveField(1) required String userId,
    @HiveField(2) required DateTime orderDate,
    @HiveField(3) @Default(OrderStatus.pending) OrderStatus status,
    @HiveField(4) @Default(PaymentStatus.pending) PaymentStatus paymentStatus,
    @HiveField(5) @Default('card') String paymentMethod,
    @HiveField(6) required String addressId,
    @HiveField(7) required double subtotal,
    @HiveField(8) @Default(0.0) double shippingCost,
    @HiveField(9) @Default(0.0) double discount,
    @HiveField(10) required double totalAmount,
    @HiveField(11) String? trackingNumber,
    @HiveField(12) String? notes,
    @HiveField(13) String? phoneNumber,
    @HiveField(14) AddressModel? shippingAddress,
    @HiveField(15) List<OrderItemModel>? items,
    @HiveField(16) UserModel? user,
    @HiveField(17, defaultValue: 0.0) @Default(0.0) double taxAmount,
  }) = _OrderModel;

  String get userName => user?.name ?? 'User $userId';
  String get userEmail => user?.email ?? 'No email';
  String? get userPhoto => user?.photoUrl;

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(_mapOrderJson(json));

  factory OrderModel.empty() => OrderModel(
        id: '',
        userId: '',
        orderDate: DateTime.now(),
        status: OrderStatus.pending,
        paymentStatus: PaymentStatus.pending,
        paymentMethod: 'card',
        addressId: '',
        subtotal: 0.0,
        shippingCost: 0.0,
        discount: 0.0,
        totalAmount: 0.0,
        items: const [],
      );

  /// تحليل كائن طلب منفرد بأمان في Isolate خلفي لمنع تجميد واجهة المستخدم
  static Future<OrderModel> fromJsonAsync(dynamic json) async {
    return await compute(_parseOrderIsolate, json);
  }

  /// تحليل قائمة طلبات كاملة في Isolate خلفي لمنع تجميد الشاشة أثناء استلام الحمولات الكبيرة
  static Future<List<OrderModel>> fromJsonListAsync(dynamic data) async {
    return await compute(_parseOrderListIsolate, data);
  }
}

@freezed
@HiveType(typeId: 12)
class OrderItemModel with _$OrderItemModel {
  const OrderItemModel._();

  const factory OrderItemModel({
    @HiveField(0) required String id,
    @HiveField(1) required String orderId,
    @HiveField(2) required String productId,
    @HiveField(3) required String productName,
    @HiveField(4) required double unitPrice,
    @HiveField(5) required int quantity,
    @HiveField(6) required double subtotal,
    @HiveField(7) String? imageUrl,
    @HiveField(8) String? selectedFlavor,
    @HiveField(9) String? selectedSize,
    @HiveField(10) String? fullName,
  }) = _OrderItemModel;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemModelFromJson(_mapItemJson(json));
}

// ==========================================
// Isolate Functions (Top-Level)
// ==========================================

OrderModel _parseOrderIsolate(dynamic data) {
  if (data is Map) {
    try {
      return OrderModel.fromJson(Map<String, dynamic>.from(data));
    } catch (e) {
      debugPrint('⚠️ Error parsing single order in Isolate: $e');
    }
  }
  return OrderModel.empty();
}

List<OrderModel> _parseOrderListIsolate(dynamic data) {
  final list = <OrderModel>[];
  if (data is! List) return list;
  for (final item in data) {
    if (item is Map) {
      try {
        list.add(OrderModel.fromJson(Map<String, dynamic>.from(item)));
      } catch (e) {
        debugPrint('⚠️ Error parsing order in Isolate: $e');
      }
    }
  }
  return list;
}

// ==========================================
// Robust Safe Parsing & Data Mapping Helpers
// ==========================================

Map<String, dynamic> _mapOrderJson(Map<String, dynamic> rawJson) {
  Map<String, dynamic> json = Map<String, dynamic>.from(rawJson);

  // Unwrap if wrapped in Laravel response (e.g. {"status": "success", "data": {...}})
  while (json.containsKey('data') && json['data'] is Map) {
    final inner = json['data'] as Map;
    if (inner.containsKey('id') ||
        inner.containsKey('user_id') ||
        inner.containsKey('userId') ||
        inner.containsKey('status') ||
        inner.containsKey('total_amount')) {
      json = Map<String, dynamic>.from(inner);
    } else {
      break;
    }
  }

  String extractUserId() {
    if (json['userId'] != null) return json['userId'].toString();
    if (json['user_id'] != null) return json['user_id'].toString();
    if (json['user'] is Map) return (json['user']['id'] ?? '').toString();
    return '';
  }

  String sanitizeOrderStatus(dynamic val) {
    if (val == null) return 'pending';
    final str = val.toString().trim().toLowerCase();
    if (str == 'canceled') return 'cancelled';
    const valid = [
      'pending',
      'processing',
      'shipped',
      'delivered',
      'cancelled',
    ];
    if (valid.contains(str)) {
      return str;
    }
    return 'pending';
  }

  String sanitizePaymentStatus(dynamic val) {
    if (val == null) return 'pending';
    final str = val.toString().trim().toLowerCase();
    const valid = ['pending', 'paid', 'failed', 'refunded'];
    if (valid.contains(str)) {
      return str;
    }
    return 'pending';
  }

  String sanitizeDate(dynamic val) {
    if (val == null) return DateTime.now().toIso8601String();
    if (val is DateTime) return val.toIso8601String();
    final str = val.toString().trim();
    if (str.isEmpty) return DateTime.now().toIso8601String();
    final parsed = DateTime.tryParse(str);
    if (parsed != null) return parsed.toIso8601String();
    return DateTime.now().toIso8601String();
  }

  dynamic rawAddress = json['shipping_address'] ?? json['shippingAddress'];
  final mappedAddress = _safeAddressMap(rawAddress);

  final itemsList = _sanitizeItems(json['order_items'] ?? json['items']);

  final subtotal = _parseDouble(json['subtotal']);
  final shippingCost = _parseDouble(json['shippingCost'] ?? json['shipping_cost']);
  final discount = _parseDouble(json['discount'] ?? json['discount_amount']);
  final taxAmount = _parseDouble(json['taxAmount'] ?? json['tax_amount']);
  var totalAmount = _parseDouble(json['total_amount'] ?? json['totalAmount']);
  if (totalAmount == 0.0 && subtotal > 0.0) {
    totalAmount = (subtotal + shippingCost + taxAmount - discount).clamp(0.0, double.infinity);
  }

  return {
    ...json,
    'id': (json['id'] ?? '').toString(),
    'userId': extractUserId(),
    'orderDate': sanitizeDate(json['order_date'] ?? json['orderDate']),
    'status': sanitizeOrderStatus(json['status']),
    'paymentStatus': sanitizePaymentStatus(
      json['payment_status'] ?? json['paymentStatus'],
    ),
    'addressId': (json['address_id'] ?? json['addressId'] ?? '').toString(),
    'shippingCost': shippingCost,
    'taxAmount': taxAmount,
    'totalAmount': totalAmount,
    'subtotal': subtotal,
    'discount': discount,
    'items': itemsList,
    'paymentMethod': (json['payment_method'] ?? json['paymentMethod'] ?? 'card').toString(),
    'trackingNumber': json['tracking_number']?.toString() ?? json['trackingNumber']?.toString(),
    'notes': json['notes']?.toString(),
    'phoneNumber':
        json['phone']?.toString() ??
        json['phone_number']?.toString() ??
        json['phoneNumber']?.toString() ??
        mappedAddress?['phone']?.toString(),
    'shippingAddress': mappedAddress,
    'user': _mapUserJson(json['user'], extractUserId()),
  };
}

Map<String, dynamic>? _safeAddressMap(dynamic rawAddress) {
  if (rawAddress == null) return null;
  dynamic mapped;
  if (rawAddress is String && rawAddress.isNotEmpty) {
    try {
      mapped = jsonDecode(rawAddress);
    } catch (_) {
      mapped = {
        'id': 0,
        'street': rawAddress,
        'city': 'Unknown',
        'state': '',
        'postal_code': '',
        'country': '',
      };
    }
  } else {
    mapped = rawAddress;
  }
  if (mapped is! Map) return null;
  final map = Map<String, dynamic>.from(mapped);
  return {
    ...map,
    'id': _parseInt(map['id']),
    'street': (map['street'] ?? map['address'] ?? 'Unknown').toString(),
    'city': (map['city'] ?? 'Unknown').toString(),
    'state': map['state']?.toString(),
    'postal_code': (map['postal_code'] ?? map['postalCode'])?.toString(),
    'country': map['country']?.toString(),
    'phone': map['phone']?.toString(),
  };
}

List<dynamic> _sanitizeItems(dynamic val) {
  if (val == null || val is! List) return const [];
  final validItems = <dynamic>[];
  for (final item in val) {
    if (item is Map) {
      validItems.add(Map<String, dynamic>.from(item));
    }
  }
  return validItems;
}

Map<String, dynamic>? _mapUserJson(dynamic json, [String fallbackUserId = '']) {
  if (json == null) return null;
  if (json is! Map) return null;
  final map = Map<String, dynamic>.from(json);
  final userId = _parseInt(map['id'] ?? fallbackUserId);
  return {
    ...map,
    'id': userId,
    'name': (map['name'] ?? (fallbackUserId.isNotEmpty ? 'User $fallbackUserId' : 'عميل')).toString(),
    'email': map['email']?.toString(),
    'photo_url': map['photo_url'] ?? map['photoUrl'],
    'phone_number': map['phone_number'] ?? map['phoneNumber'] ?? map['phone'],
  };
}

Map<String, dynamic> _mapItemJson(Map<String, dynamic> json) {
  final unitPrice = _parseDouble(json['unit_price'] ?? json['unitPrice']);
  final quantity = _parseInt(json['quantity'] ?? 1);
  var subtotal = _parseDouble(json['subtotal']);
  if (subtotal == 0.0 && unitPrice > 0.0) {
    subtotal = unitPrice * quantity;
  }

  return {
    ...json,
    'id': (json['id'] ?? '').toString(),
    'orderId': (json['order_id'] ?? json['orderId'] ?? '').toString(),
    'productId': (json['product_id'] ?? json['productId'] ?? '').toString(),
    'productName': (json['product_name'] ?? json['productName'] ?? 'منتج').toString(),
    'unitPrice': unitPrice,
    'quantity': quantity < 1 ? 1 : quantity,
    'subtotal': subtotal,
    'imageUrl': json['image_url'] ?? json['imageUrl'],
    'selectedFlavor': json['selectedFlavor'] ?? json['flavor'],
    'selectedSize': json['selectedSize'] ?? json['size'],
  };
}

double _parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

int _parseInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}
