import 'package:stronger_muscles_dashboard/features/support/domain/entities/support_message_entity.dart';
import 'package:stronger_muscles_dashboard/features/support/domain/entities/support_ticket_entity.dart';
import '../../domain/entities/support_chat_message_entity.dart';
import '../../domain/entities/support_chat_ticket_entity.dart';

/// Bidirectional Clean Architecture bridge between [SupportTicketEntity] and [SupportChatTicketEntity].
/// Allows seamless interoperability between the legacy support controller and dedicated chat feature.
abstract class SupportChatEntityBridge {
  static SupportChatTicketEntity toChatTicket(SupportTicketEntity ticket) {
    return SupportChatTicketEntity(
      id: ticket.id,
      ticketNumber: ticket.ticketNumber,
      userId: ticket.userId,
      userName: ticket.userName,
      userEmail: ticket.userEmail,
      userPhone: ticket.userPhone,
      userAvatar: ticket.userAvatar,
      subject: ticket.subject,
      category: ticket.category,
      priority: ticket.priority,
      status: ticket.status,
      orderId: ticket.orderId,
      orderNumber: ticket.orderNumber,
      orderTotal: ticket.orderTotal,
      assignedAdminId: ticket.adminId,
      assignedAdminName: ticket.adminName,
      messagesCount: ticket.messagesCount,
      messages: ticket.messages.map(toChatMessage).toList(),
      createdAt: ticket.createdAt,
      closedAt: ticket.closedAt,
    );
  }

  static SupportChatMessageEntity toChatMessage(SupportMessageEntity msg) {
    return SupportChatMessageEntity(
      id: msg.id,
      ticketId: msg.ticketId,
      senderId: msg.senderId ?? 0,
      senderName: msg.senderName,
      senderType: msg.senderType,
      message: msg.message,
      attachments: msg.attachments,
      isInternalNote: msg.isInternalNote,
      createdAt: msg.createdAt,
      isOptimistic: false,
      isFailed: false,
    );
  }

  static SupportTicketEntity toSupportTicket(
    SupportChatTicketEntity chatTicket, {
    String? adminRole,
    int unreadMessagesCount = 0,
    SupportMessageEntity? latestMessage,
    DateTime? lastReplyAt,
    DateTime? resolvedAt,
  }) {
    return SupportTicketEntity(
      id: chatTicket.id,
      ticketNumber: chatTicket.ticketNumber,
      userId: chatTicket.userId,
      userName: chatTicket.userName,
      userEmail: chatTicket.userEmail,
      userPhone: chatTicket.userPhone,
      userAvatar: chatTicket.userAvatar,
      subject: chatTicket.subject,
      category: chatTicket.category,
      priority: chatTicket.priority,
      status: chatTicket.status,
      orderId: chatTicket.orderId,
      orderNumber: chatTicket.orderNumber,
      orderTotal: chatTicket.orderTotal,
      adminId: chatTicket.assignedAdminId,
      adminName: chatTicket.assignedAdminName,
      adminRole: adminRole,
      messagesCount: chatTicket.messagesCount,
      unreadMessagesCount: unreadMessagesCount,
      latestMessage: latestMessage,
      messages: chatTicket.messages.map(toSupportMessage).toList(),
      lastReplyAt: lastReplyAt,
      resolvedAt: resolvedAt,
      closedAt: chatTicket.closedAt,
      createdAt: chatTicket.createdAt,
    );
  }

  static SupportMessageEntity toSupportMessage(SupportChatMessageEntity msg) {
    return SupportMessageEntity(
      id: msg.id,
      ticketId: msg.ticketId,
      senderType: msg.senderType,
      senderId: msg.senderId,
      senderName: msg.senderName,
      message: msg.message,
      attachments: msg.attachments,
      isInternalNote: msg.isInternalNote,
      isRead: true,
      createdAt: msg.createdAt,
    );
  }
}

extension SupportTicketEntityBridgeExtension on SupportTicketEntity {
  SupportChatTicketEntity toChatTicket() =>
      SupportChatEntityBridge.toChatTicket(this);
}

extension SupportChatTicketEntityBridgeExtension on SupportChatTicketEntity {
  SupportTicketEntity toSupportTicket({
    String? adminRole,
    int unreadMessagesCount = 0,
    SupportMessageEntity? latestMessage,
    DateTime? lastReplyAt,
    DateTime? resolvedAt,
  }) => SupportChatEntityBridge.toSupportTicket(
        this,
        adminRole: adminRole,
        unreadMessagesCount: unreadMessagesCount,
        latestMessage: latestMessage,
        lastReplyAt: lastReplyAt,
        resolvedAt: resolvedAt,
      );
}

extension SupportMessageEntityBridgeExtension on SupportMessageEntity {
  SupportChatMessageEntity toChatMessage() =>
      SupportChatEntityBridge.toChatMessage(this);
}

extension SupportChatMessageEntityBridgeExtension on SupportChatMessageEntity {
  SupportMessageEntity toSupportMessage() =>
      SupportChatEntityBridge.toSupportMessage(this);
}
