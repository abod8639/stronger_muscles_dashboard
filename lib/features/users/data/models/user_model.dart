import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'user_address.dart';
import '../../domain/entities/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
@HiveType(typeId: 16, adapterName: 'UserModelAdapter')
class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    @HiveField(0) required int id,
    @HiveField(1) required String name,
    @HiveField(2) String? email,
    @HiveField(3) @JsonKey(name: 'photo_url') String? photoUrl,
    @HiveField(4) @JsonKey(name: 'phone_number') String? phoneNumber,
    @HiveField(5) @Default('ar') String preferredLanguage,
    @HiveField(6) @Default(true) bool notificationsEnabled,
    @HiveField(7) @Default('user') String? role,
    @HiveField(8) @Default(true) @JsonKey(name: 'is_active') bool isActive,
    @HiveField(9) @Default(0.0) @JsonKey(name: 'total_spent') double totalSpent,
    @HiveField(10) @JsonKey(name: 'created_at') DateTime? createdAt,
    @HiveField(11) @JsonKey(name: 'last_login') DateTime? lastLogin,
    @HiveField(12) @Default([]) List<UserAddress> addresses,
    @HiveField(13) @Default(0) @JsonKey(name: 'orders_count') int ordersCount,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(_mapUserJson(json));

  UserEntity toEntity() => UserEntity(
        id: id,
        name: name,
        email: email,
        photoUrl: photoUrl,
        phoneNumber: phoneNumber,
        role: role ?? 'user',
        isActive: isActive,
        createdAt: createdAt,
        lastLogin: lastLogin,
        totalSpent: totalSpent,
        ordersCount: ordersCount,
        addresses: addresses,
      );
}

Map<String, dynamic> _mapUserJson(Map<String, dynamic> json) {
  final Map<String, dynamic> data = Map<String, dynamic>.from(json);

  // Handle ID as string from API
  if (data['id'] is String) {
    data['id'] = int.tryParse(data['id']) ?? 0;
  }

  // Handle snake_case vs camelCase if needed, although JsonKey handles most
  data['photo_url'] = data['photo_url'] ?? data['photoUrl'];
  data['phone_number'] = data['phone_number'] ?? data['phone'] ?? data['phoneNumber'];
  data['total_spent'] = data['total_spent'] ?? data['totalSpent'] ?? 0.0;
  data['created_at'] = data['created_at'] ?? data['createdAt'];
  data['last_login'] = data['last_login'] ?? data['lastLogin'];
  data['orders_count'] = data['orders_count'] ?? data['ordersCount'] ?? 0;
  data['is_active'] = data['is_active'] ?? data['isActive'] ?? true;

  return data;
}
