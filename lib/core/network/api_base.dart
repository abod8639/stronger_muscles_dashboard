import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import '../../config/api_config.dart';

class ApiBase {
  late final Dio dio;
  static const int timeoutSeconds = 30;
  final GetStorage _storage = GetStorage();

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
          final token = _storage.read('admin_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
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
      Get.offAllNamed('/login');
      Get.snackbar('انتهت الجلسة', 'يرجى تسجيل الدخول مرة أخرى');
    }
  }
}
