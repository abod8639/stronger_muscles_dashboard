import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'auth_service.dart';
import '../../config/api_config.dart';

class ApiBase {
  late final Dio dio;
  static const int timeoutSeconds = 30;
  final AuthService _authService = Get.find<AuthService>();

  ApiBase() {
    _initDio();
  }

  void _initDio() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConfigController().baseUrl.value,
        connectTimeout: const Duration(seconds: timeoutSeconds),
        receiveTimeout: const Duration(seconds: timeoutSeconds),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers.addAll(_authService.getAuthHeaders());
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          _handleError(e);
          return handler.next(e);
        },
      ),
    );
  }

  void _handleError(DioException e) {
    if (e.response?.statusCode == 401) {
      _authService.logout();
      Get.snackbar('انتهت الجلسة', 'يرجى تسجيل الدخول مرة أخرى');
    }
  }
}
