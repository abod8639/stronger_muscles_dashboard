import 'dart:io';
import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/core/config/api_config.dart';
import 'package:stronger_muscles_dashboard/core/error/exceptions.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts({CancelToken? cancelToken});
  Future<ProductModel> getProductById(String id, {CancelToken? cancelToken});
  Future<ProductModel> addProduct(
    Map<String, dynamic> data, {
    CancelToken? cancelToken,
  });
  Future<ProductModel> updateProduct(
    String id,
    Map<String, dynamic> data, {
    CancelToken? cancelToken,
  });
  Future<bool> deleteProduct(String id, {CancelToken? cancelToken});
  Future<String> uploadImage(String filePath, {CancelToken? cancelToken});
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio dio;

  static const Duration _defaultTimeout = Duration(seconds: 30);
  static const Duration _uploadTimeout = Duration(seconds: 60);

  ProductRemoteDataSourceImpl(this.dio);

  Options get _options => Options(
    sendTimeout: _defaultTimeout,
    receiveTimeout: _defaultTimeout,
    headers: {'Accept': 'application/json'},
  );

  @override
  Future<List<ProductModel>> getProducts({CancelToken? cancelToken}) async {
    try {
      final List<dynamic> allRawItems = [];
      int currentPage = 1;
      int lastPage = 1;

      do {
        final response = await dio.get(
          ApiConfig.adminProducts,
          queryParameters: {'page': currentPage},
          cancelToken: cancelToken,
          options: _options,
        );

        if (response.statusCode == 200) {
          final decoded = response.data;
          dynamic data;

          if (decoded is Map) {
            lastPage =
                decoded['meta']?['last_page'] ?? decoded['last_page'] ?? 1;
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
            allRawItems.addAll(data);
          }
        } else {
          throw ServerException(
            message:
                'فشل في استلام بيانات المنتجات (كود: ${response.statusCode})',
            statusCode: response.statusCode,
          );
        }
        currentPage++;
      } while (currentPage <= lastPage);

      // عزل معالجة وتحليل قائمة المنتجات في Isolate خلفي لمنع تجميد الشاشة
      return await ProductModel.fromJsonListAsync(allRawItems);
    } on DioException {
      rethrow;
    } catch (e) {
      if (e is AppException) rethrow;
      throw ParsingException(
        message: 'خطأ أثناء تحليل بيانات المنتجات: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<ProductModel> getProductById(
    String id, {
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.get(
        '${ApiConfig.adminProducts}/$id',
        cancelToken: cancelToken,
        options: _options,
      );

      if (response.statusCode == 200) {
        final data = (response.data is Map && response.data.containsKey('data'))
            ? response.data['data']
            : response.data;

        if (data is! Map) {
          throw const ParsingException(
            message: 'بنية استجابة تفاصيل المنتج غير صالحة',
          );
        }

        return await ProductModel.fromJsonAsync(
          Map<String, dynamic>.from(data),
        );
      }

      throw ServerException(
        message: 'فشل في تحميل تفاصيل المنتج رقم: $id',
        statusCode: response.statusCode,
      );
    } on DioException {
      rethrow;
    } catch (e) {
      if (e is AppException) rethrow;
      throw ParsingException(
        message: 'خطأ أثناء تحليل تفاصيل المنتج: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<ProductModel> addProduct(
    Map<String, dynamic> data, {
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.post(
        ApiConfig.adminProducts,
        data: data,
        cancelToken: cancelToken,
        options: _options,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData =
            (response.data is Map && response.data.containsKey('data'))
            ? response.data['data']
            : response.data;

        if (responseData is! Map) {
          throw const ParsingException(
            message: 'بنية استجابة إضافة المنتج غير صالحة',
          );
        }

        return await ProductModel.fromJsonAsync(
          Map<String, dynamic>.from(responseData),
        );
      }

      throw ServerException(
        message: 'فشل في إضافة المنتج إلى النظام',
        statusCode: response.statusCode,
      );
    } on DioException {
      rethrow;
    } catch (e) {
      if (e is AppException) rethrow;
      throw ParsingException(
        message: 'خطأ أثناء معالجة رد إضافة المنتج: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<ProductModel> updateProduct(
    String id,
    Map<String, dynamic> data, {
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.put(
        '${ApiConfig.adminProducts}/$id',
        data: data,
        cancelToken: cancelToken,
        options: _options,
      );

      if (response.statusCode == 200) {
        final responseData =
            (response.data is Map && response.data.containsKey('data'))
            ? response.data['data']
            : response.data;

        if (responseData is! Map) {
          throw const ParsingException(
            message: 'بنية استجابة تحديث المنتج غير صالحة',
          );
        }

        return await ProductModel.fromJsonAsync(
          Map<String, dynamic>.from(responseData),
        );
      }

      throw ServerException(
        message: 'فشل في تحديث بيانات المنتج',
        statusCode: response.statusCode,
      );
    } on DioException {
      rethrow;
    } catch (e) {
      if (e is AppException) rethrow;
      throw ParsingException(
        message: 'خطأ أثناء معالجة رد تحديث المنتج: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<bool> deleteProduct(String id, {CancelToken? cancelToken}) async {
    try {
      final response = await dio.delete(
        '${ApiConfig.adminProducts}/$id',
        cancelToken: cancelToken,
        options: _options,
      );
      return response.statusCode == 200 || response.statusCode == 204;
    } on DioException {
      rethrow;
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(message: 'فشل في حذف المنتج: $e');
    }
  }

  @override
  Future<String> uploadImage(
    String filePath, {
    CancelToken? cancelToken,
  }) async {
    if (!File(filePath).existsSync()) {
      throw const ParsingException(
        message: 'ملف الصورة المحدد غير موجود في الذاكرة',
      );
    }

    try {
      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          filePath,
          filename: filePath.split('/').last,
        ),
      });

      final response = await dio.post(
        ApiConfig.adminUploadProductImage,
        data: formData,
        cancelToken: cancelToken,
        options: Options(
          sendTimeout: _uploadTimeout,
          receiveTimeout: _uploadTimeout,
          headers: {'Accept': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        String? imageUrl =
            data['url']?.toString() ??
            data['data']?['url']?.toString() ??
            data['imageUrl']?.toString() ??
            data['path']?.toString();

        if (imageUrl != null && imageUrl.isNotEmpty) {
          if (!imageUrl.startsWith('http')) {
            imageUrl = '${ApiConfigController().baseUrl.value}/../$imageUrl';
          }
          return imageUrl.replaceAll('localhost:8000', 'localhost:8080');
        }
      }

      throw ServerException(
        message: 'فشل في استلام رابط الصورة المرفوعة من الخادم',
        statusCode: response.statusCode,
      );
    } on DioException {
      rethrow;
    } catch (e) {
      if (e is AppException) rethrow;
      throw ParsingException(
        message: 'خطأ أثناء رفع صورة المنتج: $e',
        originalError: e,
      );
    }
  }
}
