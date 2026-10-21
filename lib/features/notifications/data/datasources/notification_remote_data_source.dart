import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:stronger_muscles_dashboard/config/api_config.dart';
import '../models/admin_notification_model.dart';

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

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final Dio dio;

  NotificationRemoteDataSourceImpl({required this.dio});

  @override
  Future<NotificationsResultModel> getNotifications({
    String? search,
    String? type,
    int page = 1,
    CancelToken? cancelToken,
  }) async {
    final response = await dio.get(
      ApiConfig.adminNotifications,
      queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
        if (type != null && type != 'all') 'type': type,
        'page': page,
      },
      cancelToken: cancelToken,
      options: Options(
        sendTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );

    // تحليل الاستجابة بالكامل في مسار Isolate خلفي لمنع أي تجميد للواجهة
    final result = await compute(parseNotificationsResultCompute, response.data);
    return result;
  }

  @override
  Future<AdminNotificationModel> sendNotification(
    Map<String, dynamic> data, {
    CancelToken? cancelToken,
  }) async {
    final response = await dio.post(
      ApiConfig.adminNotifications,
      data: data,
      cancelToken: cancelToken,
      options: Options(
        sendTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );

    final notification = await compute(parseAdminNotificationCompute, response.data);
    return notification;
  }

  @override
  Future<void> deleteNotification(
    String id, {
    CancelToken? cancelToken,
  }) async {
    await dio.delete(
      ApiConfig.adminNotificationDetail(id),
      cancelToken: cancelToken,
      options: Options(
        sendTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );
  }
}
