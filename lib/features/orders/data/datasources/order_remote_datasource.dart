import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/config/api_config.dart';
import 'package:stronger_muscles_dashboard/core/error/exceptions.dart';
import '../../domain/entities/order_entity.dart';
import '../models/order_model.dart';

/// Contract for remote communication with orders endpoints via Dio.
abstract class OrderRemoteDataSource {
  Future<List<OrderModel>> getOrders({CancelToken? cancelToken});
  Future<OrderModel> getOrderById(String id, {CancelToken? cancelToken});
  Future<OrderModel> updateOrderStatus(
    String id,
    OrderStatus status, {
    CancelToken? cancelToken,
  });
}

/// Production implementation of [OrderRemoteDataSource] using [Dio] and Isolate computation.
class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final Dio _dio;

  static const Duration _defaultTimeout = Duration(seconds: 30);

  OrderRemoteDataSourceImpl(Dio dio) : _dio = dio;

  Options get _options => Options(
        sendTimeout: _defaultTimeout,
        receiveTimeout: _defaultTimeout,
        headers: {'Accept': 'application/json'},
      );

  @override
  Future<List<OrderModel>> getOrders({CancelToken? cancelToken}) async {
    try {
      final response = await _dio.get(
        ApiConfig.adminOrders,
        cancelToken: cancelToken,
        options: _options,
      );

      if (response.statusCode == 200) {
        dynamic data;
        final rawData = response.data;
        if (rawData is Map && rawData.containsKey('data')) {
          final innerData = rawData['data'];
          if (innerData is Map && innerData.containsKey('data')) {
            data = innerData['data'];
          } else {
            data = innerData;
          }
        } else {
          data = rawData;
        }

        if (data is! List) {
          return const [];
        }

        // Process heavy payload parsing in background isolate
        return await OrderModel.fromJsonListAsync(data);
      }

      throw ServerException(
        message: 'فشل في استلام قائمة الطلبات من الخادم (كود: ${response.statusCode})',
        statusCode: response.statusCode,
      );
    } on DioException {
      rethrow;
    } catch (e) {
      if (e is AppException) rethrow;
      throw ParsingException(
        message: 'خطأ أثناء تحليل بيانات الطلبات: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<OrderModel> getOrderById(String id, {CancelToken? cancelToken}) async {
    try {
      final response = await _dio.get(
        ApiConfig.adminOrderDetail(id),
        cancelToken: cancelToken,
        options: _options,
      );

      if (response.statusCode == 200) {
        final data = (response.data is Map && response.data.containsKey('data'))
            ? response.data['data']
            : response.data;

        if (data is! Map) {
          throw const ParsingException(message: 'بنية استجابة الطلب غير صالحة');
        }

        return await OrderModel.fromJsonAsync(Map<String, dynamic>.from(data));
      }

      throw ServerException(
        message: 'فشل في تحميل تفاصيل الطلب رقم: $id',
        statusCode: response.statusCode,
      );
    } on DioException {
      rethrow;
    } catch (e) {
      if (e is AppException) rethrow;
      throw ParsingException(
        message: 'خطأ أثناء تحليل تفاصيل الطلب: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<OrderModel> updateOrderStatus(
    String id,
    OrderStatus status, {
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.put(
        ApiConfig.adminOrderDetail(id),
        data: {'status': status.name},
        cancelToken: cancelToken,
        options: _options,
      );

      if (response.statusCode == 200) {
        final data = (response.data is Map && response.data.containsKey('data'))
            ? response.data['data']
            : response.data;

        if (data is! Map) {
          throw const ParsingException(message: 'استجابة تعديل حالة الطلب غير صالحة');
        }

        return await OrderModel.fromJsonAsync(Map<String, dynamic>.from(data));
      }

      throw ServerException(
        message: 'فشل في تعديل حالة الطلب رقم: $id',
        statusCode: response.statusCode,
      );
    } on DioException {
      rethrow;
    } catch (e) {
      if (e is AppException) rethrow;
      throw ParsingException(
        message: 'خطأ أثناء تحليل بيانات الطلب المحدث: $e',
        originalError: e,
      );
    }
  }
}
