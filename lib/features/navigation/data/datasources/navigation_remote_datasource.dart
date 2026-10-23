import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/navigation_badges_model.dart';

abstract class NavigationRemoteDataSource {
  Future<NavigationBadgesModel> getNavigationBadges({CancelToken? cancelToken});
}

class NavigationRemoteDataSourceImpl implements NavigationRemoteDataSource {
  final Dio _dio;
  static const String _badgesEndpoint = '/admin/navigation/badges';

  NavigationRemoteDataSourceImpl(this._dio);

  @override
  Future<NavigationBadgesModel> getNavigationBadges({
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get(
        _badgesEndpoint,
        cancelToken: cancelToken,
        options: Options(
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
        ),
      );

      // تحليل البيانات في مسار خلفي Isolate لمنع تجميد الشاشة
      final parsed = await compute(parseNavigationBadgesCompute, response.data);
      return parsed;
    } on DioException catch (e) {
      // إذا كان المسار اختياري وغير موجود بالخادم بعد (404) نرجع كائناً آمناً بقيم افتراضية
      if (e.response?.statusCode == 404) {
        debugPrint('Navigation badges endpoint not found (404), using default safe badges.');
        return const NavigationBadgesModel();
      }
      rethrow;
    } catch (e) {
      debugPrint('NavigationRemoteDataSource unexpected error: $e');
      return const NavigationBadgesModel();
    }
  }
}
