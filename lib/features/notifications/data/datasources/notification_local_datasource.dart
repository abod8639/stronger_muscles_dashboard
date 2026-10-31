import 'dart:convert';
import 'package:hive_ce/hive.dart';
import 'package:stronger_muscles_dashboard/core/error/exceptions.dart';
import '../models/admin_notification_model.dart';

/// Contract for local caching of administrative notifications via Hive.
abstract class NotificationLocalDataSource {
  Future<NotificationsResultModel?> getCachedNotifications();
  Future<void> cacheNotifications(NotificationsResultModel model);
  Future<bool> isCacheValid();
  Future<void> clearCache();
}

/// Production implementation of [NotificationLocalDataSource] backed by Hive [Box].
/// 100% testable through constructor dependency injection.
class NotificationLocalDataSourceImpl implements NotificationLocalDataSource {
  static const String _notificationsKey = 'CACHED_NOTIFICATIONS_RESULT';
  static const String _timestampKey = 'CACHED_NOTIFICATIONS_TIMESTAMP';
  static const Duration _cacheTtl = Duration(minutes: 10);

  final Box _box;

  NotificationLocalDataSourceImpl({required Box box}) : _box = box;

  @override
  Future<NotificationsResultModel?> getCachedNotifications() async {
    try {
      final raw = _box.get(_notificationsKey);
      if (raw == null) return null;

      final Map<String, dynamic> map = raw is String
          ? jsonDecode(raw) as Map<String, dynamic>
          : Map<String, dynamic>.from(raw as Map);

      return NotificationsResultModel.fromJson(map);
    } catch (e) {
      throw CacheException(message: 'Failed to read cached notifications: $e');
    }
  }

  @override
  Future<void> cacheNotifications(NotificationsResultModel model) async {
    try {
      await _box.put(_notificationsKey, model.toJson());
      await _box.put(_timestampKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      throw CacheException(message: 'Failed to cache notifications: $e');
    }
  }

  @override
  Future<bool> isCacheValid() async {
    try {
      final timestamp = _box.get(_timestampKey) as int?;
      if (timestamp == null) return false;

      final cachedTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      return DateTime.now().difference(cachedTime) < _cacheTtl;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await _box.delete(_notificationsKey);
      await _box.delete(_timestampKey);
    } catch (e) {
      throw CacheException(message: 'Failed to clear notifications cache: $e');
    }
  }
}
