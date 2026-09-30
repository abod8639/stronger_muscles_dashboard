import '../../domain/entities/admin_notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_data_source.dart';
import '../models/admin_notification_model.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Map<String, dynamic>> getNotifications({String? search, String? type, int page = 1}) async {
    final result = await remoteDataSource.getNotifications(search: search, type: type, page: page);
    final List<AdminNotificationModel> models = result['notifications'] ?? [];
    final entities = models.map((m) => m.toEntity()).toList();
    return {
      'notifications': entities,
      'stats': result['stats'],
    };
  }

  @override
  Future<AdminNotificationEntity> sendNotification(Map<String, dynamic> data) async {
    final model = await remoteDataSource.sendNotification(data);
    return model.toEntity();
  }

  @override
  Future<void> deleteNotification(String id) async {
    await remoteDataSource.deleteNotification(id);
  }
}
