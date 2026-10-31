import 'package:stronger_muscles_dashboard/core/storage/app_storage.dart';
import 'package:stronger_muscles_dashboard/core/error/exceptions.dart';

/// Contract for caching tokens and session data locally.
abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();
  Future<bool> hasToken();
  Future<void> saveUser(Map<String, dynamic> userJson);
  Future<Map<String, dynamic>?> getUser();
  Future<void> clearAll();
}

/// Production implementation of [AuthLocalDataSource] using [GetStorage].
/// Fully testable via Constructor Dependency Injection.
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final GetStorage _storage;

  static const String _tokenKey = 'admin_token';
  static const String _userKey = 'admin_user';

  const AuthLocalDataSourceImpl({required GetStorage storage})
    : _storage = storage;

  @override
  Future<void> saveToken(String token) async {
    try {
      await _storage.write(_tokenKey, token);
    } catch (e) {
      throw CacheException(
        message: 'فشل في حفظ رمز المصادقة محلياً',
        originalError: e,
      );
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      final token = _storage.read<String>(_tokenKey);
      return token;
    } catch (e) {
      throw CacheException(
        message: 'فشل في قراءة رمز المصادقة من الذاكرة المحلية',
        originalError: e,
      );
    }
  }

  @override
  Future<void> clearToken() async {
    try {
      await _storage.remove(_tokenKey);
    } catch (e) {
      throw CacheException(
        message: 'فشل في مسح رمز المصادقة من الذاكرة المحلية',
        originalError: e,
      );
    }
  }

  @override
  Future<bool> hasToken() async {
    try {
      final token = _storage.read<String>(_tokenKey);
      return token != null && token.trim().isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> saveUser(Map<String, dynamic> userJson) async {
    try {
      await _storage.write(_userKey, userJson);
    } catch (e) {
      throw CacheException(
        message: 'فشل في حفظ بيانات المستخدم محلياً',
        originalError: e,
      );
    }
  }

  @override
  Future<Map<String, dynamic>?> getUser() async {
    try {
      final data = _storage.read(_userKey);
      if (data is Map) {
        return Map<String, dynamic>.from(data);
      }
      return null;
    } catch (e) {
      throw CacheException(
        message: 'فشل في قراءة بيانات المستخدم من الذاكرة المحلية',
        originalError: e,
      );
    }
  }

  @override
  Future<void> clearAll() async {
    try {
      await _storage.remove(_tokenKey);
      await _storage.remove(_userKey);
    } catch (e) {
      throw CacheException(
        message: 'فشل في مسح بيانات الجلسة المحلية',
        originalError: e,
      );
    }
  }
}
