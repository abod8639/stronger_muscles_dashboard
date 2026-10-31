import 'dart:convert';
import 'package:hive_ce/hive.dart';
import 'package:stronger_muscles_dashboard/core/error/exceptions.dart';
import '../models/dashboard_stats_model.dart';

/// Contract for locally caching Dashboard aggregated stats via Hive.
abstract class DashboardLocalDataSource {
  Future<DashboardStatsModel?> getCachedStats();
  Future<void> cacheStats(DashboardStatsModel model);
  Future<bool> isCacheValid();
  Future<void> clearCache();
}

/// Production implementation of [DashboardLocalDataSource] using Hive [Box].
/// 100% testable via Constructor Dependency Injection.
class DashboardLocalDataSourceImpl implements DashboardLocalDataSource {
  static const String _statsKey = 'CACHED_DASHBOARD_STATS';
  static const String _timestampKey = 'CACHED_DASHBOARD_TIMESTAMP';
  static const Duration _cacheTtl = Duration(minutes: 15);

  final Box _box;

  DashboardLocalDataSourceImpl({required Box box}) : _box = box;

  @override
  Future<DashboardStatsModel?> getCachedStats() async {
    try {
      final raw = _box.get(_statsKey);
      if (raw == null) return null;

      final Map<String, dynamic> map = raw is String
          ? jsonDecode(raw) as Map<String, dynamic>
          : Map<String, dynamic>.from(raw as Map);

      return DashboardStatsModel.fromJson(map);
    } catch (e) {
      throw CacheException(
        message: 'Failed to read cached dashboard stats: $e',
      );
    }
  }

  @override
  Future<void> cacheStats(DashboardStatsModel model) async {
    try {
      await _box.put(_statsKey, model.toJson());
      await _box.put(_timestampKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      throw CacheException(message: 'Failed to cache dashboard stats: $e');
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
      await _box.delete(_statsKey);
      await _box.delete(_timestampKey);
    } catch (e) {
      throw CacheException(message: 'Failed to clear dashboard cache: $e');
    }
  }
}
