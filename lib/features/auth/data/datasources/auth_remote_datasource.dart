import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/config/api_config.dart';
import 'package:stronger_muscles_dashboard/core/error/exceptions.dart';
import '../models/auth_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthModel> login(
    String email,
    String password, {
    CancelToken? cancelToken,
  });

  Future<AuthModel> signup(
    String name,
    String email,
    String password, {
    CancelToken? cancelToken,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  static const Duration _defaultTimeout = Duration(seconds: 15);

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<AuthModel> login(
    String email,
    String password, {
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.post(
        ApiConfig.adminLogin,
        data: {
          'email': email,
          'password': password,
        },
        cancelToken: cancelToken,
        options: Options(
          sendTimeout: _defaultTimeout,
          receiveTimeout: _defaultTimeout,
          headers: {'Accept': 'application/json'},
        ),
      );

      final data = response.data;
      if (response.statusCode == 200 && data is Map<String, dynamic>) {
        // معالجة البيانات الثقيلة في Isolate منفصل عبر compute
        return await AuthModel.fromJsonAsync(data);
      }

      throw ServerException(
        message: data is Map ? (data['message']?.toString() ?? 'فشل تسجيل الدخول') : 'فشل تسجيل الدخول',
        statusCode: response.statusCode,
      );
    } on DioException {
      rethrow;
    } catch (e) {
      if (e is AppException) rethrow;
      throw ParsingException(
        message: 'خطأ أثناء تحليل بيانات تسجيل الدخول: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<AuthModel> signup(
    String name,
    String email,
    String password, {
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.post(
        ApiConfig.adminRegister,
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
        cancelToken: cancelToken,
        options: Options(
          sendTimeout: _defaultTimeout,
          receiveTimeout: _defaultTimeout,
          headers: {'Accept': 'application/json'},
        ),
      );

      final data = response.data;
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          data is Map<String, dynamic>) {
        // معالجة البيانات الثقيلة في Isolate منفصل عبر compute
        return await AuthModel.fromJsonAsync(data);
      }

      throw ServerException(
        message: data is Map
            ? (data['message']?.toString() ?? 'فشل في إنشاء حساب المشرف')
            : 'فشل في إنشاء حساب المشرف',
        statusCode: response.statusCode,
      );
    } on DioException {
      rethrow;
    } catch (e) {
      if (e is AppException) rethrow;
      throw ParsingException(
        message: 'خطأ أثناء تحليل بيانات إنشاء الحساب: $e',
        originalError: e,
      );
    }
  }
}
