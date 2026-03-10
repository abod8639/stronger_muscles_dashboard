import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/config/api_config.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> getProductById(String id);
  Future<ProductModel> addProduct(ProductModel product);
  Future<ProductModel> updateProduct(ProductModel product);
  Future<bool> deleteProduct(String id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio dio;

  ProductRemoteDataSourceImpl(this.dio);

  @override
  Future<List<ProductModel>> getProducts() async {
    final response = await dio.get(ApiConfig.adminProducts);
    if (response.statusCode == 200) {
      final List data = response.data;
      final products = <ProductModel>[];
      for (var item in data) {
        try {
          products.add(ProductModel.fromJson(item as Map<String, dynamic>));
        } catch (e) {
          print('X Error parsing product: $e');
          print('  Corrupted data: $item');
        }
      }
      return products;
    }
    throw Exception('Failed to load products');
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    final response = await dio.get('${ApiConfig.adminProducts}/$id');
    if (response.statusCode == 200) {
      return ProductModel.fromJson(response.data);
    }
    throw Exception('Failed to load product');
  }

  @override
  Future<ProductModel> addProduct(ProductModel product) async {
    final response = await dio.post(ApiConfig.adminProducts, data: product.toJson());
    if (response.statusCode == 201 || response.statusCode == 200) {
      return ProductModel.fromJson(response.data);
    }
    throw Exception('Failed to add product');
  }

  @override
  Future<ProductModel> updateProduct(ProductModel product) async {
    final response = await dio.put('${ApiConfig.adminProducts}/${product.id}', data: product.toJson());
    if (response.statusCode == 200) {
      return ProductModel.fromJson(response.data);
    }
    throw Exception('Failed to update product');
  }

  @override
  Future<bool> deleteProduct(String id) async {
    final response = await dio.delete('${ApiConfig.adminProducts}/$id');
    return response.statusCode == 200 || response.statusCode == 204;
  }
}
