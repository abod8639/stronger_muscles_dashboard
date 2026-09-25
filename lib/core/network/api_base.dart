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
    final path = e.requestOptions.path;
    final isAuthEndpoint = path.contains('/login') || path.contains('/register');

    if (e.response?.statusCode == 401 && !isAuthEndpoint) {
      _authService.logout();
      Get.snackbar('انتهت الجلسة', 'يرجى تسجيل الدخول مرة أخرى');
    } else if (e.response?.statusCode == 403) {
      Get.snackbar(
        'خطأ',
        'ليس لديك صلاحية للوصول إلى هذا المورد',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<bool> checkConnection() async {
    try {
      final response = await dio.get(
        ApiConfig.adminCategories,
        options: Options(receiveTimeout: const Duration(seconds: 5)),
      );
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
