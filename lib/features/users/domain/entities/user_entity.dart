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

  UserEntity copyWith({
    int? id,
    String? name,
    String? email,
    String? photoUrl,
    String? phoneNumber,
    String? role,
    bool? isActive,
    DateTime? createdAt,
    DateTime? lastLogin,
    double? totalSpent,
    int? ordersCount,
    List<UserAddressEntity>? addresses,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      totalSpent: totalSpent ?? this.totalSpent,
      ordersCount: ordersCount ?? this.ordersCount,
      addresses: addresses ?? this.addresses,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          email == other.email &&
          photoUrl == other.photoUrl &&
          phoneNumber == other.phoneNumber &&
          role == other.role &&
          isActive == other.isActive &&
          totalSpent == other.totalSpent &&
          ordersCount == other.ordersCount;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      email.hashCode ^
      photoUrl.hashCode ^
      phoneNumber.hashCode ^
      role.hashCode ^
      isActive.hashCode ^
      totalSpent.hashCode ^
      ordersCount.hashCode;

  @override
  String toString() =>
      'UserEntity(id: $id, name: $name, email: $email, role: $role, isActive: $isActive)';
}
