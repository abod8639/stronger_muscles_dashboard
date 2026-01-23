// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CartItemModelAdapter extends TypeAdapter<CartItemModel> {
  @override
  final int typeId = 14;

  @override
  CartItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CartItemModel(
      id: fields[0] as String,
      userId: fields[1] as String,
      productId: fields[2] as String,
      productName: fields[3] as String,
      price: fields[4] as double,
      quantity: fields[5] as int,
      imageUrls: (fields[6] as List).cast<String>(),
      addedAt: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, CartItemModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.productId)
      ..writeByte(3)
      ..write(obj.productName)
      ..writeByte(4)
      ..write(obj.price)
      ..writeByte(5)
      ..write(obj.quantity)
      ..writeByte(6)
      ..write(obj.imageUrls)
      ..writeByte(7)
      ..write(obj.addedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

// CartItemModel _$CartItemModelFromJson(Map<String, dynamic> json) =>
//     CartItemModel(
//       id: json['id'] as String,
//       userId: json['userId'] as String,
//       productId: json['productId'] as String,
//       productName: json['productName'] as String,
//       price: (json['price'] as num).toDouble(),
//       quantity: (json['quantity'] as num).toInt(),
//       imageUrls:
//           (json['imageUrls'] as List<dynamic>).map((e) => e as String).toList(),
//       addedAt: DateTime.parse(json['addedAt'] as String),
//     );

Map<String, dynamic> _$CartItemModelToJson(CartItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'productId': instance.productId,
      'productName': instance.productName,
      'price': instance.price,
      'quantity': instance.quantity,
      'imageUrls': instance.imageUrls,
      'addedAt': instance.addedAt.toIso8601String(),
    };

_$CartItemModelImpl _$$CartItemModelImplFromJson(Map<String, dynamic> json) =>
    _$CartItemModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      imageUrls: (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      addedAt: DateTime.parse(json['addedAt'] as String),
    );

Map<String, dynamic> _$$CartItemModelImplToJson(_$CartItemModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'productId': instance.productId,
      'productName': instance.productName,
      'price': instance.price,
      'quantity': instance.quantity,
      'imageUrls': instance.imageUrls,
      'addedAt': instance.addedAt.toIso8601String(),
    };
