import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:stronger_muscles_dashboard/config/api_config.dart';
import '../models/admin_notification_model.dart';

/// Contract for remote communication with the notifications backend endpoints via Dio.
abstract class NotificationRemoteDataSource {
  Future<NotificationsResultModel> getNotifications({
    String? search,
    String? type,
    int page = 1,
    CancelToken? cancelToken,
  });

  Future<AdminNotificationModel> sendNotification(
    Map<String, dynamic> data, {
    CancelToken? cancelToken,
  });

  Future<void> deleteNotification(
    String id, {
    CancelToken? cancelToken,
  });
}

/// Production implementation of [NotificationRemoteDataSource] using [Dio] and isolate computation.
class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final Dio _dio;

  NotificationRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<NotificationsResultModel> getNotifications({
    String? search,
    String? type,
    int page = 1,
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.get(
      ApiConfig.adminNotifications,
      queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
        if (type != null && type != 'all') 'type': type,
        'page': page,
      },
      cancelToken: cancelToken,
      options: Options(
        sendTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    return compute(parseNotificationsResultCompute, response.data);
  }

  @override
  Future<AdminNotificationModel> sendNotification(
    Map<String, dynamic> data, {
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.post(
      ApiConfig.adminNotifications,
      data: data,
      cancelToken: cancelToken,
      options: Options(
        sendTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    return compute(parseAdminNotificationCompute, response.data);
  }

  @override
  Future<void> deleteNotification(
    String id, {
    CancelToken? cancelToken,
  }) async {
    await _dio.delete(
      ApiConfig.adminNotificationDetail(id),
      cancelToken: cancelToken,
      options: Options(
        sendTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
  }
}
