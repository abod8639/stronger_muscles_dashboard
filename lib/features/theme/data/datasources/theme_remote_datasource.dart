import 'package:dio/dio.dart';
import '../models/theme_model.dart';

/// Contract for remote theme synchronization via REST API.
abstract class ThemeRemoteDataSource {
  Future<ThemeModel?> getRemoteTheme();
  Future<void> updateRemoteTheme(ThemeModel theme);
}

/// Production implementation of [ThemeRemoteDataSource] using [Dio].
/// 100% testable via constructor dependency injection.
class ThemeRemoteDataSourceImpl implements ThemeRemoteDataSource {
  final Dio _dio;

  const ThemeRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  static const String _themeEndpoint = '/admin/profile/theme';

  @override
  Future<ThemeModel?> getRemoteTheme() async {
    try {
      final response = await _dio.get(_themeEndpoint);
      if (response.data is Map) {
        final data = response.data['data'] is Map ? response.data['data'] as Map : response.data as Map;
        return ThemeModel.fromJson(Map<String, dynamic>.from(data));
      }
      return null;
    } catch (_) {
      // Remote theme sync is optional; fallback gracefully to local storage
      return null;
    }
  }

  @override
  Future<void> updateRemoteTheme(ThemeModel theme) async {
    try {
      await _dio.put(
        _themeEndpoint,
        data: theme.toJson(),
      );
    } catch (_) {
      // Silently proceed if backend theme endpoint is not available
    }
  }
}
