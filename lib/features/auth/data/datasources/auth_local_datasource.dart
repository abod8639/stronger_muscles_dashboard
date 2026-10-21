import 'package:get_storage/get_storage.dart';
import 'package:stronger_muscles_dashboard/core/error/exceptions.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  String? getToken();
  Future<void> clearToken();
  bool hasToken();
  Future<void> saveUser(Map<String, dynamic> user);
  Map<String, dynamic>? getUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final GetStorage storage;
  static const String _tokenKey = 'admin_token';
  static const String _userKey = 'admin_user';

  AuthLocalDataSourceImpl(this.storage);

  @override
  Future<void> saveToken(String token) async {
    try {
      await storage.write(_tokenKey, token);
    } catch (e) {
      throw CacheException(
        message: 'فشل في حفظ رمز المصادقة محلياً',
        originalError: e,
      );
    }
  }

  @override
  String? getToken() {
    try {
      return storage.read(_tokenKey);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveUser(Map<String, dynamic> user) async {
    try {
      await storage.write(_userKey, user);
    } catch (e) {
      throw CacheException(
        message: 'فشل في حفظ بيانات المستخدم محلياً',
        originalError: e,
      );
    }
  }

  @override
  Map<String, dynamic>? getUser() {
    try {
      final data = storage.read(_userKey);
      if (data is Map) {
        return Map<String, dynamic>.from(data);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> clearToken() async {
    try {
      await storage.remove(_tokenKey);
      await storage.remove(_userKey);
    } catch (e) {
      throw CacheException(
        message: 'فشل في مسح بيانات الجلسة المحلية',
        originalError: e,
      );
    }
  }

  @override
  bool hasToken() {
    try {
      return storage.hasData(_tokenKey) && storage.read(_tokenKey) != null;
    } catch (_) {
      return false;
    }
  }
}
