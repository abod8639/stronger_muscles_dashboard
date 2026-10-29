import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/core/config/api_config.dart';
import 'package:stronger_muscles_dashboard/core/error/exceptions.dart';
import '../models/auth_model.dart';

/// Contract for executing remote authentication network calls via HTTP.
abstract class AuthRemoteDataSource {
  Future<AuthModel> login({required String email, required String password});

  Future<AuthModel> signup({
    required String name,
    required String email,
    required String password,
  });
}

/// Production implementation of [AuthRemoteDataSource] using [Dio].
/// 100% testable via Constructor Dependency Injection.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  static const Duration _defaultTimeout = Duration(seconds: 15);

  const AuthRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<AuthModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiConfig.adminLogin,
        data: {'email': email, 'password': password},
        options: Options(
          sendTimeout: _defaultTimeout,
          receiveTimeout: _defaultTimeout,
          headers: {'Accept': 'application/json'},
        ),
      );

      final data = response.data;
      if (response.statusCode == 200 && data is Map<String, dynamic>) {
        return AuthModel.fromJson(data);
      }

      throw ServerException(
        message: data is Map
            ? (data['message']?.toString() ?? 'فشل تسجيل الدخول')
            : 'فشل تسجيل الدخول',
        statusCode: response.statusCode,
      );
    } on DioException {
      rethrow;
    } on AppException {
      rethrow;
    } catch (e) {
      throw ParsingException(
        message: 'خطأ أثناء تحليل بيانات تسجيل الدخول: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<AuthModel> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiConfig.adminRegister,
        data: {'name': name, 'email': email, 'password': password},
        options: Options(
          sendTimeout: _defaultTimeout,
          receiveTimeout: _defaultTimeout,
          headers: {'Accept': 'application/json'},
        ),
      );

      final data = response.data;
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          data is Map<String, dynamic>) {
        return AuthModel.fromJson(data);
      }

      throw ServerException(
        message: data is Map
            ? (data['message']?.toString() ?? 'فشل في إنشاء حساب المشرف')
            : 'فشل في إنشاء حساب المشرف',
        statusCode: response.statusCode,
      );
    } on DioException {
      rethrow;
    } on AppException {
      rethrow;
    } catch (e) {
      throw ParsingException(
        message: 'خطأ أثناء تحليل بيانات إنشاء الحساب: $e',
        originalError: e,
      );
    }
  }
}
