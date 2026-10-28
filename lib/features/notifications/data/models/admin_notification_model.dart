import 'package:flutter/foundation.dart';

/// Data Transfer Object (DTO) for administrative notifications.
/// Strictly decoupled from Domain entities.
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
      'id': id,
      'title': title,
      'body': body,
      'type': type,
      'target_type': targetType,
      if (userId != null) 'user_id': userId,
      if (userName != null || userEmail != null)
        'user': {
          if (userName != null) 'name': userName,
          if (userEmail != null) 'email': userEmail,
        },
      if (adminName != null)
        'admin': {
          'name': adminName,
        },
      if (imageUrl != null) 'image_url': imageUrl,
      if (data != null) 'data': data,
      'is_read': isRead,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdminNotificationModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          body == other.body &&
          type == other.type &&
          targetType == other.targetType &&
          userId == other.userId &&
          isRead == other.isRead;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      body.hashCode ^
      type.hashCode ^
      targetType.hashCode ^
      (userId?.hashCode ?? 0) ^
      isRead.hashCode;

  @override
  String toString() =>
      'AdminNotificationModel(id: $id, title: $title, type: $type, target: $targetType)';
}

/// DTO for the complete notification response including stats.
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

  const NotificationsResultModel.empty()
      : notifications = const [],
        totalCount = 0,
        todayCount = 0,
        broadcastCount = 0,
        targetedCount = 0;

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

  Map<String, dynamic> toJson() {
    return {
      'data': notifications.map((n) => n.toJson()).toList(),
      'stats': {
        'total': totalCount,
        'sent_today': todayCount,
        'broadcast': broadcastCount,
        'targeted': targetedCount,
      },
    };
  }

  static int _parseInt(dynamic value, {int fallback = 0}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationsResultModel &&
          runtimeType == other.runtimeType &&
          listEquals(notifications, other.notifications) &&
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
      'NotificationsResultModel(total: $totalCount, today: $todayCount, broadcast: $broadcastCount, count: ${notifications.length})';
}

/// Isolate compute function for parsing raw JSON notifications response.
NotificationsResultModel parseNotificationsResultCompute(dynamic rawJson) {
  try {
    if (rawJson is Map<String, dynamic>) {
      return NotificationsResultModel.fromJson(rawJson);
    } else if (rawJson is Map) {
      return NotificationsResultModel.fromJson(Map<String, dynamic>.from(rawJson));
    }
    return const NotificationsResultModel.empty();
  } catch (e) {
    debugPrint('parseNotificationsResultCompute fallback: $e');
    return const NotificationsResultModel.empty();
  }
}

/// Isolate compute function for parsing single notification response.
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
