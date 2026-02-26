import 'package:get/get.dart';

/// Cache Service for managing data caching with TTL (Time To Live)
class CacheService extends GetxService {
  static const int defaultCacheDurationSeconds = 300; // 5 minutes

  final Map<String, CacheEntry> _cache = {};

  /// Get cached data if valid (not expired)
  T? get<T>(String key) {
    if (!_cache.containsKey(key)) {
      return null;
    }

    final entry = _cache[key]!;
    if (entry.isExpired()) {
      _cache.remove(key);
      return null;
    }

    return entry.data as T?;
  }

  /// Store data in cache with optional custom duration
  void set<T>(
    String key,
    T data, {
    int cacheDurationSeconds = defaultCacheDurationSeconds,
  }) {
    _cache[key] = CacheEntry(
      data: data,
      expiresAt: DateTime.now().add(Duration(seconds: cacheDurationSeconds)),
    );
  }

  /// Clear specific cache entry
  void remove(String key) {
    _cache.remove(key);
  }

  /// Clear all cache
  void clear() {
    _cache.clear();
  }

  /// Check if cache entry exists and is valid
  bool hasValid(String key) {
    if (!_cache.containsKey(key)) {
      return false;
    }

    final entry = _cache[key]!;
    if (entry.isExpired()) {
      _cache.remove(key);
      return false;
    }

    return true;
  }

  /// Get cache stats for debugging
  Map<String, dynamic> getStats() {
    return {
      'totalEntries': _cache.length,
      'entries': _cache.entries
          .map((e) => {
                'key': e.key,
                'isExpired': e.value.isExpired(),
                'expiresIn': e.value.expiresAt.difference(DateTime.now()),
              })
          .toList(),
    };
  }
}

class CacheEntry {
  final dynamic data;
  final DateTime expiresAt;

  CacheEntry({
    required this.data,
    required this.expiresAt,
  });

  bool isExpired() => DateTime.now().isAfter(expiresAt);
}
