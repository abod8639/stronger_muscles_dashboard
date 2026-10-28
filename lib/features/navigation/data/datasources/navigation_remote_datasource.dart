import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/config/api_config.dart';
import 'package:stronger_muscles_dashboard/core/error/exceptions.dart';
import '../models/navigation_badges_model.dart';

/// Contract for fetching remote Navigation badges via HTTP/Dio.
abstract class NavigationRemoteDataSource {
  Future<NavigationBadgesModel> getNavigationBadges();
}

/// Production implementation of [NavigationRemoteDataSource] using [Dio].
/// 100% testable via Constructor Dependency Injection.
class NavigationRemoteDataSourceImpl implements NavigationRemoteDataSource {
  final Dio _dio;

  NavigationRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<NavigationBadgesModel> getNavigationBadges() async {
    try {
      final response = await _dio.get(
        ApiConfig.adminNavigationBadges,
        options: Options(
          receiveTimeout: const Duration(seconds: 15),
          sendTimeout: const Duration(seconds: 15),
          headers: {'Accept': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final Map<String, dynamic> map = data is Map<String, dynamic>
            ? (data['data'] as Map<String, dynamic>? ?? data)
            : Map<String, dynamic>.from(data as Map);

        return NavigationBadgesModel.fromJson(map);
      }

      throw ServerException(
        message: 'فشل في استرجاع شارات التنقل من الخادم',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        // Safe fallback if optional backend endpoint is not yet mounted
        return const NavigationBadgesModel();
      }
      throw ServerException(
        message: e.message ?? 'خطأ في الاتصال بالشبكة أثناء جلب شارات التنقل',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(message: 'حدث خطأ غير متوقع أثناء معالجة شارات التنقل: $e');
    }
  }
}
