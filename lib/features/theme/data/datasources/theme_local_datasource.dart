import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:stronger_muscles_dashboard/core/error/exceptions.dart';
import '../models/theme_model.dart';

/// Contract for local caching of theme preferences using Hive.
abstract class ThemeLocalDataSource {
  Future<ThemeModel?> getCachedTheme();
  Future<void> cacheTheme(ThemeModel theme);
  Future<void> clearCache();
}

/// Hive-backed production implementation of [ThemeLocalDataSource].
/// 100% testable via constructor dependency injection of [Box].
class ThemeLocalDataSourceImpl implements ThemeLocalDataSource {
  static const String _themeKey = 'CACHED_THEME_PREFERENCE';

  final Box _box;

  const ThemeLocalDataSourceImpl({required Box box}) : _box = box;

  @override
  Future<ThemeModel?> getCachedTheme() async {
    try {
      final raw = _box.get(_themeKey);
      if (raw == null) return null;

      final map = raw is String
          ? jsonDecode(raw) as Map<String, dynamic>
          : Map<String, dynamic>.from(raw as Map);

      return ThemeModel.fromJson(map);
    } catch (e) {
      throw CacheException(
        message: 'فشل في استرجاع الثيم من الذاكرة المحلية (Hive): $e',
      );
    }
  }

  @override
  Future<void> cacheTheme(ThemeModel theme) async {
    try {
      await _box.put(_themeKey, theme.toJson());
    } catch (e) {
      throw CacheException(
        message: 'فشل في حفظ الثيم في الذاكرة المحلية (Hive): $e',
      );
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await _box.delete(_themeKey);
    } catch (e) {
      throw CacheException(message: 'فشل في مسح ذاكرة الثيم المؤقتة: $e');
    }
  }
}
