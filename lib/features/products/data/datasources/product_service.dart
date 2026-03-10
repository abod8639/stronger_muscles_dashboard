import 'dart:io';
import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/config/api_config.dart';
import 'package:stronger_muscles_dashboard/core/network/api_base.dart';


class ProductService extends ApiBase {
  Future<List<dynamic>> fetchProducts() async {
    try {
      List<dynamic> allProducts = [];
      int currentPage = 1;
      int lastPage = 1;

      do {
        final response = await dio.get(
          ApiConfig.adminProducts,
          queryParameters: {'page': currentPage},
        );

        final decoded = response.data;
        List<dynamic> pageItems = [];

        if (decoded is Map) {
          lastPage = decoded['meta']?['last_page'] ?? decoded['last_page'] ?? 1;

          var data = decoded['data'];
          if (data is List) {
            pageItems = data;
          } else if (data is Map && data['data'] is List) {
            pageItems = data['data'];
            // تحديث lastPage إذا كان داخل كائن data
            lastPage = data['last_page'] ?? lastPage;
          }
        } else if (decoded is List) {
          pageItems = decoded;
          lastPage = 1;
        }

        allProducts.addAll(pageItems);
        currentPage++;
      } while (currentPage <= lastPage);

      return allProducts;
    } on DioException catch (e) {
      _logError(e, 'جلب المنتجات');
      rethrow;
    }
  }

  /// إضافة منتج جديد
  Future<Map<String, dynamic>> addProduct(Map<String, dynamic> data) async {
    try {
      final response = await dio.post(ApiConfig.adminProducts, data: data);
      return response.data;
    } on DioException catch (e) {
      throw Exception(_parseErrorMessage(e, 'إضافة المنتج'));
    }
  }

  /// تحديث منتج
  Future<Map<String, dynamic>> updateProduct(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await dio.put(
        ApiConfig.adminProductDetail(id),
        data: data,
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(_parseErrorMessage(e, 'تحديث المنتج'));
    }
  }

  /// حذف منتج
  Future<bool> deleteProduct(String id) async {
    try {
      final response = await dio.delete(ApiConfig.adminProductDetail(id));
      return response.statusCode == 200 || response.statusCode == 204;
    } on DioException catch (e) {
      _logError(e, 'حذف المنتج');
      return false;
    }
  }

  /// رفع صورة المنتج
  Future<String> uploadProductImage(String filePath) async {
    try {
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
        options: Options(sendTimeout: const Duration(seconds: 60)),
      );

      String? imageUrl = _extractImageUrl(response.data);

      if (imageUrl != null) {
        // تصحيح الرابط والمنفذ (8000 -> 8080)
        if (!imageUrl.startsWith('http')) {
          imageUrl = '${ApiConfigController().baseUrl.value}/../$imageUrl';
        }
        return imageUrl.replaceAll('localhost:8000', 'localhost:8080');
      }

      throw Exception('لم يتم استلام رابط الصورة من الخادم');
    } on DioException catch (e) {
      throw Exception(_parseErrorMessage(e, 'رفع الصورة'));
    }
  }

  String? _extractImageUrl(dynamic decoded) {
    if (decoded is! Map) return null;
    return decoded['url']?.toString() ??
        decoded['data']?['url']?.toString() ??
        decoded['imageUrl']?.toString() ??
        decoded['path']?.toString();
  }

  String _parseErrorMessage(DioException e, String task) {
    final data = e.response?.data;
    if (data is Map) {
      if (data.containsKey('message')) return data['message'];
      if (data.containsKey('errors')) {
        final errors = data['errors'] as Map;
        return errors.values.map((v) => (v as List).join(', ')).join('; ');
      }
    }
    return 'خطأ في $task: ${e.message}';
  }

  void _logError(DioException e, String task) {
    print('⚠️ [ProductService] Error in $task: ${e.message}');
  }
}
