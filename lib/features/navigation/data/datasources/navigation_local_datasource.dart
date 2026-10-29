import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stronger_muscles_dashboard/core/error/exceptions.dart';
import '../models/navigation_badges_model.dart';

/// Contract for caching Navigation badges locally in Hive.
abstract class NavigationLocalDataSource {
  Future<NavigationBadgesModel?> getCachedBadges();
  Future<void> cacheBadges(NavigationBadgesModel badges);
  Future<bool> isCacheValid();
  Future<void> clearCache();
}

/// Hive-backed production implementation with 10-minute TTL invalidation.
/// 100% testable via Constructor Dependency Injection of [Box].
class NavigationLocalDataSourceImpl implements NavigationLocalDataSource {
  final Box _box;

  static const String _keyData = 'cached_navigation_badges_data';
  static const String _keyTimestamp = 'cached_navigation_badges_timestamp';
  static const Duration _cacheTtl = Duration(minutes: 10);

  NavigationLocalDataSourceImpl({required Box box}) : _box = box;

  @override
  Future<NavigationBadgesModel?> getCachedBadges() async {
    try {
      final rawData = _box.get(_keyData);
      if (rawData == null) return null;

      final Map<String, dynamic> map = rawData is String
          ? jsonDecode(rawData) as Map<String, dynamic>
          : Map<String, dynamic>.from(rawData as Map);

      return NavigationBadgesModel.fromJson(map);
    } catch (e) {
      throw CacheException(
        message: 'فشل في قراءة شارات التنقل من الذاكرة المحلية: $e',
      );
    }
  }

  @override
  Future<void> cacheBadges(NavigationBadgesModel badges) async {
    try {
      await _box.put(_keyData, badges.toJson());
      await _box.put(_keyTimestamp, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      throw CacheException(
        message: 'فشل في حفظ شارات التنقل في الذاكرة المحلية: $e',
      );
    }
  }

  @override
  Future<bool> isCacheValid() async {
    try {
      final timestamp = _box.get(_keyTimestamp) as int?;
      if (timestamp == null) return false;

      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      return DateTime.now().difference(cacheTime) < _cacheTtl;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await _box.delete(_keyData);
      await _box.delete(_keyTimestamp);
    } catch (e) {
      throw CacheException(message: 'فشل في مسح ذاكرة شارات التنقل: $e');
    }
  }
}
