import 'dart:io';
import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/config/api_config.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> getProductById(String id);
  Future<ProductModel> addProduct(Map<String, dynamic> data);
  Future<ProductModel> updateProduct(String id, Map<String, dynamic> data);
  Future<bool> deleteProduct(String id);
  Future<String> uploadImage(String filePath);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio dio;

  ProductRemoteDataSourceImpl(this.dio);

  @override
  Future<List<ProductModel>> getProducts() async {
    List<ProductModel> allProducts = [];
    int currentPage = 1;
    int lastPage = 1;

    do {
      final response = await dio.get(
        ApiConfig.adminProducts,
        queryParameters: {'page': currentPage},
      );

      if (response.statusCode == 200) {
        final decoded = response.data;
        dynamic data;
        
        if (decoded is Map) {
          lastPage = decoded['meta']?['last_page'] ?? decoded['last_page'] ?? 1;
          data = decoded['data'];
          
          if (data is Map && data.containsKey('data')) {
            data = data['data'];
            lastPage = decoded['data']['last_page'] ?? lastPage;
          }
        } else if (decoded is List) {
          data = decoded;
          lastPage = 1;
        }

        if (data is List) {
          for (var item in data) {
            try {
              allProducts.add(ProductModel.fromJson(item as Map<String, dynamic>));
            } catch (e) {
              print('X Error parsing product: $e');
            }
          }
        }
      } else {
        throw Exception('Failed to load products');
      }
      currentPage++;
    } while (currentPage <= lastPage);

    return allProducts;
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    final response = await dio.get('${ApiConfig.adminProducts}/$id');
    if (response.statusCode == 200) {
      final data = (response.data is Map && response.data.containsKey('data'))
          ? response.data['data']
          : response.data;
      return ProductModel.fromJson(data as Map<String, dynamic>);
    }
    throw Exception('Failed to load product');
  }

  @override
  Future<ProductModel> addProduct(Map<String, dynamic> data) async {
    final response = await dio.post(ApiConfig.adminProducts, data: data);
    if (response.statusCode == 201 || response.statusCode == 200) {
      final responseData = (response.data is Map && response.data.containsKey('data'))
          ? response.data['data']
          : response.data;
      return ProductModel.fromJson(responseData as Map<String, dynamic>);
    }
    throw Exception('Failed to add product');
  }

  @override
  Future<ProductModel> updateProduct(String id, Map<String, dynamic> data) async {
    final response = await dio.put('${ApiConfig.adminProducts}/$id', data: data);
    if (response.statusCode == 200) {
      final responseData = (response.data is Map && response.data.containsKey('data'))
          ? response.data['data']
          : response.data;
      return ProductModel.fromJson(responseData as Map<String, dynamic>);
    }
    throw Exception('Failed to update product');
  }

  @override
  Future<bool> deleteProduct(String id) async {
    final response = await dio.delete('${ApiConfig.adminProducts}/$id');
    return response.statusCode == 200 || response.statusCode == 204;
  }

  @override
  Future<String> uploadImage(String filePath) async {
    if (!File(filePath).existsSync()) throw Exception('الملف غير موجود');

    FormData formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        filePath,
        filename: filePath.split('/').last,
      ),
    });

    final response = await dio.post(
      ApiConfig.adminUploadProductImage,
      data: formData,
    );

    if (response.statusCode == 200) {
      final data = response.data;
      String? imageUrl = data['url']?.toString() ??
          data['data']?['url']?.toString() ??
          data['imageUrl']?.toString() ??
          data['path']?.toString();
      
      if (imageUrl != null) return imageUrl;
    }
    throw Exception('Failed to upload image');
  }
}
