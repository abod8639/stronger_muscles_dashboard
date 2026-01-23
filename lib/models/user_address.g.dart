// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_address.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAddressAdapter extends TypeAdapter<UserAddress> {
  @override
  final int typeId = 15;

  @override
  UserAddress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserAddress(
      id: fields[0] as int,
      city: fields[1] as String,
      street: fields[2] as String,
      isDefault: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, UserAddress obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.city)
      ..writeByte(2)
      ..write(obj.street)
      ..writeByte(3)
      ..write(obj.isDefault);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAddressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserAddress _$UserAddressFromJson(Map<String, dynamic> json) => UserAddress(
      id: (json['id'] as num).toInt(),
      city: json['city'] as String,
      street: json['street'] as String,
      isDefault: json['isDefault'] as bool,
    );

Map<String, dynamic> _$UserAddressToJson(UserAddress instance) =>
    <String, dynamic>{
      'id': instance.id,
      'city': instance.city,
      'street': instance.street,
      'isDefault': instance.isDefault,
    };

_$UserAddressImpl _$$UserAddressImplFromJson(Map<String, dynamic> json) =>
    _$UserAddressImpl(
      id: (json['id'] as num).toInt(),
      city: json['city'] as String? ?? '',
      street: json['street'] as String? ?? '',
      isDefault: json['isDefault'] as bool? ?? false,
    );

Map<String, dynamic> _$$UserAddressImplToJson(_$UserAddressImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'city': instance.city,
      'street': instance.street,
      'isDefault': instance.isDefault,
    };
