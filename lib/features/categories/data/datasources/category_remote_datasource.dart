import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/config/api_config.dart';
import 'package:stronger_muscles_dashboard/core/error/exceptions.dart';
import '../models/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getCategories({
    bool tree = false,
    CancelToken? cancelToken,
  });

  Future<CategoryModel> addCategory(
    Map<String, dynamic> categoryData, {
    CancelToken? cancelToken,
  });

  Future<CategoryModel> updateCategory(
    String id,
    Map<String, dynamic> categoryData, {
    CancelToken? cancelToken,
  });

  Future<bool> deleteCategory(
    String id, {
    CancelToken? cancelToken,
  });
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final Dio dio;

  static const Duration _defaultTimeout = Duration(seconds: 15);

  CategoryRemoteDataSourceImpl(this.dio);

  Options get _options => Options(
        sendTimeout: _defaultTimeout,
        receiveTimeout: _defaultTimeout,
        headers: {'Accept': 'application/json'},
      );

  @override
  Future<List<CategoryModel>> getCategories({
    bool tree = false,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.get(
        ApiConfig.adminCategories,
        queryParameters: {'tree': tree ? 1 : 0},
        cancelToken: cancelToken,
        options: _options,
      );

      if (response.statusCode == 200) {
        final dynamic rawData = response.data;
        List<dynamic> listData = [];

        if (rawData is List) {
          listData = rawData;
        } else if (rawData is Map) {
          if (rawData['data'] is List) {
            listData = rawData['data'];
          } else if (rawData['categories'] is List) {
            listData = rawData['categories'];
          } else if (rawData['data'] is Map && rawData['data']['data'] is List) {
            listData = rawData['data']['data'];
          }
        }

        // معالجة القائمة الكبيرة في Isolate خلفي لمنع تجميد الشاشة
        return await CategoryModel.fromJsonListAsync(listData);
      }

      throw ServerException(
        message: 'فشل في تحميل قائمة التصنيفات من الخادم',
        statusCode: response.statusCode,
      );
    } on DioException {
      rethrow;
    } catch (e) {
      if (e is AppException) rethrow;
      throw ParsingException(
        message: 'خطأ أثناء تحليل بيانات التصنيفات: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<CategoryModel> addCategory(
    Map<String, dynamic> categoryData, {
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.post(
        ApiConfig.adminCategories,
        data: categoryData,
        cancelToken: cancelToken,
        options: _options,
      );

      final data = response.data;
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          data is Map<String, dynamic>) {
        final categoryMap = (data['category'] ?? data['data'] ?? data) as Map<String, dynamic>;
        return await CategoryModel.fromJsonAsync(categoryMap);
      }

      throw ServerException(
        message: data is Map ? (data['message']?.toString() ?? 'فشل إضافة التصنيف') : 'فشل إضافة التصنيف',
        statusCode: response.statusCode,
      );
    } on DioException {
      rethrow;
    } catch (e) {
      if (e is AppException) rethrow;
      throw ParsingException(
        message: 'خطأ أثناء معالجة إضافة التصنيف: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<CategoryModel> updateCategory(
    String id,
    Map<String, dynamic> categoryData, {
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.put(
        ApiConfig.adminCategoryDetail(id),
        data: categoryData,
        cancelToken: cancelToken,
        options: _options,
      );

      final data = response.data;
      if (response.statusCode == 200 && data is Map<String, dynamic>) {
        final categoryMap = (data['category'] ?? data['data'] ?? data) as Map<String, dynamic>;
        return await CategoryModel.fromJsonAsync(categoryMap);
      }

      throw ServerException(
        message: data is Map ? (data['message']?.toString() ?? 'فشل تحديث التصنيف') : 'فشل تحديث التصنيف',
        statusCode: response.statusCode,
      );
    } on DioException {
      rethrow;
    } catch (e) {
      if (e is AppException) rethrow;
      throw ParsingException(
        message: 'خطأ أثناء معالجة تحديث التصنيف: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<bool> deleteCategory(
    String id, {
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.delete(
        ApiConfig.adminCategoryDetail(id),
        cancelToken: cancelToken,
        options: _options,
      );
      return response.statusCode == 200 || response.statusCode == 204;
    } on DioException {
      rethrow;
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(
        message: 'حدث خطأ غير متوقع أثناء حذف التصنيف: $e',
        originalError: e,
      );
    }
  }
}
