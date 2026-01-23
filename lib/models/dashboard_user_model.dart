
import 'package:stronger_muscles_dashboard/models/user-address.dart';

class DashboardResponse {
  final int totalUsers;
  final List<DashboardUser> users;

  DashboardResponse({
    required this.totalUsers,
    required this.users
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      totalUsers: json['total_users'] ?? 0,
      users: (json['users'] as List<dynamic>?)
              ?.map((e) => DashboardUser.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class DashboardUser {
  final int id;
  final String name;
  final String? email;
  final String? phone;
  final String role;
  final bool isActive;
  final String? photoUrl;
  final double totalSpent;
  final DateTime? createdAt;
  final DateTime? lastLogin;
  final List<UserAddress> addresses;
  final int ordersCount;

  DashboardUser({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    required this.role,
    required this.isActive,
    this.photoUrl,
    required this.totalSpent,
    this.createdAt,
    this.lastLogin,
    required this.addresses,
    required this.ordersCount,
  });

  factory DashboardUser.fromJson(Map<String, dynamic> json) {
    return DashboardUser(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'],
      phone: json['phone'],
      role: json['role'] ?? 'customer',
      isActive: json['is_active'] ?? true,
      photoUrl: json['photo_url'],
      totalSpent: double.tryParse(json['total_spent'].toString()) ?? 0.0,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      lastLogin: json['last_login'] != null ? DateTime.parse(json['last_login']) : null,
      addresses: (json['addresses'] as List<dynamic>?)
              ?.map((e) => UserAddress.fromJson(e))
              .toList() ??
          [],
      ordersCount: json['orders_count'] ?? 0,
    );
  }
}
