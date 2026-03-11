import 'user_address_entity.dart';

class UserEntity {
  final int id;
  final String name;
  final String? email;
  final String? photoUrl;
  final String? phoneNumber;
  final String role;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? lastLogin;
  final double totalSpent;
  final int ordersCount;
  final List<UserAddressEntity> addresses;

  const UserEntity({
    required this.id,
    required this.name,
    this.email,
    this.photoUrl,
    this.phoneNumber,
    this.role = 'customer',
    this.isActive = true,
    this.createdAt,
    this.lastLogin,
    this.totalSpent = 0.0,
    this.ordersCount = 0,
    this.addresses = const [],
  });
}
