import 'package:dio/dio.dart';
import 'package:stronger_muscles_dashboard/config/api_config.dart';
import '../models/admin_notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<Map<String, dynamic>> getNotifications({String? search, String? type, int page = 1});
  Future<AdminNotificationModel> sendNotification(Map<String, dynamic> data);
  Future<void> deleteNotification(String id);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final Dio dio;

  NotificationRemoteDataSourceImpl({required this.dio});

  @override
  Future<Map<String, dynamic>> getNotifications({String? search, String? type, int page = 1}) async {
    try {
      final response = await dio.get(
        ApiConfig.adminNotifications,
        queryParameters: {
          if (search != null && search.isNotEmpty) 'search': search,
          if (type != null && type != 'all') 'type': type,
          'page': page,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final List<dynamic> items = data['data'] ?? [];
        final notifications = items.map((json) => AdminNotificationModel.fromJson(json)).toList();
        final stats = data['stats'] is Map ? Map<String, dynamic>.from(data['stats']) : <String, dynamic>{};
        return {
          'notifications': notifications,
          'stats': stats,
        };
      } else {
        throw Exception('فشل في جلب الإشعارات');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<AdminNotificationModel> sendNotification(Map<String, dynamic> data) async {
    try {
      final response = await dio.post(ApiConfig.adminNotifications, data: data);
      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = response.data['data'] ?? response.data;
        return AdminNotificationModel.fromJson(responseData);
      } else {
        throw Exception('فشل في إرسال الإشعار');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> deleteNotification(String id) async {
    try {
      final response = await dio.delete(ApiConfig.adminNotificationDetail(id));
      if (response.statusCode != 200) {
        throw Exception('فشل في حذف الإشعار');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
