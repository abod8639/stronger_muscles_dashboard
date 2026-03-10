import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles_dashboard/data/models/address_model.dart';
import 'package:stronger_muscles_dashboard/features/users/data/models/user_model.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

@HiveType(typeId: 9)
enum OrderStatus {
  @HiveField(0)
  pending,
  @HiveField(1)
  processing,
  @HiveField(2)
  shipped,
  @HiveField(3)
  delivered,
  @HiveField(4)
  cancelled,
}

@HiveType(typeId: 10)
enum PaymentStatus {
  @HiveField(0)
  pending,
  @HiveField(1)
  paid,
  @HiveField(2)
  failed,
  @HiveField(3)
  refunded,
}

@freezed
@HiveType(typeId: 11) // إضافة HiveType للكلاس
class OrderModel with _$OrderModel {
  // إضافة constructor خاص لتمكين إضافة methods أو getters
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
  }) = _OrderModel;

  String get userName => user?.name ?? 'User $userId';
  String get userEmail => user?.email ?? 'No email';
  String? get userPhoto => user?.photoUrl;

  String? get firstItemImageUrl {
    if (items != null && items!.isNotEmpty) {
      return items!.first.imageUrl;
    }
    return null;
  }

  // String get formattedAddress {
  //   if (shippingAddress == null) return 'العنوان غير متوفر';
  //   if (shippingAddress is String) return shippingAddress as String;

  //   if (shippingAddress is Map) {
  //     final addr = shippingAddress['address'] ?? shippingAddress;
  //     if (addr is String) return addr;

  //     final city = addr['city'] ?? addr['City'] ?? '';
  //     final street = addr['street'] ?? addr['Street'] ?? '';
  //     final formatted = [city, street].where((s) => s.toString().isNotEmpty).join(', ');
  //     return formatted.isEmpty ? 'العنوان غير محدد' : formatted;
  //   }

  //   return shippingAddress.toString();
  // }

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(_mapOrderJson(json));
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

// --- دالات معالجة البيانات (تأكد أنها خارج الكلاسات) ---

Map<String, dynamic> _mapOrderJson(Map<String, dynamic> json) {
  String extractUserId() {
    if (json['userId'] != null) return json['userId'].toString();
    if (json['user_id'] != null) return json['user_id'].toString();
    if (json['user'] is Map) return (json['user']['id'] ?? '').toString();
    return '';
  }

  dynamic rawAddress = json['shipping_address'] ?? json['shippingAddress'];
  dynamic mappedAddress;

  if (rawAddress is String && rawAddress.isNotEmpty) {
    try {
      mappedAddress = jsonDecode(rawAddress);
    } catch (_) {
      mappedAddress = {
        'id': 0,
        'street': rawAddress,
        'city': 'Unknown',
        'state': '',
        'postal_code': '',
        'country': '',
      };
    }
  } else {
    mappedAddress = rawAddress;
  }

  return {
    ...json,
    'id': (json['id'] ?? '').toString(),
    'userId': extractUserId(),
    'fullName': json['full_name'] ?? json['fullName'],
    'orderDate':
        json['order_date'] ??
        json['orderDate'] ??
        DateTime.now().toIso8601String(),
    'addressId': (json['address_id'] ?? json['addressId'] ?? '').toString(),
    'shippingCost': _parseDouble(json['shippingCost'] ?? json['shipping_cost']),
    'totalAmount': _parseDouble(json['total_amount'] ?? json['totalAmount']),
    'subtotal': _parseDouble(json['subtotal']),
    'discount': _parseDouble(json['discount'] ?? json['discount_amount']),
    'items': json['order_items'] ?? json['items'],
    'paymentStatus': json['payment_status'] ?? json['paymentStatus'],
    'paymentMethod': json['payment_method'] ?? json['paymentMethod'] ?? 'card',
    'trackingNumber': json['tracking_number'] ?? json['trackingNumber'],
    'phoneNumber':
        json['phone'] ??
        json['phone_number'] ??
        json['phoneNumber'] ??
        mappedAddress?['phone'],
    'shippingAddress': mappedAddress,
    'user': _mapUserJson(json['user']),
  };
}

Map<String, dynamic>? _mapUserJson(dynamic json) {
  if (json == null) return null;
  if (json is! Map) return null;

  return {...json, 'id': _parseInt(json['id'])};
}

Map<String, dynamic> _mapItemJson(Map<String, dynamic> json) {
  return {
    ...json,
    'id': (json['id'] ?? '').toString(),
    'orderId': (json['order_id'] ?? json['orderId'] ?? '').toString(),
    'productId': (json['product_id'] ?? json['productId'] ?? '').toString(),
    'productName': (json['product_name'] ?? json['productName'] ?? '')
        .toString(),
    'unitPrice': _parseDouble(json['unit_price'] ?? json['unitPrice']),
    'quantity': _parseInt(json['quantity'] ?? 1),
    'subtotal': _parseDouble(json['subtotal']),
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
