import '../../domain/entities/support_message_entity.dart';
import '../../domain/entities/support_stats_entity.dart';
import '../../domain/entities/support_ticket_entity.dart';
import '../../domain/entities/support_tickets_page_entity.dart';
import '../models/support_message_model.dart';
import '../models/support_stats_model.dart';
import '../models/support_ticket_model.dart';
import '../models/support_tickets_page_model.dart';

/// Extension Mappers strictly isolating Data Models/DTOs from Domain Entities.
/// Adheres to Clean Architecture Rule 1 without leaking conversion logic into Domain.

extension SupportMessageModelMapper on SupportMessageModel {
  SupportMessageEntity toEntity() {
    return SupportMessageEntity(
      id: id,
      ticketId: ticketId,
      senderType: senderType,
      senderId: senderId,
      senderName: senderName,
      message: message,
      attachments: attachments,
      isInternalNote: isInternalNote,
      isRead: isRead,
      createdAt: createdAt,
    );
  }
}

extension SupportMessageEntityMapper on SupportMessageEntity {
  SupportMessageModel toModel() {
    return SupportMessageModel(
      id: id,
      ticketId: ticketId,
      senderType: senderType,
      senderId: senderId,
      senderName: senderName,
      message: message,
      attachments: attachments,
      isInternalNote: isInternalNote,
      isRead: isRead,
      createdAt: createdAt,
    );
  }
}

extension SupportStatsModelMapper on SupportStatsModel {
  SupportStatsEntity toEntity() {
    return SupportStatsEntity(
      total: total,
      open: open,
      inProgress: inProgress,
      waitingUser: waitingUser,
      resolved: resolved,
      closed: closed,
      urgent: urgent,
      resolvedToday: resolvedToday,
      byCategory: byCategory,
      byPriority: byPriority,
    );
  }
}

extension SupportStatsEntityMapper on SupportStatsEntity {
  SupportStatsModel toModel() {
    return SupportStatsModel(
      total: total,
      open: open,
      inProgress: inProgress,
      waitingUser: waitingUser,
      resolved: resolved,
      closed: closed,
      urgent: urgent,
      resolvedToday: resolvedToday,
      byCategory: byCategory,
      byPriority: byPriority,
    );
  }
}

extension SupportTicketModelMapper on SupportTicketModel {
  SupportTicketEntity toEntity() {
    return SupportTicketEntity(
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
      adminId: adminId,
      adminName: adminName,
      adminRole: adminRole,
      messagesCount: messagesCount,
      unreadMessagesCount: unreadMessagesCount,
      latestMessage: latestMessage?.toEntity(),
      messages: messages.map((m) => m.toEntity()).toList(),
      lastReplyAt: lastReplyAt,
      resolvedAt: resolvedAt,
      closedAt: closedAt,
      createdAt: createdAt,
    );
  }
}

extension SupportTicketEntityMapper on SupportTicketEntity {
  SupportTicketModel toModel() {
    return SupportTicketModel(
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
      adminId: adminId,
      adminName: adminName,
      adminRole: adminRole,
      messagesCount: messagesCount,
      unreadMessagesCount: unreadMessagesCount,
      latestMessage: latestMessage?.toModel(),
      messages: messages.map((m) => m.toModel()).toList(),
      lastReplyAt: lastReplyAt,
      resolvedAt: resolvedAt,
      closedAt: closedAt,
      createdAt: createdAt,
    );
  }
}

extension SupportTicketsPageModelMapper on SupportTicketsPageModel {
  SupportTicketsPageEntity toEntity() {
    return SupportTicketsPageEntity(
      tickets: tickets.map((t) => t.toEntity()).toList(),
      stats: stats.toEntity(),
      currentPage: currentPage,
      totalCount: totalCount,
      hasMore: hasMore,
    );
  }
}

extension SupportTicketsPageEntityMapper on SupportTicketsPageEntity {
  SupportTicketsPageModel toModel() {
    return SupportTicketsPageModel(
      tickets: tickets.map((t) => t.toModel()).toList(),
      stats: stats.toModel(),
      currentPage: currentPage,
      totalCount: totalCount,
      hasMore: hasMore,
    );
  }
}
