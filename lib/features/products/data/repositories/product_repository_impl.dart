import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/core/storage/cache_service.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remoteDataSource;
  late final CacheService _cacheService;

  static const String _cacheKeyProducts = 'products_list';

  ProductRepositoryImpl(this._remoteDataSource) {
    _cacheService = Get.find<CacheService>();
  }

  @override
  Future<List<ProductEntity>> getProducts({bool forceRefresh = false}) async {
    try {
      if (!forceRefresh) {
        final cachedData = _cacheService.get<List<ProductModel>>(_cacheKeyProducts);
        if (cachedData != null) {
          return cachedData.map((m) => m.toEntity()).toList();
        }
      }

      final models = await _remoteDataSource.getProducts();
      _cacheService.set(_cacheKeyProducts, models, cacheDurationSeconds: 300);
      return models.map((m) => m.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ProductEntity> getProductById(String id) async {
    final model = await _remoteDataSource.getProductById(id);
    return model.toEntity();
  }

  @override
  Future<ProductEntity> addProduct(Map<String, dynamic> productData) async {
    final model = await _remoteDataSource.addProduct(productData);
    _cacheService.remove(_cacheKeyProducts);
    return model.toEntity();
  }

  @override
  Future<ProductEntity> updateProduct(String id, Map<String, dynamic> productData) async {
    final model = await _remoteDataSource.updateProduct(id, productData);
    _cacheService.remove(_cacheKeyProducts);
    return model.toEntity();
  }

  @override
  Future<bool> deleteProduct(String id) async {
    final result = await _remoteDataSource.deleteProduct(id);
    if (result) {
      _cacheService.remove(_cacheKeyProducts);
    }
    return result;
  }

  @override
  Future<String> uploadImage(String filePath) async {
    return await _remoteDataSource.uploadImage(filePath);
  }
}
