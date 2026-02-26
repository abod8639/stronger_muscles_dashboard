import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../models/index.dart';
import '../services/api_service.dart';
import '../services/cache_service.dart';

class ProductRepository {
  final ApiService _apiService;
  late final CacheService _cacheService;

  static const String _cacheKeyProducts = 'products_list';

  ProductRepository(this._apiService) {
    _cacheService = Get.put(CacheService(), permanent: true);
  }

  Future<List<ProductModel>> getProducts() async {
    try {
      // معادلة cache أولاً
      final cachedData = _cacheService.get<List<ProductModel>>(
        _cacheKeyProducts,
      );
      if (cachedData != null) {
        debugPrint('✓ تم استرجاع المنتجات من الـ Cache');
        return cachedData;
      }

      debugPrint('↓ جاري تحميل المنتجات من الخادم...');
      final List<dynamic> data = await _apiService.fetchProducts();
      final products = data.map((json) {
        try {
          return ProductModel.fromJson(json as Map<String, dynamic>);
        } catch (e) {
          // سيخبرك بالضبط أي ID منتج فشل وما هو الحقل
          debugPrint('فشل تحويل المنتج ID: ${json['id']} - الخطأ: $e');
          rethrow;
        }
      }).toList();

      // حفظ البيانات في الـ Cache لمدة 5 دقائق
      _cacheService.set(_cacheKeyProducts, products, cacheDurationSeconds: 300);
      return products;
    } catch (e) {
      debugPrint('خطأ في ProductRepository (getProducts): $e');
      rethrow;
    }
  }

  Future<ProductModel> addProduct(Map<String, dynamic> productJson) async {
    try {
      final dynamic data = await _apiService.addProduct(productJson);
      final productData = (data.containsKey('data')) ? data['data'] : data;
      // تنظيف الـ Cache بعد إضافة منتج جديد
      _cacheService.remove(_cacheKeyProducts);
      debugPrint('✗ تم حذف Cache المنتجات بعد إضافة منتج جديد');
      return ProductModel.fromJson(productData as Map<String, dynamic>);
    } catch (e) {
      print('خطأ في إضافة المنتج: $e');
      rethrow;
    }
  }

  Future<ProductModel> updateProduct(
    String id,
    Map<String, dynamic> productJson,
  ) async {
    try {
      final Map<String, dynamic> data = await _apiService.updateProduct(
        id,
        productJson,
      );
      final productData = (data.containsKey('data')) ? data['data'] : data;
      // تنظيف الـ Cache بعد تحديث منتج
      _cacheService.remove(_cacheKeyProducts);
      debugPrint('✗ تم حذف Cache المنتجات بعد تحديث منتج');
      return ProductModel.fromJson(productData as Map<String, dynamic>);
    } catch (e) {
      print('خطأ في تحديث المنتج: $e');
      rethrow;
    }
  }

  Future<bool> deleteProduct(String id) async {
    try {
      final result = await _apiService.deleteProduct(id);
      // تنظيف الـ Cache بعد حذف منتج
      if (result) {
        _cacheService.remove(_cacheKeyProducts);
        debugPrint('✗ تم حذف Cache المنتجات بعد حذف منتج');
      }
      return result;
    } catch (e) {
      print('خطأ في حذف المنتج في المستودع: $e');
      return false;
    }
  }
}
