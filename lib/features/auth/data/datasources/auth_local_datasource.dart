import 'package:get_storage/get_storage.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  String? getToken();
  Future<void> clearToken();
  bool hasToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final GetStorage storage;
  static const String _tokenKey = 'admin_token';

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
  Future<void> clearToken() async {
    await storage.remove(_tokenKey);
  }

  @override
  bool hasToken() {
    return storage.hasData(_tokenKey);
  }
}
