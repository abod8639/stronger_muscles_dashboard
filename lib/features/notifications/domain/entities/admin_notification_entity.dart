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
    switch (type.toLowerCase()) {
      case 'promo':
        return 'إعلان / عرض';
      case 'order':
        return 'حالة طلب';
      case 'system':
        return 'نظام / أمان';
      case 'support':
      case 'support_ticket':
      case 'ticket':
        return 'دعم فني';
      default:
        return 'عام';
    }
  }

  /// Determines whether this notification refers to a support ticket.
  bool get isTicket {
    final t = type.toLowerCase();
    if (t == 'support' || t == 'ticket' || t == 'support_ticket') {
      return true;
    }
    if (data != null) {
      final dt = data!['type']?.toString().toLowerCase();
      if (dt == 'support' || dt == 'ticket' || dt == 'support_ticket') {
        return true;
      }
      if (data!['ticket_id'] != null || data!['ticketId'] != null) {
        return true;
      }
    }
    if (RegExp(r'(?:تذكرة|ticket)\s*#?\d+', caseSensitive: false)
        .hasMatch('$title $body')) {
      return true;
    }
    return false;
  }

  /// Extracts the ticket ID if available from notification payload data or text.
  int? get ticketId {
    if (data != null) {
      final raw = data!['ticket_id'] ?? data!['ticketId'];
      if (raw is int) return raw;
      if (raw is String) return int.tryParse(raw);
      if (isTicket && data!['id'] != null) {
        final rawId = data!['id'];
        if (rawId is int) return rawId;
        if (rawId is String) return int.tryParse(rawId);
      }
    }
    final match = RegExp(
      r'(?:تذكرة|ticket)?\s*#(\d+)',
      caseSensitive: false,
    ).firstMatch('$title $body');
    if (match != null) {
      final parsed = int.tryParse(match.group(1)!);
      if (parsed != null) return parsed;
    }
    return null;
  }

  /// Determines whether this notification refers to an order.
  bool get isOrder {
    final t = type.toLowerCase();
    if (t == 'order') return true;
    if (data != null) {
      final dt = data!['type']?.toString().toLowerCase();
      if (dt == 'order') return true;
      if (data!['order_id'] != null || data!['orderId'] != null) return true;
    }
    return false;
  }

  /// Extracts the order ID if available from notification payload data.
  int? get orderId {
    if (data != null) {
      final raw = data!['order_id'] ?? data!['orderId'];
      if (raw is int) return raw;
      if (raw is String) return int.tryParse(raw);
    }
    return null;
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
