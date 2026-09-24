import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// Legacy Bridge for Auth Management
class AuthService extends GetxService {
  final GetStorage _storage = GetStorage();
  static const String _tokenKey = 'admin_token';
  static const String _userKey = 'admin_user';

  bool isLoggedIn() {
    return _storage.hasData(_tokenKey);
  }

  String? getToken() {
    return _storage.read(_tokenKey);
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

  Future<void> logout() async {
    await _storage.remove(_tokenKey);
    await _storage.remove(_userKey);
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
