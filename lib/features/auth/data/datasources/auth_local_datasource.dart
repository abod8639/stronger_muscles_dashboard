import 'package:get_storage/get_storage.dart';

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
    await storage.write(_tokenKey, token);
  }

  @override
  String? getToken() {
    return storage.read(_tokenKey);
  }

  @override
  Future<void> saveUser(Map<String, dynamic> user) async {
    await storage.write(_userKey, user);
  }

  @override
  Map<String, dynamic>? getUser() {
    final data = storage.read(_userKey);
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    return null;
  }

  @override
  Future<void> clearToken() async {
    await storage.remove(_tokenKey);
    await storage.remove(_userKey);
  }

  @override
  bool hasToken() {
    return storage.hasData(_tokenKey);
  }
}
