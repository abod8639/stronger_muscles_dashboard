import '../entities/admin_notification_entity.dart';

abstract class NotificationRepository {
  Future<Map<String, dynamic>> getNotifications({String? search, String? type, int page = 1});
  Future<AdminNotificationEntity> sendNotification(Map<String, dynamic> data);
  Future<void> deleteNotification(String id);
}
