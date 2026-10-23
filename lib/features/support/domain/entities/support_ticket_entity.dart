import 'support_message_entity.dart';

class SupportTicketEntity {
  final int id;
  final String ticketNumber;
  final int? userId;
  final String userName;
  final String userEmail;
  final String? userPhone;
  final String? userAvatar;
  final String subject;
  final String category;
  final String priority; // 'low', 'normal', 'high', 'urgent'
  final String status; // 'open', 'in_progress', 'waiting_user', 'resolved', 'closed'
  final int? orderId;
  final String? orderNumber;
  final double? orderTotal;
  final int? adminId;
  final String? adminName;
  final String? adminRole;
  final int messagesCount;
  final int unreadMessagesCount;
  final SupportMessageEntity? latestMessage;
  final List<SupportMessageEntity> messages;
  final DateTime? lastReplyAt;
  final DateTime? resolvedAt;
  final DateTime? closedAt;
  final DateTime createdAt;

  const SupportTicketEntity({
    required this.id,
    required this.ticketNumber,
    this.userId,
    required this.userName,
    required this.userEmail,
    this.userPhone,
    this.userAvatar,
    required this.subject,
    required this.category,
    this.priority = 'normal',
    this.status = 'open',
    this.orderId,
    this.orderNumber,
    this.orderTotal,
    this.adminId,
    this.adminName,
    this.adminRole,
    this.messagesCount = 0,
    this.unreadMessagesCount = 0,
    this.latestMessage,
    this.messages = const [],
    this.lastReplyAt,
    this.resolvedAt,
    this.closedAt,
    required this.createdAt,
  });

  factory SupportTicketEntity.fromJson(Map<String, dynamic> json) {
    String userName = json['name']?.toString() ?? 'عميل';
    String userEmail = json['email']?.toString() ?? '';
    String? userPhone = json['phone']?.toString();
    String? userAvatar;

    if (json['user'] is Map) {
      final userMap = json['user'] as Map;
      userName = userMap['name']?.toString() ?? userName;
      userEmail = userMap['email']?.toString() ?? userEmail;
      userPhone = userMap['phone_number']?.toString() ?? userPhone;
      userAvatar = userMap['photo_url']?.toString();
    }

    String? adminName;
    String? adminRole;
    if (json['assigned_admin'] is Map) {
      final adminMap = json['assigned_admin'] as Map;
      adminName = adminMap['name']?.toString();
      adminRole = adminMap['role']?.toString();
    }

    String? orderNumber;
    double? orderTotal;
    if (json['order'] is Map) {
      final orderMap = json['order'] as Map;
      orderNumber = orderMap['order_number']?.toString();
      if (orderMap['total_amount'] != null) {
        orderTotal = (orderMap['total_amount'] as num).toDouble();
      }
    }

    SupportMessageEntity? latestMsg;
    if (json['latest_message'] is Map) {
      latestMsg = SupportMessageEntity.fromJson(
        Map<String, dynamic>.from(json['latest_message']),
      );
    }

    List<SupportMessageEntity> msgs = [];
    if (json['messages'] is List) {
      msgs = (json['messages'] as List)
          .whereType<Map>()
          .map((m) => SupportMessageEntity.fromJson(Map<String, dynamic>.from(m)))
          .toList();
    }

    return SupportTicketEntity(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      ticketNumber: json['ticket_number']?.toString() ?? 'SM-${json['id']}',
      userId: json['user_id'] is int
          ? json['user_id'] as int
          : int.tryParse(json['user_id']?.toString() ?? ''),
      userName: userName,
      userEmail: userEmail,
      userPhone: userPhone,
      userAvatar: userAvatar,
      subject: json['subject']?.toString() ?? '',
      category: json['category']?.toString() ?? 'general',
      priority: json['priority']?.toString() ?? 'normal',
      status: json['status']?.toString() ?? 'open',
      orderId: json['order_id'] is int
          ? json['order_id'] as int
          : int.tryParse(json['order_id']?.toString() ?? ''),
      orderNumber: orderNumber,
      orderTotal: orderTotal,
      adminId: json['admin_id'] is int
          ? json['admin_id'] as int
          : int.tryParse(json['admin_id']?.toString() ?? ''),
      adminName: adminName,
      adminRole: adminRole,
      messagesCount: json['messages_count'] is int
          ? json['messages_count'] as int
          : msgs.length,
      unreadMessagesCount: json['unread_messages_count'] is int
          ? json['unread_messages_count'] as int
          : 0,
      latestMessage: latestMsg,
      messages: msgs,
      lastReplyAt: json['last_reply_at'] != null ? DateTime.tryParse(json['last_reply_at'].toString()) : null,
      resolvedAt: json['resolved_at'] != null ? DateTime.tryParse(json['resolved_at'].toString()) : null,
      closedAt: json['closed_at'] != null ? DateTime.tryParse(json['closed_at'].toString()) : null,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now() : DateTime.now(),
    );
  }

  SupportTicketEntity copyWith({
    int? id,
    String? ticketNumber,
    int? userId,
    String? userName,
    String? userEmail,
    String? userPhone,
    String? userAvatar,
    String? subject,
    String? category,
    String? priority,
    String? status,
    int? orderId,
    String? orderNumber,
    double? orderTotal,
    int? adminId,
    String? adminName,
    String? adminRole,
    int? messagesCount,
    int? unreadMessagesCount,
    SupportMessageEntity? latestMessage,
    List<SupportMessageEntity>? messages,
    DateTime? lastReplyAt,
    DateTime? resolvedAt,
    DateTime? closedAt,
    DateTime? createdAt,
  }) {
    return SupportTicketEntity(
      id: id ?? this.id,
      ticketNumber: ticketNumber ?? this.ticketNumber,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      userPhone: userPhone ?? this.userPhone,
      userAvatar: userAvatar ?? this.userAvatar,
      subject: subject ?? this.subject,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      orderId: orderId ?? this.orderId,
      orderNumber: orderNumber ?? this.orderNumber,
      orderTotal: orderTotal ?? this.orderTotal,
      adminId: adminId ?? this.adminId,
      adminName: adminName ?? this.adminName,
      adminRole: adminRole ?? this.adminRole,
      messagesCount: messagesCount ?? this.messagesCount,
      unreadMessagesCount: unreadMessagesCount ?? this.unreadMessagesCount,
      latestMessage: latestMessage ?? this.latestMessage,
      messages: messages ?? this.messages,
      lastReplyAt: lastReplyAt ?? this.lastReplyAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      closedAt: closedAt ?? this.closedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  bool get isOpen => status == 'open' || status == 'in_progress' || status == 'waiting_user';
  bool get isResolved => status == 'resolved';
  bool get isClosed => status == 'closed';
  bool get isUrgent => priority == 'urgent';

  String get statusArabic {
    switch (status) {
      case 'open':
        return 'تذكرة جديدة';
      case 'in_progress':
        return 'قيد المعالجة';
      case 'waiting_user':
        return 'بانتظار رد العميل';
      case 'resolved':
        return 'تم الحل';
      case 'closed':
        return 'مغلقة';
      default:
        return status;
    }
  }

  String get priorityArabic {
    switch (priority) {
      case 'urgent':
        return 'عاجلة جداً';
      case 'high':
        return 'أولوية عالية';
      case 'normal':
        return 'أولوية عادية';
      case 'low':
        return 'منخفضة';
      default:
        return priority;
    }
  }

  String get categoryArabic {
    switch (category) {
      case 'orders_shipping':
      case 'الطلبات والتوصيل':
        return 'الطلبات والشحن';
      case 'supplements':
      case 'المكملات والجودة':
        return 'المكملات والجودة';
      case 'payment_refunds':
      case 'الدفع والاسترجاع':
        return 'المدفوعات والاسترجاع';
      case 'complaint':
        return 'شكوى وبلاغ رسمي';
      case 'suggestion':
        return 'اقتراح وتطوير';
      case 'technical':
      case 'مشكلة تقنية في التطبيق':
        return 'مشكلة تقنية';
      default:
        return category;
    }
  }
}
