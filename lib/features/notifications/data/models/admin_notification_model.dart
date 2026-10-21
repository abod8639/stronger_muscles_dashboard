import 'package:flutter/foundation.dart';
import '../../domain/entities/admin_notification_entity.dart';
import '../../domain/entities/notifications_result_entity.dart';

class AdminNotificationModel {
  final String id;
  final String title;
  final String body;
  final String type;
  final String targetType;
  final String? userId;
  final String? userName;
  final String? userEmail;
  final String? adminName;
  final String? imageUrl;
  final Map<String, dynamic>? data;
  final bool isRead;
  final DateTime? createdAt;

  const AdminNotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.targetType,
    this.userId,
    this.userName,
    this.userEmail,
    this.adminName,
    this.imageUrl,
    this.data,
    this.isRead = false,
    this.createdAt,
  });

  factory AdminNotificationModel.fromJson(Map<String, dynamic> json) {
    String? userName;
    String? userEmail;
    if (json['user'] is Map) {
      final userMap = json['user'] as Map;
      userName = userMap['name']?.toString();
      userEmail = userMap['email']?.toString();
    }

    String? adminName;
    if (json['admin'] is Map) {
      final adminMap = json['admin'] as Map;
      adminName = adminMap['name']?.toString();
    }

    Map<String, dynamic>? dataMap;
    if (json['data'] is Map) {
      try {
        dataMap = Map<String, dynamic>.from(json['data'] as Map);
      } catch (_) {
        dataMap = null;
      }
    }

    DateTime? parsedDate;
    if (json['created_at'] != null) {
      parsedDate = DateTime.tryParse(json['created_at'].toString());
    }

    return AdminNotificationModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      type: json['type']?.toString() ?? 'general',
      targetType: json['target_type']?.toString() ?? 'all',
      userId: json['user_id']?.toString(),
      userName: userName,
      userEmail: userEmail,
      adminName: adminName,
      imageUrl: json['image_url']?.toString(),
      data: dataMap,
      isRead: json['is_read'] == true || json['is_read'] == 1 || json['is_read'] == '1',
      createdAt: parsedDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'type': type,
      'target_type': targetType,
      if (userId != null) 'user_id': userId,
      if (imageUrl != null) 'image_url': imageUrl,
      if (data != null) 'data': data,
    };
  }

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

class NotificationsResultModel {
  final List<AdminNotificationModel> notifications;
  final int totalCount;
  final int todayCount;
  final int broadcastCount;
  final int targetedCount;

  const NotificationsResultModel({
    required this.notifications,
    required this.totalCount,
    required this.todayCount,
    required this.broadcastCount,
    required this.targetedCount,
  });

  factory NotificationsResultModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> items = json['data'] is List ? (json['data'] as List) : [];
    final notifications = items
        .whereType<Map>()
        .map((e) => AdminNotificationModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    final stats = json['stats'] is Map ? (json['stats'] as Map) : const {};

    return NotificationsResultModel(
      notifications: notifications,
      totalCount: _parseInt(stats['total'], fallback: notifications.length),
      todayCount: _parseInt(stats['sent_today']),
      broadcastCount: _parseInt(stats['broadcast']),
      targetedCount: _parseInt(stats['targeted']),
    );
  }

  static int _parseInt(dynamic value, {int fallback = 0}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }

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

/// دالة Isolate لتحليل مصفوفة الإشعارات والإحصائيات في الخلفية
NotificationsResultModel parseNotificationsResultCompute(dynamic rawJson) {
  try {
    if (rawJson is Map<String, dynamic>) {
      return NotificationsResultModel.fromJson(rawJson);
    } else if (rawJson is Map) {
      return NotificationsResultModel.fromJson(Map<String, dynamic>.from(rawJson));
    }
    return const NotificationsResultModel(
      notifications: [],
      totalCount: 0,
      todayCount: 0,
      broadcastCount: 0,
      targetedCount: 0,
    );
  } catch (e) {
    debugPrint('parseNotificationsResultCompute fallback: $e');
    return const NotificationsResultModel(
      notifications: [],
      totalCount: 0,
      todayCount: 0,
      broadcastCount: 0,
      targetedCount: 0,
    );
  }
}

/// دالة Isolate لتحليل كائن الإشعار الواحد عند الإنشاء
AdminNotificationModel parseAdminNotificationCompute(dynamic rawJson) {
  try {
    if (rawJson is Map<String, dynamic>) {
      final data = rawJson['data'] is Map ? (rawJson['data'] as Map) : rawJson;
      return AdminNotificationModel.fromJson(Map<String, dynamic>.from(data));
    } else if (rawJson is Map) {
      final data = rawJson['data'] is Map ? (rawJson['data'] as Map) : rawJson;
      return AdminNotificationModel.fromJson(Map<String, dynamic>.from(data));
    }
    return const AdminNotificationModel(
      id: '',
      title: '',
      body: '',
      type: 'general',
      targetType: 'all',
    );
  } catch (e) {
    debugPrint('parseAdminNotificationCompute fallback: $e');
    return const AdminNotificationModel(
      id: '',
      title: '',
      body: '',
      type: 'general',
      targetType: 'all',
    );
  }
}
