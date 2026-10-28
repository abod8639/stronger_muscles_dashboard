/// Data Transfer Object (DTO) for authentication responses and payloads.
/// Strictly decoupled from Domain Entities with no class inheritance.
class AuthModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? token;
  final String? profileImage;

  const AuthModel({
    required this.id,
    required this.name,
    required this.email,
    this.role = 'admin',
    this.token,
    this.profileImage,
  });

  /// Resilient parsing safe against nested structures, type mismatches, and nulls
  factory AuthModel.fromJson(Map<String, dynamic> json) {
    final user = _extractUserMap(json);

    return AuthModel(
      id: _safeString(user['id'] ?? json['id'], fallback: '0'),
      name: _safeString(user['name'] ?? json['name'], fallback: 'مستخدم'),
      email: _safeString(user['email'] ?? json['email'], fallback: ''),
      role: _safeString(user['role'] ?? json['role'], fallback: 'admin'),
      token: _safeNullableString(
        json['token'] ??
            json['access_token'] ??
            user['token'] ??
            json['data']?['token'],
      ),
      profileImage: _safeNullableString(
        user['profile_image'] ??
            user['avatar'] ??
            json['profile_image'] ??
            user['photo_url'],
      ),
    );
  }

  static Map<String, dynamic> _extractUserMap(Map<String, dynamic> json) {
    if (json['user'] is Map) {
      return Map<String, dynamic>.from(json['user'] as Map);
    }
    if (json['data'] is Map && (json['data'] as Map)['user'] is Map) {
      return Map<String, dynamic>.from((json['data'] as Map)['user'] as Map);
    }
    if (json['data'] is Map) {
      return Map<String, dynamic>.from(json['data'] as Map);
    }
    return json;
  }

  static String _safeString(dynamic value, {String fallback = ''}) {
    if (value == null) return fallback;
    final str = value.toString().trim();
    return str.isEmpty ? fallback : str;
  }

  static String? _safeNullableString(dynamic value) {
    if (value == null) return null;
    final str = value.toString().trim();
    return str.isEmpty ? null : str;
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthModel &&
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
}
