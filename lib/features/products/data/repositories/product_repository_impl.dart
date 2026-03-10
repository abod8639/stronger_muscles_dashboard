import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';
import '../models/product_model.dart';
import 'package:stronger_muscles_dashboard/core/storage/cache_service.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  late final CacheService _cacheService;

  static const String _cacheKeyProducts = 'products_list';

  ProductRepositoryImpl(this.remoteDataSource) {
    _cacheService = Get.find<CacheService>();
  }

  @override
  Future<List<ProductEntity>> getProducts({bool forceRefresh = false}) async {
    try {
      if (forceRefresh) {
        _cacheService.remove(_cacheKeyProducts);
      }

      if (!forceRefresh && _cacheService.hasValid(_cacheKeyProducts)) {
        final cachedData = _cacheService.get<List<ProductModel>>(_cacheKeyProducts);
        if (cachedData != null) {
          debugPrint('✓ Retrieved products from cache');
          return cachedData.map((e) => e.toEntity()).toList();
        }
      }

      debugPrint('↓ Fetching products from remote...');
      final models = await remoteDataSource.getProducts();
      
      _cacheService.set(_cacheKeyProducts, models);
      return models.map((e) => e.toEntity()).toList();
    } catch (e) {
      debugPrint('X Error in ProductRepositoryImpl: $e');
      rethrow;
    }
  }

  @override
  Future<ProductEntity> getProductById(String id) async {
    final model = await remoteDataSource.getProductById(id);
    return model.toEntity();
  }

  @override
  Future<ProductEntity> addProduct(ProductEntity product) async {
    final model = _toModel(product);
    final newModel = await remoteDataSource.addProduct(model);
    _cacheService.remove(_cacheKeyProducts);
    return newModel.toEntity();
  }

  @override
  Future<ProductEntity> updateProduct(ProductEntity product) async {
    final model = _toModel(product);
    final updatedModel = await remoteDataSource.updateProduct(model);
    _cacheService.remove(_cacheKeyProducts);
    return updatedModel.toEntity();
  }

  @override
  Future<bool> deleteProduct(String id) async {
    final success = await remoteDataSource.deleteProduct(id);
    if (success) {
      _cacheService.remove(_cacheKeyProducts);
    }
    return success;
  }

  ProductModel _toModel(ProductEntity product) {
    return ProductModel(
      id: product.id,
      price: product.price,
      discountPrice: product.discountPrice,
      imageUrls: product.imageUrls,
      categoryId: product.categoryId,
      stockQuantity: product.stockQuantity,
      brand: product.brand,
      isActive: product.isActive,
      productSizes: product.productSizes,
      flavor: product.flavors, 
      name: TranslatableString(ar: product.nameAr, en: product.nameEn), 
      description: TranslatableString(ar: product.descriptionAr, en: product.descriptionEn),
    );
  }
}
