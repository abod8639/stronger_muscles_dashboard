import 'package:dio/dio.dart';
import '../../config/api_config.dart';
import 'api_base.dart';

class OrderService extends ApiBase {

  final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiConfigController().baseUrl.value,
    connectTimeout: const Duration(seconds: ApiBase.timeoutSeconds),
    receiveTimeout: const Duration(seconds: ApiBase.timeoutSeconds),
  ));

  Future<List<dynamic>> fetchOrders() async {
    try {
      final response = await _dio.get(
        ApiConfig.adminOrders,
        options: Options(headers: getAuthHeaders()),
      );

      final decoded = response.data;

      if (decoded is Map && decoded.containsKey('data')) {
        var data = decoded['data'];
        if (data is Map && data.containsKey('data')) {
          return data['data'] ?? [];
        }
        return data is List ? data : [];
      }
      return decoded is List ? decoded : [];
      
    } on DioException catch (e) {
      _handleDioError(e, 'جلب الطلبات');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchOrderDetail(String id) async {
    try {
      final response = await _dio.get(
        ApiConfig.adminOrderDetail(id),
        options: Options(headers: getAuthHeaders()),
      );

      final decoded = response.data;
      
      return (decoded is Map && decoded.containsKey('data'))
          ? decoded['data']
          : decoded;

    } on DioException catch (e) {
      _handleDioError(e, 'جلب تفاصيل الطلب');
      rethrow;
    }
  }

  void _handleDioError(DioException e, String task) {
    if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
    }
    
    String message = e.response?.data['message'] ?? e.message;
    print('خطأ في $task: $message');
  }
}