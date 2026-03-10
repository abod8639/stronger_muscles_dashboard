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
          return cachedData;
        }
      }

      debugPrint('↓ Fetching products from remote...');
      final products = await remoteDataSource.getProducts();
      
      _cacheService.set(_cacheKeyProducts, products);
      return products;
    } catch (e) {
      debugPrint('X Error in ProductRepositoryImpl: $e');
      rethrow;
    }
  }

  @override
  Future<ProductEntity> getProductById(String id) async {
    return await remoteDataSource.getProductById(id);
  }

  @override
  Future<ProductEntity> addProduct(ProductEntity product) async {
    final model = _toModel(product);
    final newProduct = await remoteDataSource.addProduct(model);
    _cacheService.remove(_cacheKeyProducts);
    return newProduct;
  }

  @override
  Future<ProductEntity> updateProduct(ProductEntity product) async {
    final model = _toModel(product);
    final updatedProduct = await remoteDataSource.updateProduct(model);
    _cacheService.remove(_cacheKeyProducts);
    return updatedProduct;
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
      nameAr: product.nameAr,
      nameEn: product.nameEn,
      descriptionAr: product.descriptionAr,
      descriptionEn: product.descriptionEn,
      price: product.price,
      discountPrice: product.discountPrice,
      imageUrls: product.imageUrls,
      categoryId: product.categoryId,
      stockQuantity: product.stockQuantity,
      brand: product.brand,
      isActive: product.isActive,
      productSizes: product.productSizes,
      flavors: product.flavors,
    );
  }
}
