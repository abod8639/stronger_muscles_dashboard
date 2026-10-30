import 'package:flutter/foundation.dart';
import 'support_chat_message_entity.dart';

/// Clean Architecture Domain Entity representing a support ticket conversation thread.
@immutable
class SupportChatTicketEntity {
  final int id;
  final String ticketNumber;
  final int? userId;
  final String userName;
  final String userEmail;
  final String? userPhone;
  final String? userAvatar;
  final String subject;
  final String category;
  final String priority; // 'low' | 'normal' | 'high' | 'urgent'
  final String status; // 'open' | 'in_progress' | 'waiting_user' | 'resolved' | 'closed'
  final int? assignedAdminId;
  final String? assignedAdminName;
  final int messagesCount;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? closedAt;
  final List<SupportChatMessageEntity> messages;

  const SupportChatTicketEntity({
    required this.id,
    required this.ticketNumber,
    this.userId,
    required this.userName,
    required this.userEmail,
    this.userPhone,
    this.userAvatar,
    required this.subject,
    required this.category,
    required this.priority,
    required this.status,
    this.assignedAdminId,
    this.assignedAdminName,
    this.messagesCount = 0,
    required this.createdAt,
    this.updatedAt,
    this.closedAt,
    this.messages = const [],
  });

  String get statusArabic {
    switch (status.toLowerCase()) {
      case 'open':
        return 'مفتوحة';
      case 'in_progress':
        return 'قيد المعالجة';
      case 'waiting_user':
        return 'بانتظار العميل';
      case 'resolved':
        return 'تم الحل';
      case 'closed':
        return 'مغلقة';
      default:
        return status;
    }
  }

  String get priorityArabic {
    switch (priority.toLowerCase()) {
      case 'urgent':
        return 'عاجلة 🔥';
      case 'high':
        return 'مرتفعة';
      case 'normal':
        return 'عادية';
      case 'low':
        return 'منخفضة';
      default:
        return priority;
    }
  }

  bool get isOpen => status == 'open' || status == 'in_progress';
  bool get isResolved => status == 'resolved';
  bool get isClosed => status == 'closed';

  SupportChatTicketEntity copyWith({
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
    int? assignedAdminId,
    String? assignedAdminName,
    int? messagesCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? closedAt,
    List<SupportChatMessageEntity>? messages,
  }) {
    return SupportChatTicketEntity(
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
      assignedAdminId: assignedAdminId ?? this.assignedAdminId,
      assignedAdminName: assignedAdminName ?? this.assignedAdminName,
      messagesCount: messagesCount ?? this.messagesCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      closedAt: closedAt ?? this.closedAt,
      messages: messages ?? this.messages,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SupportChatTicketEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          status == other.status &&
          priority == other.priority &&
          messagesCount == other.messagesCount &&
          messages.length == other.messages.length;

  @override
  int get hashCode =>
      id.hashCode ^
      status.hashCode ^
      priority.hashCode ^
      messages.length.hashCode;
}

