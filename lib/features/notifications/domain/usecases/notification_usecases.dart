import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/admin_notification_entity.dart';
import '../entities/notifications_result_entity.dart';
import '../repositories/notification_repository.dart';

class GetNotificationsUseCase {
  final NotificationRepository repository;

  GetNotificationsUseCase(this.repository);

  Future<Either<Failure, NotificationsResultEntity>> call({
    String? search,
    String? type,
    int page = 1,
    CancelToken? cancelToken,
  }) {
    return repository.getNotifications(
      search: search,
      type: type,
      page: page,
      cancelToken: cancelToken,
    );
  }
}

class SendNotificationUseCase {
  final NotificationRepository repository;

  SendNotificationUseCase(this.repository);

  Future<Either<Failure, AdminNotificationEntity>> call(
    Map<String, dynamic> data, {
    CancelToken? cancelToken,
  }) {
    return repository.sendNotification(data, cancelToken: cancelToken);
  }
}

class DeleteNotificationUseCase {
  final NotificationRepository repository;

  DeleteNotificationUseCase(this.repository);

  Future<Either<Failure, void>> call(
    String id, {
    CancelToken? cancelToken,
  }) {
    return repository.deleteNotification(id, cancelToken: cancelToken);
  }
}
