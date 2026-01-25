import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles_dashboard/models/user_address.dart';

part 'dashboard_user_model.freezed.dart';
part 'dashboard_user_model.g.dart';

@freezed
class DashboardResponse with _$DashboardResponse {
  const factory DashboardResponse({
    required int totalUsers,
    required List<DashboardUser> users,
  }) = _DashboardResponse;

  factory DashboardResponse.fromJson(Map<String, dynamic> json) =>
      _$DashboardResponseFromJson(_mapDashboardResponse(json));
}

@freezed
@HiveType(typeId: 17)
class DashboardUser with _$DashboardUser {
  const DashboardUser._();

  const factory DashboardUser({
    @HiveField(0) required int id,
    @HiveField(1) @Default('') String name,
    @HiveField(2) String? email,
    @HiveField(3) String? phone,
    @HiveField(4) @Default('customer') String role,
    @HiveField(5) @Default(true) bool isActive,
    @HiveField(6) String? photoUrl,
    @HiveField(7) @Default(0.0) double totalSpent,
    @HiveField(8) DateTime? createdAt,
    @HiveField(9) DateTime? lastLogin,
    @HiveField(10) @Default([]) List<UserAddress> addresses,
    @HiveField(11) @Default(0) int ordersCount,
  }) = _DashboardUser;

  factory DashboardUser.fromJson(Map<String, dynamic> json) =>
      _$DashboardUserFromJson(_mapDashboardUser(json));
}

Map<String, dynamic> _mapDashboardResponse(Map<String, dynamic> json) {
  return {
    ...json,
    'totalUsers': json['totalUsers'] ?? json['total_users'] ?? 0,
    'users': json['users'] ?? [],
  };
}

Map<String, dynamic> _mapDashboardUser(Map<String, dynamic> json) {
  return {
    ...json,
    'photoUrl': json['photoUrl'] ?? json['photo_url'],
    'totalSpent':
        double.tryParse(
          (json['totalSpent'] ?? json['total_spent'] ?? 0.0).toString(),
        ) ??
        0.0,
    'createdAt': json['createdAt'] ?? json['created_at'],
    'lastLogin': json['lastLogin'] ?? json['last_login'],
    'ordersCount': json['ordersCount'] ?? json['orders_count'] ?? 0,
    'isActive':
        json['isActive'] == true ||
        json['is_active'] == true ||
        json['is_active'] == 1,
  };
}
