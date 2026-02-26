import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import '../config/api_config.dart';
import '../models/user_model.dart';

class AuthService extends GetxService {
  final GetStorage _storage = GetStorage();
  final ApiConfigController _apiConfig = ApiConfigController();

  // تعريف Dio محلي لعمليات Login/Register (بدون Interceptor يطلب توكن غير موجود بعد)
  final Dio _dio = Dio();

  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  // --- إدارة التخزين (Storage) ---
  Future<void> saveToken(String token) async => await _storage.write(_tokenKey, token);
  String? getToken() => _storage.read(_tokenKey);
  Future<void> deleteToken() async => await _storage.remove(_tokenKey);

  Future<void> saveUser(UserModel user) async => await _storage.write(_userKey, user.toJson());
  UserModel? getUser() {
    final userData = _storage.read(_userKey);
    return userData != null ? UserModel.fromJson(Map<String, dynamic>.from(userData)) : null;
  }
  Future<void> deleteUser() async => await _storage.remove(_userKey);

  bool isLoggedIn() => getToken() != null;

  // --- العمليات (Auth Actions) ---

  Future<Map<String, dynamic>> login({required String email, required String password}) async {
    try {
      final response = await _dio.post(
        '${_apiConfig.baseUrl.value}${ApiConfig.login}',
        data: {'email': email, 'password': password},
        options: Options(headers: {'Accept': 'application/json'}),
      );

      final responseData = response.data;

      if (response.statusCode == 200) {
        if (responseData['token'] != null) await saveToken(responseData['token']);
        if (responseData['user'] != null) await saveUser(UserModel.fromJson(responseData['user']));

        return {'success': true, 'message': 'تم تسجيل الدخول بنجاح', 'data': responseData};
      }
      return {'success': false, 'message': responseData['message'] ?? 'فشل تسجيل الدخول'};
      
    } on DioException catch (e) {
      return _handleDioError(e, 'تسجيل الدخول');
    }
  }

  Future<Map<String, dynamic>> signup({required String name, required String email, required String password}) async {
    try {
      // ملاحظة: تأكد من رابط الـ Register الصحيح (أنت وضعت googleSignIn في الكود السابق)
      final response = await _dio.post(
        '${_apiConfig.baseUrl.value}${ApiConfig.googleSignIn}', 
        data: {'name': name, 'email': email, 'password': password},
      );

      final responseData = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseData['token'] != null) await saveToken(responseData['token']);
        if (responseData['user'] != null) await saveUser(UserModel.fromJson(responseData['user']));
        return {'success': true, 'message': 'تم إنشاء الحساب بنجاح', 'data': responseData};
      }
      return {'success': false, 'message': responseData['message'] ?? 'فشل إنشاء الحساب'};
      
    } on DioException catch (e) {
      return _handleDioError(e, 'إنشاء الحساب');
    }
  }

  Future<void> logout() async {
    await deleteToken();
    await deleteUser();
    // يمكنك هنا استدعاء API الـ Logout في Laravel لإبطال التوكن من الـ DB
  }

  // --- المساعدة (Helpers) ---

  Map<String, String> getAuthHeaders() {
    final token = getToken();
    return {
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Map<String, dynamic> _handleDioError(DioException e, String task) {
    String message = e.response?.data?['message'] ?? 'حدث خطأ في $task';
    return {
      'success': false,
      'message': message,
      'errors': e.response?.data?['errors'],
    };
  }
}