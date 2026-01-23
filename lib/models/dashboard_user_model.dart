import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:stronger_muscles_dashboard/models/user-address.dart';

part 'dashboard_models.freezed.dart';
part 'dashboard_models.g.dart';

@freezed
class DashboardResponse with _$DashboardResponse {
  
  const factory DashboardResponse({
    @JsonKey(name: 'total_users') @Default(0) int totalUsers,
    @Default([]) List<DashboardUser> users,
  }) = _DashboardResponse;

  factory DashboardResponse.fromJson(Map<String, dynamic> json) => 
      _$DashboardResponseFromJson(json);
}

@freezed
class DashboardUser with _$DashboardUser {
  const factory DashboardUser({
    required int id,
    @Default('') String name,
    String? email,
    String? phone,
    @Default('customer') String role,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'photo_url') String? photoUrl,
    @JsonKey(name: 'total_spent', fromJson: _doubleFromString) @Default(0.0) double totalSpent,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'last_login') DateTime? lastLogin,
    @Default([]) List<UserAddress> addresses,
    @JsonKey(name: 'orders_count') @Default(0) int ordersCount,
  }) = _DashboardUser;

  factory DashboardUser.fromJson(Map<String, dynamic> json) => 
      _$DashboardUserFromJson(json);
}

// دالة مساعدة للتعامل مع تحويل double من String أو Num لضمان عدم حدوث Crash
double _doubleFromString(dynamic val) => 
    double.tryParse(val.toString()) ?? 0.0;