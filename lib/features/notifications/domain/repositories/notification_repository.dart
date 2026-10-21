import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/admin_notification_entity.dart';
import '../entities/notifications_result_entity.dart';

abstract class NotificationRepository {
  Future<Either<Failure, NotificationsResultEntity>> getNotifications({
    String? search,
    String? type,
    int page = 1,
    CancelToken? cancelToken,
  });

  Future<Either<Failure, AdminNotificationEntity>> sendNotification(
    Map<String, dynamic> data, {
    CancelToken? cancelToken,
  });

  Future<Either<Failure, void>> deleteNotification(
    String id, {
    CancelToken? cancelToken,
  });
}
