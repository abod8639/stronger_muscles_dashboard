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
