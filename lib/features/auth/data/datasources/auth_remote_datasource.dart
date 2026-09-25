import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/config/api_config.dart';
import '../models/auth_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthModel> login(String email, String password);
  Future<AuthModel> signup(String name, String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<AuthModel> login(String email, String password) async {
    try {
      final response = await dio.post(ApiConfig.adminLogin, data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        return AuthModel.fromJson(response.data);
      }
      throw Exception(response.data['message'] ?? 'Failed to login');
    } on DioException catch (e) {
      final message = e.response?.data is Map && e.response?.data['message'] != null
          ? e.response!.data['message']
          : (e.message ?? 'فشل تسجيل الدخول');
      throw Exception(message);
    }
  }

  @override
  Future<AuthModel> signup(String name, String email, String password) async {
    final response = await dio.post('/auth/register', data: {
      'name': name,
      'email': email,
      'password': password,
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      return AuthModel.fromJson(response.data);
    }
    throw Exception(response.data['message'] ?? 'Failed to register');
  }
}
