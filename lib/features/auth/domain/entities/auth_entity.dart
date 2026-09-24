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

  bool get isSuperAdmin => role == 'super_admin';
  bool get canManageUsers => role == 'super_admin' || role == 'admin';
  bool get canManageProducts => role != 'customer_support';
  bool get canManageCategories => role != 'customer_support';
  bool get canManageOrders => true;
}
