import 'package:flutter/foundation.dart';
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

  /// تحليل آمن ومقاوم لجميع أخطاء الـ Type / Null
  factory AuthModel.fromJson(Map<String, dynamic> json) {
    final user = _extractUserMap(json);

    return AuthModel(
      id: _safeString(user['id'] ?? json['id'], fallback: '0'),
      name: _safeString(user['name'] ?? json['name'], fallback: 'مستخدم'),
      email: _safeString(user['email'] ?? json['email'], fallback: ''),
      role: _safeString(
        user['role'] ?? json['role'],
        fallback: 'admin',
      ),
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

  /// استخراج كائن المستخدم سواء كان مفرداً أو مغلفاً داخل user أو data
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

  /// معالجة وتحليل الـ Payload في Isolate منفصل عبر `compute` لمنع تجميد واجهة المستخدم (UI Freezing)
  static Future<AuthModel> fromJsonAsync(Map<String, dynamic> json) async {
    return await compute(_parseAuthModelIsolate, json);
  }
}

/// دالة Top-level ليتم تمريرها للـ Isolate
AuthModel _parseAuthModelIsolate(Map<String, dynamic> json) {
  return AuthModel.fromJson(json);
}
