import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stronger_muscles_dashboard/config/api_config.dart';
import 'package:stronger_muscles_dashboard/services/api/api_base.dart';

class CategoryServiceFixed extends ApiBase {
  Future<List<dynamic>> fetchCategories({bool tree = false}) async {
    try {
      final queryParam = tree ? '?tree=1' : '';
      final response = await http
          .get(
            Uri.parse(
              '${ApiConfigController().baseUrl.value}${ApiConfig.adminCategories}$queryParam',
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
        final decoded = json.decode(response.body);
        if (decoded is Map && decoded.containsKey('data')) {
          var data = decoded['data'];
          if (data is Map && data.containsKey('data')) {
            return data['data'] ?? [];
          }
          return data is List ? data : [];
        }
        return decoded is List ? decoded : [];
      } else {
        throw Exception('فشل في جلب التصنيفات: ${response.statusCode}');
      }
    } catch (e) {
      print('خطأ في جلب التصنيفات: $e');
      rethrow;
    }
  }
}
