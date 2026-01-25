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
  Map<String, dynamic> json,
) => _$DashboardResponseImpl(
  totalUsers: (json['totalUsers'] as num).toInt(),
  users: (json['users'] as List<dynamic>)
      .map((e) => DashboardUser.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$DashboardResponseImplToJson(
  _$DashboardResponseImpl instance,
) => <String, dynamic>{
  'totalUsers': instance.totalUsers,
  'users': instance.users,
};

_$DashboardUserImpl _$$DashboardUserImplFromJson(Map<String, dynamic> json) =>
    _$DashboardUserImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String? ?? '',
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      role: json['role'] as String? ?? 'customer',
      isActive: json['isActive'] as bool? ?? true,
      photoUrl: json['photoUrl'] as String?,
      totalSpent: (json['totalSpent'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      lastLogin: json['lastLogin'] == null
          ? null
          : DateTime.parse(json['lastLogin'] as String),
      addresses:
          (json['addresses'] as List<dynamic>?)
              ?.map((e) => UserAddress.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      ordersCount: (json['ordersCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$DashboardUserImplToJson(_$DashboardUserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'role': instance.role,
      'isActive': instance.isActive,
      'photoUrl': instance.photoUrl,
      'totalSpent': instance.totalSpent,
      'createdAt': instance.createdAt?.toIso8601String(),
      'lastLogin': instance.lastLogin?.toIso8601String(),
      'addresses': instance.addresses,
      'ordersCount': instance.ordersCount,
    };
