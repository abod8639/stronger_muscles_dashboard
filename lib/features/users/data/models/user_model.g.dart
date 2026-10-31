// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 16;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      id: fields[0] as int,
      name: fields[1] as String,
      email: fields[2] as String?,
      photoUrl: fields[3] as String?,
      phoneNumber: fields[4] as String?,
      preferredLanguage: fields[5] as String,
      notificationsEnabled: fields[6] as bool,
      role: fields[7] as String?,
      isActive: fields[8] as bool,
      totalSpent: fields[9] as double,
      createdAt: fields[10] as DateTime?,
      lastLogin: fields[11] as DateTime?,
      addresses: (fields[12] as List).cast<UserAddress>(),
      ordersCount: fields[13] as int,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.photoUrl)
      ..writeByte(4)
      ..write(obj.phoneNumber)
      ..writeByte(5)
      ..write(obj.preferredLanguage)
      ..writeByte(6)
      ..write(obj.notificationsEnabled)
      ..writeByte(7)
      ..write(obj.role)
      ..writeByte(8)
      ..write(obj.isActive)
      ..writeByte(9)
      ..write(obj.totalSpent)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.lastLogin)
      ..writeByte(12)
      ..write(obj.addresses)
      ..writeByte(13)
      ..write(obj.ordersCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      email: json['email'] as String?,
      photoUrl: json['photo_url'] as String?,
      phoneNumber: json['phone_number'] as String?,
      preferredLanguage: json['preferredLanguage'] as String? ?? 'ar',
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      role: json['role'] as String? ?? 'user',
      isActive: json['is_active'] as bool? ?? true,
      totalSpent: (json['total_spent'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      lastLogin: json['last_login'] == null
          ? null
          : DateTime.parse(json['last_login'] as String),
      addresses: (json['addresses'] as List<dynamic>?)
              ?.map((e) => UserAddress.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      ordersCount: (json['orders_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'photo_url': instance.photoUrl,
      'phone_number': instance.phoneNumber,
      'preferredLanguage': instance.preferredLanguage,
      'notificationsEnabled': instance.notificationsEnabled,
      'role': instance.role,
      'is_active': instance.isActive,
      'total_spent': instance.totalSpent,
      'created_at': instance.createdAt?.toIso8601String(),
      'last_login': instance.lastLogin?.toIso8601String(),
      'addresses': instance.addresses,
      'orders_count': instance.ordersCount,
    };
