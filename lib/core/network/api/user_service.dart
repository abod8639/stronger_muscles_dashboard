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
      throw Exception(
        e.response?.data?['message'] ?? 'فشل في جلب إحصائيات المستخدمين',
      );
    } catch (e) {
      print('خطأ غير متوقع: $e');
      rethrow;
    }
  }

  Future<List<dynamic>> fetchUsers() async {
    try {
      final response = await dio.get('/users');
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('فشل جلب قائمة المستخدمين');
      }
    } on DioException catch (e) {
      _logError(e, 'جلب قائمة المستخدمين');
      throw Exception(
        e.response?.data?['message'] ?? 'فشل في جلب قائمة المستخدمين',
      );
    } catch (e) {
      print('خطأ غير متوقع: $e');
      rethrow;
    }
  }

  void _logError(DioException e, String task) {
    print(
      '⚠️ [UserService] Error in $task: ${e.response?.statusCode} - ${e.message}',
    );
  }
}
