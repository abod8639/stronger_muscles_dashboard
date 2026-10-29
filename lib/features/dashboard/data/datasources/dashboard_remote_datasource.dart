import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/core/config/api_config.dart';
import 'package:stronger_muscles_dashboard/core/error/exceptions.dart';
import '../models/dashboard_stats_model.dart';

/// Contract for fetching remote Dashboard statistics via HTTP/Dio.
abstract class DashboardRemoteDataSource {
  Future<DashboardStatsModel> getRemoteStats();
}

/// Production implementation of [DashboardRemoteDataSource] using [Dio].
/// 100% testable via Constructor Dependency Injection.
class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final Dio _dio;

  DashboardRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<DashboardStatsModel> getRemoteStats() async {
    try {
      final response = await _dio.get(
        ApiConfig.adminDashboard,
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final Map<String, dynamic> map = data is Map<String, dynamic>
            ? (data['data'] as Map<String, dynamic>? ?? data)
            : Map<String, dynamic>.from(data as Map);

        return DashboardStatsModel.fromJson(map);
      }

      throw ServerException(
        message: 'فشل في جلب إحصائيات لوحة التحكم من الخادم',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'خطأ في الاتصال بالشبكة',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(message: 'حدث خطأ غير متوقع: $e');
    }
  }
}
