import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config/api_config.dart';
import 'api_base.dart';

class OrderService extends ApiBase {
  // جلب الطلبات (Admin)
  Future<List<dynamic>> fetchOrders() async {
    try {
      final response = await http
          .get(
            Uri.parse(
              '${ApiConfigController().baseUrl.value}${ApiConfig.adminOrders}',
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
        throw Exception('فشل في جلب الطلبات: ${response.statusCode}');
      }
    } catch (e) {
      print('خطأ في جلب الطلبات: $e');
      rethrow;
    }
  }

  // جلب تفاصيل طلب محدد (Admin)
  Future<Map<String, dynamic>> fetchOrderDetail(String id) async {
    try {
      final response = await http
          .get(
            Uri.parse(
              '${ApiConfigController().baseUrl.value}${ApiConfig.adminOrderDetail(id)}',
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
        return (decoded is Map && decoded.containsKey('data'))
            ? decoded['data']
            : decoded;
      } else {
        throw Exception('فشل في جلب تفاصيل الطلب: ${response.statusCode}');
      }
    } catch (e) {
      print('خطأ في جلب تفاصيل الطلب: $e');
      rethrow;
    }
  }
}
