import 'package:stronger_muscles_dashboard/data/models/address_model.dart';
import '../../domain/entities/address_entity.dart';
import '../../domain/entities/order_entity.dart';
import '../models/order_model.dart';

/// Extension mapper converting [OrderModel] DTO to domain [OrderEntity].
extension OrderModelMapper on OrderModel {
  OrderEntity toEntity() {
    return OrderEntity(
      id: id,
      userId: userId,
      userName: userName,
      userEmail: userEmail,
      userPhoto: userPhoto,
      phoneNumber: phoneNumber,
      totalAmount: totalAmount,
      subtotal: subtotal,
      shippingCost: shippingCost,
      discount: discount,
      status: status,
      paymentStatus: paymentStatus,
      paymentMethod: paymentMethod,
      addressId: addressId,
      shippingAddress: shippingAddress?.toEntity(),
      trackingNumber: trackingNumber,
      notes: notes,
      orderDate: orderDate,
      items: items?.map((e) => e.toEntity()).toList() ?? const [],
    );
  }
}

/// Extension mapper converting domain [OrderEntity] to [OrderModel] DTO.
extension OrderEntityMapper on OrderEntity {
  OrderModel toModel() {
    return OrderModel(
      id: id,
      userId: userId,
      orderDate: orderDate,
      status: status,
      paymentStatus: paymentStatus,
      paymentMethod: paymentMethod,
      addressId: addressId,
      subtotal: subtotal,
      shippingCost: shippingCost,
      discount: discount,
      totalAmount: totalAmount,
      trackingNumber: trackingNumber,
      notes: notes,
      phoneNumber: phoneNumber,
      shippingAddress: shippingAddress?.toModel(),
      items: items.map((e) => e.toModel()).toList(),
    );
  }
}

/// Extension mapper converting [OrderItemModel] DTO to domain [OrderItemEntity].
extension OrderItemModelMapper on OrderItemModel {
  OrderItemEntity toEntity() {
    return OrderItemEntity(
      id: id,
      productId: productId,
      productName: productName,
      quantity: quantity,
      unitPrice: unitPrice,
      subtotal: subtotal,
      imageUrl: imageUrl,
      selectedFlavor: selectedFlavor,
      selectedSize: selectedSize,
    );
  }
}

/// Extension mapper converting domain [OrderItemEntity] to [OrderItemModel] DTO.
extension OrderItemEntityMapper on OrderItemEntity {
  OrderItemModel toModel() {
    return OrderItemModel(
      id: id,
      orderId: '',
      productId: productId,
      productName: productName,
      quantity: quantity,
      unitPrice: unitPrice,
      subtotal: subtotal,
      imageUrl: imageUrl,
      selectedFlavor: selectedFlavor,
      selectedSize: selectedSize,
    );
  }
}

/// Extension mapper converting [AddressModel] DTO to domain [AddressEntity].
extension AddressModelOrderMapper on AddressModel {
  AddressEntity toEntity() {
    return AddressEntity(
      id: id,
      userId: userId,
      label: label,
      fullName: fullName,
      phone: phone,
      street: street,
      city: city,
      state: state,
      postalCode: postalCode,
      country: country,
      isDefault: isDefault,
      latitude: latitude,
      longitude: longitude,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

/// Extension mapper converting domain [AddressEntity] to [AddressModel] DTO.
extension AddressEntityOrderMapper on AddressEntity {
  AddressModel toModel() {
    return AddressModel(
      id: id,
      userId: userId,
      label: label,
      fullName: fullName,
      phone: phone,
      street: street,
      city: city,
      state: state,
      postalCode: postalCode,
      country: country,
      isDefault: isDefault,
      latitude: latitude,
      longitude: longitude,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
