import '../../domain/entities/auth_entity.dart';

class AuthModel extends AuthEntity {
  const AuthModel({
    required super.id,
    required super.name,
    required super.email,
    super.token,
    super.profileImage,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] ?? json;
    return AuthModel(
      id: user['id']?.toString() ?? '',
      name: user['name']?.toString() ?? '',
      email: user['email']?.toString() ?? '',
      token: json['token']?.toString() ?? json['access_token']?.toString(),
      profileImage: user['profile_image']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'token': token,
      'profile_image': profileImage,
    };
  }
}
