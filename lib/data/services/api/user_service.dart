import 'package:dio/dio.dart';
import '../../../config/api_config.dart';
import 'api_base.dart';

class UserService extends ApiBase {

  Future<Map<String, dynamic>> fetchUsersStats() async {
    try {
      final response = await dio.get(ApiConfig.adminUsers);

      final decoded = response.data;

      if (decoded is Map<String, dynamic>) {
        return decoded;
      } else {
        throw Exception('تنسيق البيانات المستلمة غير صحيح');
      }
      
    } on DioException catch (e) {
      _logError(e, 'جلب إحصائيات المستخدمين');
      throw Exception(e.response?.data?['message'] ?? 'فشل في جلب إحصائيات المستخدمين');
    } catch (e) {
      print('خطأ غير متوقع: $e');
      rethrow;
    }
  }

  void _logError(DioException e, String task) {
    print('⚠️ [UserService] Error in $task: ${e.response?.statusCode} - ${e.message}');
  }
}