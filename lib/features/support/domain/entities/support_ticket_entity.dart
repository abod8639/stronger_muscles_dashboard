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
