import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/core/storage/app_storage.dart';
import 'package:stronger_muscles_dashboard/core/config/api_config.dart';
import 'package:stronger_muscles_dashboard/core/utils/ui_feedback.dart';

/// Centralized Dio HTTP Client Provider for the application.
/// Provides base configuration, timeouts, authentication headers, and global interceptors.
final dioProvider = Provider<Dio>((ref) {
  final apiConfig = ApiConfigController();
  final dio = Dio(
    BaseOptions(
      baseUrl: apiConfig.baseUrl.value,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final storage = GetStorage();
        final token = storage.read('admin_token');
        if (token != null && token.toString().trim().isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        final path = e.requestOptions.path;
        final isAuthEndpoint =
            path.contains('/login') || path.contains('/register');

        if (e.response?.statusCode == 401 && !isAuthEndpoint) {
          final storage = GetStorage();
          storage.remove('admin_token');
          storage.remove('admin_user');
          AppFeedback.showWarning('انتهت الجلسة: يرجى تسجيل الدخول مجدداً');
        } else if (e.response?.statusCode == 403) {
          AppFeedback.showError('ليس لديك صلاحية للوصول إلى هذا المورد');
        }
        return handler.next(e);
      },
    ),
  );

  return dio;
});
