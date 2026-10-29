import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:stronger_muscles_dashboard/core/error/exceptions.dart';
import '../models/promo_model.dart';

/// Contract for local caching of promotional banners using Hive.
abstract class PromoLocalDataSource {
  Future<List<PromoModel>> getCachedPromos();
  Future<void> cachePromos(List<PromoModel> promos);
  Future<PromoModel?> getCachedPromoById(String id);
  Future<void> cachePromo(PromoModel promo);
  Future<void> deleteCachedPromo(String id);
  Future<bool> isCacheValid();
  Future<void> clearCache();
}

/// Hive-backed production implementation of [PromoLocalDataSource].
/// 100% testable via constructor dependency injection of [Box].
class PromoLocalDataSourceImpl implements PromoLocalDataSource {
  static const String _promosKey = 'CACHED_PROMOS_LIST';
  static const String _timestampKey = 'CACHED_PROMOS_TIMESTAMP';
  static const Duration _cacheTtl = Duration(minutes: 10);

  final Box _box;

  const PromoLocalDataSourceImpl({required Box box}) : _box = box;

  @override
  Future<List<PromoModel>> getCachedPromos() async {
    try {
      final raw = _box.get(_promosKey);
      if (raw == null) return [];

      if (raw is List) {
        return raw.map((item) {
          final map = item is String
              ? jsonDecode(item) as Map<String, dynamic>
              : Map<String, dynamic>.from(item as Map);
          return PromoModel.fromJson(map);
        }).toList();
      }
      return [];
    } catch (e) {
      throw CacheException(
        message: 'فشل في استرجاع الإعلانات من الذاكرة المحلية (Hive): $e',
      );
    }
  }

  @override
  Future<void> cachePromos(List<PromoModel> promos) async {
    try {
      final jsonList = promos.map((p) => p.toJson()).toList();
      await _box.put(_promosKey, jsonList);
      await _box.put(_timestampKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      throw CacheException(
        message: 'فشل في حفظ الإعلانات في الذاكرة المحلية (Hive): $e',
      );
    }
  }

  @override
  Future<PromoModel?> getCachedPromoById(String id) async {
    try {
      final list = await getCachedPromos();
      final index = list.indexWhere((p) => p.id == id);
      return index != -1 ? list[index] : null;
    } catch (e) {
      throw CacheException(
        message: 'فشل في استرجاع الإعلان من الذاكرة المحلية: $e',
      );
    }
  }

  @override
  Future<void> cachePromo(PromoModel promo) async {
    try {
      final list = await getCachedPromos();
      final index = list.indexWhere((p) => p.id == promo.id);
      if (index != -1) {
        list[index] = promo;
      } else {
        list.insert(0, promo);
      }
      await cachePromos(list);
    } catch (e) {
      throw CacheException(message: 'فشل في تحديث كاش الإعلان: $e');
    }
  }

  @override
  Future<void> deleteCachedPromo(String id) async {
    try {
      final list = await getCachedPromos();
      list.removeWhere((p) => p.id == id);
      await cachePromos(list);
    } catch (e) {
      throw CacheException(
        message: 'فشل في حذف الإعلان من الذاكرة المحلية: $e',
      );
    }
  }

  @override
  Future<bool> isCacheValid() async {
    try {
      final timestamp = _box.get(_timestampKey) as int?;
      if (timestamp == null || !_box.containsKey(_promosKey)) {
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
      await _box.delete(_promosKey);
      await _box.delete(_timestampKey);
    } catch (e) {
      throw CacheException(message: 'فشل في مسح ذاكرة الإعلانات المؤقتة: $e');
    }
  }
}
