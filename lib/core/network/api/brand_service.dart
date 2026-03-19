import 'package:dio/dio.dart';
import '../../../config/api_config.dart';
import 'api_base.dart';

class BrandService extends ApiBase {
  Future<List<dynamic>> fetchBrands() async {
    try {
      final response = await dio.get(ApiConfig.adminBrands);
      final decoded = response.data;
      
      if (decoded is Map && decoded.containsKey('data')) {
        return decoded['data'] as List<dynamic>;
      } else if (decoded is List) {
        return decoded;
      }
      return [];
    } on DioException catch (e) {
      _logError(e, 'جلب الماركات');
      rethrow;
    }
  }

  void _logError(DioException e, String task) {
    print('⚠️ [BrandService] Error in $task: ${e.message}');
  }
}
