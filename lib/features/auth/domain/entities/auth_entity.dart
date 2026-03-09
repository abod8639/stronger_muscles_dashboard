class AuthEntity {
  final String id;
  final String name;
  final String email;
  final String? token;
  final String? profileImage;

  const AuthEntity({
    required this.id,
    required this.name,
    required this.email,
    this.token,
    this.profileImage,
  });
}
