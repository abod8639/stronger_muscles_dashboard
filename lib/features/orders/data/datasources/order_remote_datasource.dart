import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/config/api_config.dart';
import 'package:stronger_muscles_dashboard/core/error/exceptions.dart';
import '../models/order_model.dart';
import '../../domain/entities/order_entity.dart';

abstract class OrderRemoteDataSource {
  Future<List<OrderModel>> getOrders({CancelToken? cancelToken});
  Future<OrderModel> getOrderById(String id, {CancelToken? cancelToken});
  Future<OrderModel> updateOrderStatus(
    String id,
    OrderStatus status, {
    CancelToken? cancelToken,
  });
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final Dio dio;

  static const Duration _defaultTimeout = Duration(seconds: 30);

  OrderRemoteDataSourceImpl(this.dio);

  Options get _options => Options(
        sendTimeout: _defaultTimeout,
        receiveTimeout: _defaultTimeout,
        headers: {'Accept': 'application/json'},
      );

  @override
  Future<List<OrderModel>> getOrders({CancelToken? cancelToken}) async {
    try {
      final response = await dio.get(
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

        // عزل معالجة وتحليل القائمة الكبيرة في مسار معالجة خلفي (Isolate عبر compute) لمنع تجميد الواجهة
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
      final response = await dio.get(
        '${ApiConfig.adminOrders}/$id',
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
      final response = await dio.patch(
        '${ApiConfig.adminOrders}/$id/status',
        data: {'status': status.name},
        cancelToken: cancelToken,
        options: _options,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = (response.data is Map && response.data.containsKey('data'))
            ? response.data['data']
            : response.data;

        if (data is! Map) {
          throw const ParsingException(message: 'بنية استجابة تحديث الطلب غير صالحة');
        }

        return await OrderModel.fromJsonAsync(Map<String, dynamic>.from(data));
      }

      throw ServerException(
        message: 'فشل في تحديث حالة الطلب إلى "${status.name}"',
        statusCode: response.statusCode,
      );
    } on DioException {
      rethrow;
    } catch (e) {
      if (e is AppException) rethrow;
      throw ParsingException(
        message: 'خطأ أثناء معالجة رد تحديث الطلب: $e',
        originalError: e,
      );
    }
  }
}
