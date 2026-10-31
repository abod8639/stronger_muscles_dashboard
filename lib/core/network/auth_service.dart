import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/core/storage/app_storage.dart';
import 'package:stronger_muscles_dashboard/core/router/app_router.dart';
import 'package:stronger_muscles_dashboard/core/router/app_routes.dart';

import 'package:stronger_muscles_dashboard/core/utils/ui_feedback.dart';

/// خدمة إدارة المصادقة والتوثيق
class AuthService {
  static final AuthService instance = AuthService();

  final GetStorage _storage = GetStorage();
  static const String _tokenKey = 'admin_token';
  static const String _userKey = 'admin_user';
  bool _isLoggingOut = false;

  bool isLoggedIn() {
    final token = getToken();
    return token != null && token.trim().isNotEmpty;
  }

  String? getToken() {
    final token = _storage.read(_tokenKey);
    return token?.toString();
  }

  Future<void> saveToken(String token) async {
    await _storage.write(_tokenKey, token);
  }

  Future<void> saveUser(Map<String, dynamic> user) async {
    await _storage.write(_userKey, user);
  }

  Map<String, dynamic>? getUser() {
    final data = _storage.read(_userKey);
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    return null;
  }

  String getUserName() {
    return getUser()?['name']?.toString() ?? 'Admin';
  }

  String getUserRole() {
    return getUser()?['role']?.toString() ?? 'admin';
  }

  Future<void> logout({bool sessionExpired = false}) async {
    if (_isLoggingOut) return;
    _isLoggingOut = true;
    try {
      await _storage.remove(_tokenKey);
      await _storage.remove(_userKey);
      if (sessionExpired) {
        AppFeedback.showWarning('انتهت الجلسة: يرجى تسجيل الدخول مجدداً');
      }
      appRouter.go(AppRoutes.login);
    } finally {
      Future.delayed(const Duration(seconds: 1), () {
        _isLoggingOut = false;
      });
    }
  }

  Map<String, String> getAuthHeaders() {
    final token = getToken();
    return {
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
}

/// موفر Riverpod لـ [AuthService]
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService.instance;
});
