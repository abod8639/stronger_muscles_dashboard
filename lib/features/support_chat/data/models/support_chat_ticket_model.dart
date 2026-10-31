import '../../domain/entities/support_chat_ticket_entity.dart';
import 'support_chat_message_model.dart';

/// Isolated Data Transfer Object (DTO) for support chat conversation ticket.
class SupportChatTicketModel {
  final int id;
  final String ticketNumber;
  final int? userId;
  final String userName;
  final String userEmail;
  final String? userPhone;
  final String? userAvatar;
  final String subject;
  final String category;
  final String priority;
  final String status;
  final String? orderId;
  final String? orderNumber;
  final double? orderTotal;
  final int? adminId;
  final String? adminName;
  final int messagesCount;
  final List<SupportChatMessageModel> messages;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? closedAt;

  const SupportChatTicketModel({
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
    this.messagesCount = 0,
    this.messages = const [],
    required this.createdAt,
    this.updatedAt,
    this.closedAt,
  });

  factory SupportChatTicketModel.fromJson(Map<String, dynamic> json) {
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
    if (json['assigned_admin'] is Map) {
      final adminMap = json['assigned_admin'] as Map;
      adminName = adminMap['name']?.toString();
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

    List<SupportChatMessageModel> msgs = [];
    if (json['messages'] is List) {
      msgs = (json['messages'] as List)
          .map((m) => SupportChatMessageModel.fromJson(m))
          .toList();
    }

    return SupportChatTicketModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
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
      orderId: json['order_id']?.toString(),
      orderNumber: orderNumber,
      orderTotal: orderTotal,
      adminId: json['admin_id'] is int
          ? json['admin_id'] as int
          : int.tryParse(json['admin_id']?.toString() ?? ''),
      adminName: adminName,
      messagesCount: json['messages_count'] is int
          ? json['messages_count'] as int
          : msgs.length,
      messages: msgs,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
      closedAt: json['closed_at'] != null
          ? DateTime.tryParse(json['closed_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ticket_number': ticketNumber,
      'user_id': userId,
      'subject': subject,
      'category': category,
      'priority': priority,
      'status': status,
      'admin_id': adminId,
      'messages': messages.map((m) => m.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  SupportChatTicketEntity toEntity() {
    return SupportChatTicketEntity(
      id: id,
      ticketNumber: ticketNumber,
      userId: userId,
      userName: userName,
      userEmail: userEmail,
      userPhone: userPhone,
      userAvatar: userAvatar,
      subject: subject,
      category: category,
      priority: priority,
      status: status,
      orderId: orderId,
      orderNumber: orderNumber,
      orderTotal: orderTotal,
      assignedAdminId: adminId,
      assignedAdminName: adminName,
      messagesCount: messagesCount,
      messages: messages.map((m) => m.toEntity()).toList(),
      createdAt: createdAt,
      updatedAt: updatedAt,
      closedAt: closedAt,
    );
  }
}

