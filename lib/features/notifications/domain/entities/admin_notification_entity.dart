/// Pure Dart Domain Entity representing an administrative notification.
/// Free of any Flutter UI dependencies or 3rd-party networking/storage libraries.
class AdminNotificationEntity {
  final String id;
  final String title;
  final String body;
  final String type; // general, promo, order, system
  final String targetType; // all, user
  final String? userId;
  final String? userName;
  final String? userEmail;
  final String? adminName;
  final String? imageUrl;
  final Map<String, dynamic>? data;
  final bool isRead;
  final DateTime? createdAt;

  const AdminNotificationEntity({
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

  factory AdminNotificationEntity.initial() => const AdminNotificationEntity(
        id: '',
        title: '',
        body: '',
        type: 'general',
        targetType: 'all',
      );

  AdminNotificationEntity copyWith({
    String? id,
    String? title,
    String? body,
    String? type,
    String? targetType,
    String? userId,
    String? userName,
    String? userEmail,
    String? adminName,
    String? imageUrl,
    Map<String, dynamic>? data,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return AdminNotificationEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      targetType: targetType ?? this.targetType,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      adminName: adminName ?? this.adminName,
      imageUrl: imageUrl ?? this.imageUrl,
      data: data ?? this.data,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String get typeLabel {
    switch (type) {
      case 'promo':
        return 'إعلان / عرض';
      case 'order':
        return 'حالة طلب';
      case 'system':
        return 'نظام / أمان';
      default:
        return 'عام';
    }
  }

  String get targetLabel {
    if (targetType == 'all') {
      return 'جميع المستخدمين';
    }
    return userName != null ? 'المستخدم: $userName' : 'مستخدم محدد (#$userId)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdminNotificationEntity &&
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
      'AdminNotificationEntity(id: $id, title: $title, type: $type, target: $targetType)';
}
