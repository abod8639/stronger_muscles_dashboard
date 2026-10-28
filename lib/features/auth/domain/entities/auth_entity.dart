/// 100% Pure Dart Domain Entity representing the authenticated administrator.
/// Strictly isolated with zero external dependencies (no Flutter, Dio, or storage packages).
class AuthEntity {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? token;
  final String? profileImage;

  const AuthEntity({
    required this.id,
    required this.name,
    required this.email,
    this.role = 'admin',
    this.token,
    this.profileImage,
  });

  /// Domain authorization rules
  bool get isSuperAdmin => role == 'super_admin';
  bool get canManageUsers => role == 'super_admin' || role == 'admin';
  bool get canManageProducts => role != 'customer_support';
  bool get canManageCategories => role != 'customer_support';
  bool get canManageOrders => true;

  AuthEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? token,
    String? profileImage,
  }) {
    return AuthEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      token: token ?? this.token,
      profileImage: profileImage ?? this.profileImage,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          email == other.email &&
          role == other.role &&
          token == other.token &&
          profileImage == other.profileImage;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      email.hashCode ^
      role.hashCode ^
      token.hashCode ^
      profileImage.hashCode;

  @override
  String toString() =>
      'AuthEntity(id: $id, name: $name, email: $email, role: $role, hasToken: ${token != null})';
}
