import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/core/config/api_config.dart';
import 'package:stronger_muscles_dashboard/core/error/exceptions.dart';
import '../models/brand_model.dart';

/// Contract for executing remote brand API calls.
abstract class BrandRemoteDataSource {
  Future<List<BrandModel>> getBrands();
  Future<BrandModel> getBrandById(String id);
}

/// Production implementation of [BrandRemoteDataSource] using [Dio].
/// 100% testable via Constructor Dependency Injection.
class BrandRemoteDataSourceImpl implements BrandRemoteDataSource {
  final Dio _dio;
  static const Duration _defaultTimeout = Duration(seconds: 35);

  const BrandRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<List<BrandModel>> getBrands() async {
    try {
      final response = await _dio.get(
        ApiConfig.adminBrands,
        options: Options(
          sendTimeout: _defaultTimeout,
          receiveTimeout: _defaultTimeout,
          headers: {'Accept': 'application/json'},
        ),
      );

      final data = response.data;
      dynamic rawList;

      if (data is Map && data.containsKey('data')) {
        rawList = data['data'];
      } else if (data is List) {
        rawList = data;
      } else {
        rawList = [];
      }

      if (rawList is List) {
        return rawList
            .map((item) =>
                BrandModel.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();
      }

      return [];
    } on DioException {
      rethrow;
    } on AppException {
      rethrow;
    } catch (e) {
      throw ParsingException(
        message: 'خطأ أثناء تحليل بيانات العلامات التجارية: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<BrandModel> getBrandById(String id) async {
    try {
      final response = await _dio.get(
        '${ApiConfig.adminBrands}/$id',
        options: Options(
          sendTimeout: _defaultTimeout,
          receiveTimeout: _defaultTimeout,
          headers: {'Accept': 'application/json'},
        ),
      );

      final data = response.data;
      if (response.statusCode == 200 && data is Map<String, dynamic>) {
        final payload = data.containsKey('data') && data['data'] is Map
            ? Map<String, dynamic>.from(data['data'] as Map)
            : data;
        return BrandModel.fromJson(payload);
      }

      throw ServerException(
        message: data is Map
            ? (data['message']?.toString() ?? 'تعذر العثور على العلامة التجارية')
            : 'تعذر العثور على العلامة التجارية',
        statusCode: response.statusCode,
      );
    } on DioException {
      rethrow;
    } on AppException {
      rethrow;
    } catch (e) {
      throw ParsingException(
        message: 'خطأ أثناء تحليل بيانات العلامة التجارية: $e',
        originalError: e,
      );
    }
  }
}
