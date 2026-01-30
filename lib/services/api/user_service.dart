import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config/api_config.dart';
import 'api_base.dart';



class UserService extends ApiBase {
  // جلب إحصائيات المستخدمين (Admin)
  Future<Map<String, dynamic>> fetchUsersStats() async {
    try {
      final response = await http
          .get(
            Uri.parse(
              '${ApiConfigController().baseUrl.value}${ApiConfig.adminUsers}',
            ),
            headers: getAuthHeaders(),
          )
          .timeout(
            const Duration(seconds: ApiBase.timeoutSeconds),
            onTimeout: () => http.Response('Connection timeout', 408),
          );

      // Handle auth errors
      handleAuthErrors(response);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
          'فشل في جلب إحصائيات المستخدمين: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('خطأ في جلب إحصائيات المستخدمين: $e');
      rethrow;
    }
  }
}
