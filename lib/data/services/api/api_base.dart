import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response; // لتجنب التعارض مع Dio Response
import '../../../config/api_config.dart';
import '../auth_service.dart';

class ApiBase {
  late final Dio dio;
  static const int timeoutSeconds = 30;
  final AuthService _authService = AuthService();

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

    // إضافة Interceptor لمعالجة التوكن والأخطاء بشكل تلقائي
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // إضافة Headers المصادقة تلقائياً لكل طلب
          options.headers.addAll(_authService.getAuthHeaders());
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          handleDioErrors(e);
          return handler.next(e);
        },
      ),
    );
  }

  // معالجة أخطاء المصادقة والصلاحيات
  void handleDioErrors(DioException e) {
    final statusCode = e.response?.statusCode;

    if (statusCode == 401) {
      // Unauthorized - Session expired
      _authService.logout(); // تأكد من مسح التوكن محلياً
      Get.offAllNamed('/login');
      Get.snackbar(
        'خطأ',
        'انتهت صلاحية الجلسة. يرجى تسجيل الدخول مرة أخرى',
        snackPosition: SnackPosition.TOP,
      );
    } else if (statusCode == 403) {
      // Forbidden
      Get.snackbar(
        'خطأ',
        'ليس لديك صلاحية للوصول إلى هذا المورد',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  // فحص الاتصال (تم تحسينه باستخدام Dio)
  Future<bool> checkConnection() async {
    try {
      final response = await dio.get(
        ApiConfig.categories,
        options: Options(receiveTimeout: const Duration(seconds: 5)),
      );
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
