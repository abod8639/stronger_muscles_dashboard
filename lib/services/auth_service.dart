import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/user.dart';

class AuthService {
  final GetStorage _storage = GetStorage();
  final ApiConfigController _apiConfig = ApiConfigController();

  // مفاتيح التخزين
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  // حفظ التوكن
  Future<void> saveToken(String token) async {
    await _storage.write(_tokenKey, token);
  }

  // استرجاع التوكن
  String? getToken() {
    return _storage.read(_tokenKey);
  }

  // حذف التوكن
  Future<void> deleteToken() async {
    await _storage.remove(_tokenKey);
  }

  // حفظ بيانات المستخدم
  Future<void> saveUser(UserModel user) async {
    await _storage.write(_userKey, user.toJson());
  }

  // استرجاع بيانات المستخدم
  UserModel? getUser() {
    final userData = _storage.read(_userKey);
    if (userData != null) {
      return UserModel.fromJson(Map<String, dynamic>.from(userData));
    }
    return null;
  }

  // حذف بيانات المستخدم
  Future<void> deleteUser() async {
    await _storage.remove(_userKey);
  }

  // فحص حالة تسجيل الدخول
  bool isLoggedIn() {
    return getToken() != null;
  }

  // تسجيل الدخول
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse('${_apiConfig.baseUrl.value}${ApiConfig.login}');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // حفظ التوكن
        if (responseData['token'] != null) {
          await saveToken(responseData['token']);
        }

        // حفظ بيانات المستخدم
        if (responseData['user'] != null) {
          final user = UserModel.fromJson(responseData['user']);
          await saveUser(user);
        }

        return {
          'success': true,
          'message': 'تم تسجيل الدخول بنجاح',
          'data': responseData,
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'فشل تسجيل الدخول',
          'errors': responseData['errors'],
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'حدث خطأ في الاتصال: ${e.toString()}',
      };
    }
  }

  // إنشاء حساب جديد
  Future<Map<String, dynamic>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse('${_apiConfig.baseUrl.value}${ApiConfig.googleSignIn}');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // حفظ التوكن
        if (responseData['token'] != null) {
          await saveToken(responseData['token']);
        }

        // حفظ بيانات المستخدم
        if (responseData['user'] != null) {
          final user = UserModel.fromJson(responseData['user']);
          await saveUser(user);
        }

        return {
          'success': true,
          'message': 'تم إنشاء الحساب بنجاح',
          'data': responseData,
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'فشل إنشاء الحساب',
          'errors': responseData['errors'],
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'حدث خطأ في الاتصال: ${e.toString()}',
      };
    }
  }

  // تسجيل الخروج
  Future<void> logout() async {
    await deleteToken();
    await deleteUser();
  }

  // الحصول على headers مع التوكن
  Map<String, String> getAuthHeaders() {
    final token = getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
}
