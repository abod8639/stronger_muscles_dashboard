import 'dart:io';
import 'package:dio/dio.dart';
import '../../../config/api_config.dart';
import 'api_base.dart';

class CategoryService extends ApiBase {
  Future<List<dynamic>> fetchCategories({bool tree = false}) async {
    try {
      final response = await dio.get(
        ApiConfig.adminCategories,
        queryParameters: tree ? {'tree': 1} : null,
      );

      final decoded = response.data;
      if (decoded is Map && decoded.containsKey('data')) {
        var data = decoded['data'];
        return (data is Map && data.containsKey('data'))
            ? data['data']
            : (data is List ? data : []);
      }
      return decoded is List ? decoded : [];
    } on DioException catch (e) {
      _logError(e, 'جلب التصنيفات');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> addCategory(Map<String, dynamic> data) async {
    try {
      final response = await dio.post(ApiConfig.adminCategories, data: data);
      return response.data;
    } on DioException catch (e) {
      throw Exception(_parseErrorMessage(e, 'إضافة التصنيف'));
    }
  }

  Future<Map<String, dynamic>> updateCategory(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await dio.put(
        ApiConfig.adminCategoryDetail(id),
        data: data,
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(_parseErrorMessage(e, 'تحديث التصنيف'));
    }
  }

  Future<bool> deleteCategory(String id) async {
    try {
      final response = await dio.delete(ApiConfig.adminCategoryDetail(id));
      return response.statusCode == 200 || response.statusCode == 204;
    } on DioException catch (e) {
      _logError(e, 'حذف التصنيف');
      return false;
    }
  }

  Future<String> uploadCategoryImage(String filePath) async {
    try {
      if (!File(filePath).existsSync()) throw Exception('الملف غير موجود');

      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          filePath,
          filename: filePath.split('/').last,
        ),
      });

      final response = await dio.post(
        ApiConfig.adminUploadCategoryImage,
        data: formData,
        options: Options(sendTimeout: const Duration(seconds: 60)),
      );

      final decoded = response.data;
      String? imageUrl = _extractImageUrl(decoded);

      if (imageUrl != null) {
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

  // --- وظائف مساعدة (Helper Methods) ---

  String? _extractImageUrl(dynamic decoded) {
    if (decoded is! Map) return null;
    if (decoded.containsKey('url')) return decoded['url'].toString();
    if (decoded.containsKey('data') && decoded['data'] is Map) {
      return decoded['data']['url']?.toString() ??
          decoded['data']['imageUrl']?.toString();
    }
    return decoded['imageUrl']?.toString() ?? decoded['path']?.toString();
  }

  String _parseErrorMessage(DioException e, String task) {
    _logError(e, task);
    if (e.response?.data is Map) {
      final data = e.response?.data;
      if (data.containsKey('message')) return data['message'];
      if (data.containsKey('errors')) {
        final errors = data['errors'] as Map;
        return errors.values.map((e) => (e as List).join(', ')).join('; ');
      }
    }
    return 'فشل في $task: ${e.message}';
  }

  void _logError(DioException e, String task) {
    print(
      '⚠️ [CategoryService] Error in $task: ${e.response?.statusCode} - ${e.message}',
    );
  }
}
