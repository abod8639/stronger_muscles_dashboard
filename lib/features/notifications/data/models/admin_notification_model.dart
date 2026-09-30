import '../../domain/entities/admin_notification_entity.dart';

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

  AdminNotificationModel({
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
      userName = json['user']['name']?.toString();
      userEmail = json['user']['email']?.toString();
    }

    String? adminName;
    if (json['admin'] is Map) {
      adminName = json['admin']['name']?.toString();
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
      data: json['data'] is Map ? Map<String, dynamic>.from(json['data']) : null,
      isRead: json['is_read'] == true || json['is_read'] == 1,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
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
