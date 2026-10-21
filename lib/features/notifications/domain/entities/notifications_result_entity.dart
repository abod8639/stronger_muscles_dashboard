import 'admin_notification_entity.dart';

class NotificationsResultEntity {
  final List<AdminNotificationEntity> notifications;
  final int totalCount;
  final int todayCount;
  final int broadcastCount;
  final int targetedCount;

  const NotificationsResultEntity({
    required this.notifications,
    required this.totalCount,
    required this.todayCount,
    required this.broadcastCount,
    required this.targetedCount,
  });

  factory NotificationsResultEntity.initial() => const NotificationsResultEntity(
        notifications: [],
        totalCount: 0,
        todayCount: 0,
        broadcastCount: 0,
        targetedCount: 0,
      );

  NotificationsResultEntity copyWith({
    List<AdminNotificationEntity>? notifications,
    int? totalCount,
    int? todayCount,
    int? broadcastCount,
    int? targetedCount,
  }) {
    return NotificationsResultEntity(
      notifications: notifications ?? this.notifications,
      totalCount: totalCount ?? this.totalCount,
      todayCount: todayCount ?? this.todayCount,
      broadcastCount: broadcastCount ?? this.broadcastCount,
      targetedCount: targetedCount ?? this.targetedCount,
    );
  }
}
