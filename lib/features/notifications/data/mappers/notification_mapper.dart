import '../../domain/entities/admin_notification_entity.dart';
import '../../domain/entities/notifications_result_entity.dart';
import '../models/admin_notification_model.dart';

/// Extension mapper converting [AdminNotificationModel] DTO to domain [AdminNotificationEntity].
extension AdminNotificationModelMapper on AdminNotificationModel {
  AdminNotificationEntity toEntity() {
    return AdminNotificationEntity(
      id: id,
      title: title,
      body: body,
      type: type,
      targetType: targetType,
      userId: userId,
      userName: userName,
      userEmail: userEmail,
      adminName: adminName,
      imageUrl: imageUrl,
      data: data,
      isRead: isRead,
      createdAt: createdAt,
    );
  }
}

/// Extension mapper converting domain [AdminNotificationEntity] to [AdminNotificationModel] DTO.
extension AdminNotificationEntityMapper on AdminNotificationEntity {
  AdminNotificationModel toModel() {
    return AdminNotificationModel(
      id: id,
      title: title,
      body: body,
      type: type,
      targetType: targetType,
      userId: userId,
      userName: userName,
      userEmail: userEmail,
      adminName: adminName,
      imageUrl: imageUrl,
      data: data,
      isRead: isRead,
      createdAt: createdAt,
    );
  }
}

/// Extension mapper converting [NotificationsResultModel] DTO to domain [NotificationsResultEntity].
extension NotificationsResultModelMapper on NotificationsResultModel {
  NotificationsResultEntity toEntity() {
    return NotificationsResultEntity(
      notifications: notifications.map((m) => m.toEntity()).toList(),
      totalCount: totalCount,
      todayCount: todayCount,
      broadcastCount: broadcastCount,
      targetedCount: targetedCount,
    );
  }
}

/// Extension mapper converting domain [NotificationsResultEntity] to [NotificationsResultModel] DTO.
extension NotificationsResultEntityMapper on NotificationsResultEntity {
  NotificationsResultModel toModel() {
    return NotificationsResultModel(
      notifications: notifications.map((e) => e.toModel()).toList(),
      totalCount: totalCount,
      todayCount: todayCount,
      broadcastCount: broadcastCount,
      targetedCount: targetedCount,
    );
  }
}
