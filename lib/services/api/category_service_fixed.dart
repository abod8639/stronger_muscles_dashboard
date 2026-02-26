import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/config/api_config.dart';
import 'package:stronger_muscles_dashboard/services/api/api_base.dart';

class CategoryService extends ApiBase {
  Future<List<dynamic>> fetchCategories({bool tree = false}) async {
    try {
      final response = await dio.get(
        ApiConfig.adminCategories,
        queryParameters: tree ? {'tree': 1} : null,
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
      print('⚠️ [CategoryService] خطأ في جلب التصنيفات: ${e.message}');
      rethrow;
    }
  }
}