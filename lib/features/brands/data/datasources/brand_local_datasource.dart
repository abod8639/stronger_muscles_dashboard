import 'package:hive_ce/hive.dart';
import 'package:stronger_muscles_dashboard/core/error/exceptions.dart';
import '../models/brand_model.dart';

/// Contract for caching brands locally using Hive.
abstract class BrandLocalDataSource {
  Future<List<BrandModel>> getCachedBrands();
  Future<void> cacheBrands(List<BrandModel> brands);
  Future<void> clearCache();
  Future<bool> isCacheValid();
}

/// Hive-backed implementation of [BrandLocalDataSource].
/// 100% testable via Constructor Dependency Injection of [Box].
class BrandLocalDataSourceImpl implements BrandLocalDataSource {
  final Box _box;

  static const String _brandsKey = 'cached_brands_list';
  static const String _lastCacheTimeKey = 'cached_brands_timestamp';
  static const Duration _cacheTtl = Duration(hours: 4);

  const BrandLocalDataSourceImpl({required Box box}) : _box = box;

  @override
  Future<List<BrandModel>> getCachedBrands() async {
    try {
      final raw = _box.get(_brandsKey);
      if (raw is List) {
        return raw.map((item) {
          if (item is Map) {
            return BrandModel.fromJson(Map<String, dynamic>.from(item));
          }
          throw const FormatException('Invalid brand format in cache');
        }).toList();
      }
      return [];
    } catch (e) {
      throw CacheException(
        message: 'فشل في استرجاع العلامات التجارية من الذاكرة المحلية (Hive)',
        originalError: e,
      );
    }
  }

  @override
  Future<void> cacheBrands(List<BrandModel> brands) async {
    try {
      final jsonList = brands.map((b) => b.toJson()).toList();
      await _box.put(_brandsKey, jsonList);
      await _box.put(_lastCacheTimeKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      throw CacheException(
        message: 'فشل في حفظ قائمة العلامات التجارية في الذاكرة المحلية (Hive)',
        originalError: e,
      );
    }
  }

  @override
  Future<bool> isCacheValid() async {
    try {
      final timestamp = _box.get(_lastCacheTimeKey);
      if (timestamp is int) {
        final cachedDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
        final isExpired = DateTime.now().difference(cachedDate) > _cacheTtl;
        final hasData = _box.containsKey(_brandsKey);
        return !isExpired && hasData;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await _box.delete(_brandsKey);
      await _box.delete(_lastCacheTimeKey);
    } catch (e) {
      throw CacheException(
        message: 'فشل في مسح ذاكرة التخزين المؤقت للعلامات التجارية',
        originalError: e,
      );
    }
  }
}
