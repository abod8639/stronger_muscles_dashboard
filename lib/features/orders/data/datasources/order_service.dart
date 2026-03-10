import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/config/api_config.dart';
import 'package:stronger_muscles_dashboard/core/network/api_base.dart';


class OrderService extends ApiBase {
  Future<List<dynamic>> fetchOrders() async {
    try {
      final response = await dio.get(ApiConfig.adminOrders);

      if (response.data is Map && response.data.containsKey('data')) {
        final innerData = response.data['data'];
        if (innerData is Map && innerData.containsKey('data')) {
          return innerData['data'] ?? [];
        }
        return innerData is List ? innerData : [];
      }
      return [];
    } on DioException catch (e) {
      _logError(e, 'جلب قائمة الطلبات');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchOrderDetail(String id) async {
    try {
      final response = await dio.get(ApiConfig.adminOrderDetail(id));

      final responseData = response.data;

      return (responseData is Map && responseData.containsKey('data'))
          ? responseData['data']
          : responseData;
    } on DioException catch (e) {
      _logError(e, 'جلب تفاصيل الطلب رقم: $id');
      rethrow;
    }
  }

  void _logError(DioException e, String task) {
    final String errorMsg =
        e.response?.data?['message'] ?? e.message ?? 'Unknown Error';
    print('⚠️ [OrderService] خطأ في $task: $errorMsg');
  }
}
