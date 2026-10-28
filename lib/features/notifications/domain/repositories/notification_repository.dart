import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/admin_notification_entity.dart';
import '../entities/notifications_result_entity.dart';

/// Pure Dart Domain Contract for Notifications repository.
/// 100% decoupled from Dio, Hive, or Flutter UI frameworks.
abstract class NotificationRepository {
  /// Fetches paginated or filtered notifications with optional force refresh.
  Future<Either<Failure, NotificationsResultEntity>> getNotifications({
    String? search,
    String? type,
    int page = 1,
    bool forceRefresh = false,
  });

  /// Sends a new administrative notification (broadcast or targeted).
  Future<Either<Failure, AdminNotificationEntity>> sendNotification(
    Map<String, dynamic> data,
  );

  /// Deletes a notification by its unique identifier.
  Future<Either<Failure, void>> deleteNotification(
    String id,
  );
}
