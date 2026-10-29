import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:stronger_muscles_dashboard/core/error/exceptions.dart';
import '../models/user_model.dart';
import '../models/users_stats_model.dart';

abstract class UserLocalDataSource {
  Future<UsersStatsModel?> getCachedUsersStats();
  Future<void> cacheUsersStats(UsersStatsModel stats);
  Future<List<UserModel>> getCachedUsers();
  Future<void> cacheUsers(List<UserModel> users);
  Future<bool> isStatsCacheValid();
  Future<void> clearCache();
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  static const String _statsKey = 'CACHED_USERS_STATS';
  static const String _timestampKey = 'CACHED_USERS_TIMESTAMP';
  static const Duration _cacheTtl = Duration(minutes: 15);

  final Box _statsBox;
  final Box<UserModel> _usersBox;

  UserLocalDataSourceImpl({
    required Box statsBox,
    required Box<UserModel> usersBox,
  })  : _statsBox = statsBox,
        _usersBox = usersBox;

  @override
  Future<UsersStatsModel?> getCachedUsersStats() async {
    try {
      final raw = _statsBox.get(_statsKey);
      if (raw == null) return null;

      final Map<String, dynamic> map = raw is String
          ? jsonDecode(raw) as Map<String, dynamic>
          : Map<String, dynamic>.from(raw as Map);

      if (map['users'] is List) {
        map['users'] = (map['users'] as List).map((u) {
          if (u is UserModel) return u.toJson();
          if (u is Map) return Map<String, dynamic>.from(u);
          return u;
        }).toList();
      }

      return UsersStatsModel.fromJson(map);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheUsersStats(UsersStatsModel stats) async {
    try {
      final Map<String, dynamic> jsonMap = {
        'total_users': stats.totalUsers,
        'active_users': stats.activeUsers,
        'inactive_users': stats.inactiveUsers,
        'users': stats.users.map((u) => u.toJson()).toList(),
      };
      await _statsBox.put(_statsKey, jsonEncode(jsonMap));
      await _statsBox.put(_timestampKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      throw CacheException(message: 'Failed to cache users stats: $e');
    }
  }

  @override
  Future<List<UserModel>> getCachedUsers() async {
    try {
      return _usersBox.values.toList();
    } catch (e) {
      throw CacheException(message: 'Failed to read cached users: $e');
    }
  }

  @override
  Future<void> cacheUsers(List<UserModel> users) async {
    try {
      await _usersBox.clear();
      final Map<dynamic, UserModel> entries = {
        for (final user in users) user.id: user,
      };
      await _usersBox.putAll(entries);
    } catch (e) {
      throw CacheException(message: 'Failed to cache users list: $e');
    }
  }

  @override
  Future<bool> isStatsCacheValid() async {
    try {
      final timestamp = _statsBox.get(_timestampKey) as int?;
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
      await _statsBox.delete(_statsKey);
      await _statsBox.delete(_timestampKey);
      await _usersBox.clear();
    } catch (e) {
      throw CacheException(message: 'Failed to clear users cache: $e');
    }
  }
}
