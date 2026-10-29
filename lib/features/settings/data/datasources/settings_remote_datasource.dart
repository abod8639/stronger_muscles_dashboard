import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/core/config/api_config.dart';
import '../models/settings_model.dart';

/// Contract for remote operations regarding settings via REST API.
abstract class SettingsRemoteDataSource {
  Future<SettingsModel> getSettings();
  Future<SettingsModel> updateSettings(Map<String, dynamic> settingsData);
}

/// Production implementation of [SettingsRemoteDataSource] using [Dio].
/// 100% testable via constructor dependency injection.
class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource {
  final Dio _dio;

  const SettingsRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  static const _timeout = Duration(seconds: 15);

  @override
  Future<SettingsModel> getSettings() async {
    try {
      final response = await _dio.get(
        ApiConfig.adminSettings,
        options: Options(
          sendTimeout: _timeout,
          receiveTimeout: _timeout,
        ),
      );

      final data = response.data;
      if (data is Map) {
        final map = data['data'] is Map ? data['data'] as Map : data;
        return SettingsModel.fromJson(Map<String, dynamic>.from(map));
      }
      return SettingsModel.defaultSettings;
    } on DioException catch (e) {
      // Graceful fallback for newly configured dashboard endpoints if not yet deployed on server
      if (e.response?.statusCode == 404) {
        return SettingsModel.defaultSettings;
      }
      rethrow;
    }
  }

  @override
  Future<SettingsModel> updateSettings(Map<String, dynamic> settingsData) async {
    try {
      final response = await _dio.put(
        ApiConfig.adminSettings,
        data: settingsData,
        options: Options(
          sendTimeout: _timeout,
          receiveTimeout: _timeout,
        ),
      );

      final data = response.data;
      if (data is Map) {
        final map = data['data'] is Map ? data['data'] as Map : data;
        return SettingsModel.fromJson(Map<String, dynamic>.from(map));
      }
      return SettingsModel.fromJson(settingsData);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        // If endpoint is mock/unimplemented on backend, return simulated updated model
        return SettingsModel.fromJson(settingsData);
      }
      rethrow;
    }
  }
}
