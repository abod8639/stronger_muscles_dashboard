import 'dart:convert';
import 'package:hive_ce/hive.dart';
import 'package:stronger_muscles_dashboard/core/error/exceptions.dart';
import '../models/settings_model.dart';

/// Contract for local caching of application and store settings via Hive.
abstract class SettingsLocalDataSource {
  Future<SettingsModel?> getCachedSettings();
  Future<void> cacheSettings(SettingsModel settings);
  Future<bool> isCacheValid();
  Future<void> clearCache();
}

/// Hive-backed production implementation of [SettingsLocalDataSource].
/// 100% testable via constructor dependency injection of [Box].
class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  static const String _settingsKey = 'CACHED_STORE_SETTINGS';
  static const String _timestampKey = 'CACHED_STORE_SETTINGS_TIMESTAMP';
  static const Duration _cacheTtl = Duration(minutes: 10);

  final Box _box;

  const SettingsLocalDataSourceImpl({required Box box}) : _box = box;

  @override
  Future<SettingsModel?> getCachedSettings() async {
    try {
      final raw = _box.get(_settingsKey);
      if (raw == null) return null;

      final map = raw is String
          ? jsonDecode(raw) as Map<String, dynamic>
          : Map<String, dynamic>.from(raw as Map);

      return SettingsModel.fromJson(map);
    } catch (e) {
      throw CacheException(
        message: 'فشل في استرجاع إعدادات المتجر من الذاكرة المحلية (Hive): $e',
      );
    }
  }

  @override
  Future<void> cacheSettings(SettingsModel settings) async {
    try {
      await _box.put(_settingsKey, settings.toJson());
      await _box.put(_timestampKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      throw CacheException(
        message: 'فشل في حفظ إعدادات المتجر في الذاكرة المحلية (Hive): $e',
      );
    }
  }

  @override
  Future<bool> isCacheValid() async {
    try {
      final timestamp = _box.get(_timestampKey) as int?;
      if (timestamp == null || !_box.containsKey(_settingsKey)) {
        return false;
      }
      final cachedTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      return DateTime.now().difference(cachedTime) < _cacheTtl;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await _box.delete(_settingsKey);
      await _box.delete(_timestampKey);
    } catch (e) {
      throw CacheException(message: 'فشل في مسح ذاكرة الإعدادات المؤقتة: $e');
    }
  }
}
