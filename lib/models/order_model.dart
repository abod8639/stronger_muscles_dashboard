import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

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
    @HiveField(14) Map<String, dynamic>? shippingAddressSnapshot,
    @HiveField(15) List<OrderItemModel>? items,
  }) = _OrderModel;

  String? get firstItemImageUrl {
    if (items != null && items!.isNotEmpty) {
      return items!.first.imageUrl;
    }
    return null;
  }

  String get formattedAddress {
    if (shippingAddressSnapshot == null) return 'العنوان غير متوفر';
    final addr = shippingAddressSnapshot!['address'] ?? shippingAddressSnapshot!;
    if (addr is String) return addr;
    final city = addr['city'] ?? addr['City'] ?? '';
    final street = addr['street'] ?? addr['Street'] ?? '';
    return [city, street].where((s) => s.toString().isNotEmpty).join(', ') 
           .isEmpty ? 'العنوان غير محدد' : [city, street].where((s) => s.toString().isNotEmpty).join(', ');
  }

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

  return {
    ...json,
    'id': (json['id'] ?? '').toString(),
    'userId': extractUserId(),
    'orderDate':
        json['orderDate'] ??
        json['order_date'] ??
        DateTime.now().toIso8601String(),
    'addressId': (json['addressId'] ?? json['address_id'] ?? '').toString(),
    'shippingCost': json['shippingCost'] ?? json['shipping_cost'] ?? 0.0,
    'totalAmount': json['totalAmount'] ?? json['total_amount'] ?? 0.0,
    'items': json['items'] ?? json['order_items'],
    'paymentStatus': json['paymentStatus'] ?? json['payment_status'],
    'paymentMethod': json['paymentMethod'] ?? json['payment_method'] ?? 'card',
    'trackingNumber': json['trackingNumber'] ?? json['tracking_number'],
    'phoneNumber': json['phoneNumber'] ?? json['phone_number'],
    'shippingAddressSnapshot':
        json['shippingAddressSnapshot'] ?? json['shipping_address_snapshot'],
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
