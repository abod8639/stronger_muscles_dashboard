import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles_dashboard/models/user_address.dart';

part 'dashboard_user_model.freezed.dart';
part 'dashboard_user_model.g.dart';

@freezed
class DashboardResponse with _$DashboardResponse {
  const factory DashboardResponse({
    @Default(0) int totalUsers,
    @Default([]) List<DashboardUser> users,
  }) = _DashboardResponse;

  factory DashboardResponse.fromJson(Map<String, dynamic> json) => 
      _$DashboardResponseFromJson(json);
}

@freezed
@HiveType(typeId: 17) // تأكد من استخدام TypeId غير محجوز
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
      _$DashboardUserFromJson(json);

}