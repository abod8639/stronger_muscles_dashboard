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
}
