import 'package:hive_ce/hive.dart';
import '../models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getCachedProducts();
  Future<void> cacheProducts(List<ProductModel> products);
  Future<ProductModel?> getCachedProductById(String id);
  Future<void> cacheProduct(ProductModel product);
  Future<void> deleteCachedProduct(String id);
  Future<void> clearCache();
  Future<bool> isCacheValid();
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final Box<ProductModel> _productsBox;
  DateTime? _lastCacheTime;
  static const Duration _cacheDuration = Duration(minutes: 10);

  ProductLocalDataSourceImpl(this._productsBox);

  @override
  Future<List<ProductModel>> getCachedProducts() async {
    return _productsBox.values.toList();
  }

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    await _productsBox.clear();
    final entries = {for (var p in products) p.id: p};
    await _productsBox.putAll(entries);
    _lastCacheTime = DateTime.now();
  }

  @override
  Future<ProductModel?> getCachedProductById(String id) async {
    return _productsBox.get(id);
  }

  @override
  Future<void> cacheProduct(ProductModel product) async {
    await _productsBox.put(product.id, product);
  }

  @override
  Future<void> deleteCachedProduct(String id) async {
    await _productsBox.delete(id);
  }

  @override
  Future<void> clearCache() async {
    await _productsBox.clear();
    _lastCacheTime = null;
  }

  @override
  Future<bool> isCacheValid() async {
    if (_lastCacheTime == null || _productsBox.isEmpty) {
      return false;
    }
    return DateTime.now().difference(_lastCacheTime!) < _cacheDuration;
  }
}
