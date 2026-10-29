import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/admin_notification_entity.dart';
import '../entities/notifications_result_entity.dart';
import '../repositories/notification_repository.dart';

/// Pure Dart UseCase for retrieving notifications list and analytics.
class GetNotificationsUseCase {
  final NotificationRepository repository;

  const GetNotificationsUseCase(this.repository);

  Future<Either<Failure, NotificationsResultEntity>> call({
    String? search,
    String? type,
    int page = 1,
    bool forceRefresh = false,
  }) {
    return repository.getNotifications(
      search: search,
      type: type,
      page: page,
      forceRefresh: forceRefresh,
    );
  }
}

/// Pure Dart UseCase for dispatching a notification.
class SendNotificationUseCase {
  final NotificationRepository repository;

  const SendNotificationUseCase(this.repository);

  Future<Either<Failure, AdminNotificationEntity>> call(
    Map<String, dynamic> data,
  ) {
    return repository.sendNotification(data);
  }
}

/// Pure Dart UseCase for deleting an administrative notification.
class DeleteNotificationUseCase {
  final NotificationRepository repository;

  const DeleteNotificationUseCase(this.repository);

  Future<Either<Failure, void>> call(String id) {
    return repository.deleteNotification(id);
  }
}
