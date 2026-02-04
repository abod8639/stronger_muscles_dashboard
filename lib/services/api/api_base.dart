import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../config/api_config.dart';
import '../auth_service.dart';

class ApiBase {
  static const int timeoutSeconds = 30;
  final AuthService _authService = AuthService();

  // Helper method to get authenticated headers
  Map<String, String> getAuthHeaders() {
    return _authService.getAuthHeaders();
  }

  // Handle authentication errors
  void handleAuthErrors(http.Response response) {
    if (response.statusCode == 401) {
      // Unauthorized - redirect to login
      Get.offAllNamed('/login');
      Get.snackbar(
        'خطأ',
        'انتهت صلاحية الجلسة. يرجى تسجيل الدخول مرة أخرى',
        snackPosition: SnackPosition.TOP,
      );
    } else if (response.statusCode == 403) {
      // Forbidden - user is not admin
      Get.snackbar(
        'خطأ',
        'ليس لديك صلاحية للوصول إلى هذا المورد',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<bool> checkConnection() async {
    try {
      final response = await http
          .get(
            Uri.parse(
              '${ApiConfigController().baseUrl.value}${ApiConfig.categories}',
            ),
          )
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
