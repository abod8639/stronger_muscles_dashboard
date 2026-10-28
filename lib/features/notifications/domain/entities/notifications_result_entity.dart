import 'admin_notification_entity.dart';

/// Pure Dart Domain Entity representing the aggregated notification list and stats.
/// 100% pure Dart - zero imports from Flutter or external packages.
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

  const NotificationsResultEntity.initial()
      : notifications = const [],
        totalCount = 0,
        todayCount = 0,
        broadcastCount = 0,
        targetedCount = 0;

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

  static bool _listEquals(List<AdminNotificationEntity> a, List<AdminNotificationEntity> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationsResultEntity &&
          runtimeType == other.runtimeType &&
          _listEquals(notifications, other.notifications) &&
          totalCount == other.totalCount &&
          todayCount == other.todayCount &&
          broadcastCount == other.broadcastCount &&
          targetedCount == other.targetedCount;

  @override
  int get hashCode =>
      notifications.hashCode ^
      totalCount.hashCode ^
      todayCount.hashCode ^
      broadcastCount.hashCode ^
      targetedCount.hashCode;

  @override
  String toString() =>
      'NotificationsResultEntity(total: $totalCount, today: $todayCount, broadcast: $broadcastCount, targeted: $targetedCount, count: ${notifications.length})';
}
