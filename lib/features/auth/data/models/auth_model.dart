import '../../domain/entities/auth_entity.dart';

class AuthModel extends AuthEntity {
  const AuthModel({
    required super.id,
    required super.name,
    required super.email,
    super.role = 'admin',
    super.token,
    super.profileImage,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] ?? json;
    return AuthModel(
      id: user['id']?.toString() ?? '',
      name: user['name']?.toString() ?? '',
      email: user['email']?.toString() ?? '',
      role: user['role']?.toString() ?? json['role']?.toString() ?? 'admin',
      token: json['token']?.toString() ?? json['access_token']?.toString(),
      profileImage: user['profile_image']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'token': token,
      'profile_image': profileImage,
    };
  }
}
