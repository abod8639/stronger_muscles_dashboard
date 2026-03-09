import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// Legacy Bridge for Auth Management
class AuthService extends GetxService {
  final GetStorage _storage = GetStorage();
  static const String _tokenKey = 'admin_token';

  bool isLoggedIn() {
    return _storage.hasData(_tokenKey);
  }

  String? getToken() {
    return _storage.read(_tokenKey);
  }

  Future<void> saveToken(String token) async {
    await _storage.write(_tokenKey, token);
  }

  Future<void> logout() async {
    await _storage.remove(_tokenKey);
    Get.offAllNamed('/login');
  }

  Map<String, String> getAuthHeaders() {
    final token = getToken();
    return {
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
}
