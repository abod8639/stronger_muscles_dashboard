import '../entities/admin_notification_entity.dart';
import '../repositories/notification_repository.dart';

class GetNotificationsUseCase {
  final NotificationRepository repository;

  GetNotificationsUseCase(this.repository);

  Future<Map<String, dynamic>> call({String? search, String? type, int page = 1}) {
    return repository.getNotifications(search: search, type: type, page: page);
  }
}

class SendNotificationUseCase {
  final NotificationRepository repository;

  SendNotificationUseCase(this.repository);

  Future<AdminNotificationEntity> call(Map<String, dynamic> data) {
    return repository.sendNotification(data);
  }
}

class DeleteNotificationUseCase {
  final NotificationRepository repository;

  DeleteNotificationUseCase(this.repository);

  Future<void> call(String id) {
    return repository.deleteNotification(id);
  }
}
