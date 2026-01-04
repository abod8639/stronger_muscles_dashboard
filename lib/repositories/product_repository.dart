import '../models/index.dart';
import '../services/api_service.dart';

class ProductRepository {
  final ApiService _apiService;

  ProductRepository(this._apiService);

  Future<List<ProductModel>> getProducts() async {
    try {
      final List<dynamic>data = await _apiService.fetchProducts();
      return data
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } catch (e) {
      print('خطأ في ProductRepository: $e');
      rethrow;
    }
  }

  Future<ProductModel> addProduct(Map<String, dynamic> productJson) async {
    try {
      final dynamic data = await _apiService.addProduct(productJson);
      final productData = (data.containsKey('data')) ? data['data'] : data;
      return ProductModel.fromJson(productData as Map<String, dynamic>);
    } catch (e) {
      print('خطأ في إضافة المنتج: $e');
      rethrow;
    }
  }

  Future<ProductModel> updateProduct(String id, Map<String, dynamic> productJson) async {
    try {
      final Map<String, dynamic>data = await _apiService.updateProduct(id, productJson);
      final productData = (data.containsKey('data')) ? data['data'] : data;
      return ProductModel.fromJson(productData as Map<String, dynamic>);
    } catch (e) {
      print('خطأ في تحديث المنتج: $e');
      rethrow;
    }
  }

  Future<bool> deleteProduct(String id) async {
    try {
      return await _apiService.deleteProduct(id);
    } catch (e) {
      print('خطأ في حذف المنتج في المستودع: $e');
      return false;
    }
  }
}
