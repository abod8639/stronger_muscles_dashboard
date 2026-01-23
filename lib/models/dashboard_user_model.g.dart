// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DashboardUserAdapter extends TypeAdapter<DashboardUser> {
  @override
  final int typeId = 17;

  @override
  DashboardUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DashboardUser(
      id: fields[0] as int,
      name: fields[1] as String,
      email: fields[2] as String?,
      phone: fields[3] as String?,
      role: fields[4] as String,
      isActive: fields[5] as bool,
      photoUrl: fields[6] as String?,
      totalSpent: fields[7] as double,
      createdAt: fields[8] as DateTime?,
      lastLogin: fields[9] as DateTime?,
      addresses: (fields[10] as List).cast<UserAddress>(),
      ordersCount: fields[11] as int,
    );
  }

  @override
  void write(BinaryWriter writer, DashboardUser obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.phone)
      ..writeByte(4)
      ..write(obj.role)
      ..writeByte(5)
      ..write(obj.isActive)
      ..writeByte(6)
      ..write(obj.photoUrl)
      ..writeByte(7)
      ..write(obj.totalSpent)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.lastLogin)
      ..writeByte(10)
      ..write(obj.addresses)
      ..writeByte(11)
      ..write(obj.ordersCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DashboardUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DashboardResponseImpl _$$DashboardResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$DashboardResponseImpl(
      totalUsers: (json['total_users'] as num?)?.toInt() ?? 0,
      users: (json['users'] as List<dynamic>?)
              ?.map((e) => DashboardUser.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$DashboardResponseImplToJson(
        _$DashboardResponseImpl instance) =>
    <String, dynamic>{
      'total_users': instance.totalUsers,
      'users': instance.users,
    };

_$DashboardUserImpl _$$DashboardUserImplFromJson(Map<String, dynamic> json) =>
    _$DashboardUserImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String? ?? '',
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      role: json['role'] as String? ?? 'customer',
      isActive: json['is_active'] as bool? ?? true,
      photoUrl: json['photo_url'] as String?,
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

Map<String, dynamic> _$$DashboardUserImplToJson(_$DashboardUserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'role': instance.role,
      'is_active': instance.isActive,
      'photo_url': instance.photoUrl,
      'total_spent': instance.totalSpent,
      'created_at': instance.createdAt?.toIso8601String(),
      'last_login': instance.lastLogin?.toIso8601String(),
      'addresses': instance.addresses.map((e) => e.toJson()).toList(),
      'orders_count': instance.ordersCount,
    };
