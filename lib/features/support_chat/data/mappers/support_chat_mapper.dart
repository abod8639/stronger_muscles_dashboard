import '../../domain/entities/support_chat_message_entity.dart';
import '../../domain/entities/support_chat_ticket_entity.dart';
import '../models/support_chat_message_model.dart';
import '../models/support_chat_ticket_model.dart';

extension SupportChatMessageModelMapper on SupportChatMessageModel {
  SupportChatMessageEntity toEntity({bool isOptimistic = false}) {
    return SupportChatMessageEntity(
      id: id,
      ticketId: ticketId,
      senderId: senderId ?? 0,
      senderName: senderName,
      senderType: senderType,
      senderAvatar: senderAvatar,
      message: message,
      isInternalNote: isInternalNote,
      attachments: attachments,
      createdAt: createdAt,
      isOptimistic: isOptimistic,
    );
  }
}

extension SupportChatMessageEntityMapper on SupportChatMessageEntity {
  SupportChatMessageModel toModel() {
    return SupportChatMessageModel(
      id: id,
      ticketId: ticketId,
      senderType: senderType,
      senderId: senderId,
      senderName: senderName,
      senderAvatar: senderAvatar,
      message: message,
      attachments: attachments,
      isInternalNote: isInternalNote,
      createdAt: createdAt,
    );
  }
}

extension SupportChatTicketModelMapper on SupportChatTicketModel {
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

