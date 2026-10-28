import 'package:hive/hive.dart';
import 'package:stronger_muscles_dashboard/core/error/exceptions.dart';
import '../models/order_model.dart';

/// Contract for local caching of orders via Hive.
abstract class OrderLocalDataSource {
  Future<List<OrderModel>> getCachedOrders();
  Future<void> cacheOrders(List<OrderModel> orders);
  Future<OrderModel?> getCachedOrderById(String id);
  Future<void> cacheOrder(OrderModel order);
  Future<bool> isCacheValid();
  Future<void> clearCache();
}

/// Production implementation of [OrderLocalDataSource] using Hive [Box<OrderModel>].
/// 100% testable via constructor dependency injection.
class OrderLocalDataSourceImpl implements OrderLocalDataSource {
  final Box<OrderModel> _box;
  static const Duration _cacheTtl = Duration(minutes: 10);
  static DateTime? _lastFetchTime;

  OrderLocalDataSourceImpl({required Box<OrderModel> box}) : _box = box;

  @override
  Future<List<OrderModel>> getCachedOrders() async {
    try {
      return _box.values.toList();
    } catch (e) {
      throw CacheException(message: 'Failed to retrieve cached orders: $e');
    }
  }

  @override
  Future<void> cacheOrders(List<OrderModel> orders) async {
    try {
      final map = {for (final o in orders) o.id: o};
      await _box.putAll(map);
      _lastFetchTime = DateTime.now();
    } catch (e) {
      throw CacheException(message: 'Failed to cache orders: $e');
    }
  }

  @override
  Future<OrderModel?> getCachedOrderById(String id) async {
    try {
      return _box.get(id);
    } catch (e) {
      throw CacheException(message: 'Failed to retrieve cached order #$id: $e');
    }
  }

  @override
  Future<void> cacheOrder(OrderModel order) async {
    try {
      await _box.put(order.id, order);
    } catch (e) {
      throw CacheException(message: 'Failed to cache order #${order.id}: $e');
    }
  }

  @override
  Future<bool> isCacheValid() async {
    if (_lastFetchTime == null) return false;
    return DateTime.now().difference(_lastFetchTime!) < _cacheTtl;
  }

  @override
  Future<void> clearCache() async {
    try {
      await _box.clear();
      _lastFetchTime = null;
    } catch (e) {
      throw CacheException(message: 'Failed to clear orders cache: $e');
    }
  }
}
