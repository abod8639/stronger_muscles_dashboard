import 'package:dio/dio.dart';
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
    final response = await dio.get('/products');
    if (response.statusCode == 200) {
      final List data = response.data;
      return data.map((e) => ProductModel.fromJson(e)).toList();
    }
    throw Exception('Failed to load products');
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    final response = await dio.get('/products/$id');
    if (response.statusCode == 200) {
      return ProductModel.fromJson(response.data);
    }
    throw Exception('Failed to load product');
  }

  @override
  Future<ProductModel> addProduct(ProductModel product) async {
    final response = await dio.post('/products', data: product.toJson());
    if (response.statusCode == 201 || response.statusCode == 200) {
      return ProductModel.fromJson(response.data);
    }
    throw Exception('Failed to add product');
  }

  @override
  Future<ProductModel> updateProduct(ProductModel product) async {
    final response = await dio.put('/products/${product.id}', data: product.toJson());
    if (response.statusCode == 200) {
      return ProductModel.fromJson(response.data);
    }
    throw Exception('Failed to update product');
  }

  @override
  Future<bool> deleteProduct(String id) async {
    final response = await dio.delete('/products/$id');
    return response.statusCode == 200 || response.statusCode == 204;
  }
}
