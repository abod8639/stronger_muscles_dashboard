import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles_dashboard/features/support/domain/entities/support_message_entity.dart';
import 'package:stronger_muscles_dashboard/features/support/domain/entities/support_ticket_entity.dart';
import 'package:stronger_muscles_dashboard/features/support_chat/data/mappers/support_chat_entity_bridge.dart';

void main() {
  test('SupportChatEntityBridge converts SupportTicketEntity to SupportChatTicketEntity accurately', () {
    final ticket = SupportTicketEntity(
      id: 42,
      ticketNumber: 'SM-TEST42',
      userName: 'Test User',
      userEmail: 'test@example.com',
      subject: 'Test Subject',
      category: 'Support',
      createdAt: DateTime.now(),
      messages: [
        SupportMessageEntity(
          id: 101,
          ticketId: 42,
          senderType: 'user',
          senderId: 5,
          senderName: 'Test User',
          message: 'Hello, I need help',
          createdAt: DateTime.now(),
        ),
        SupportMessageEntity(
          id: 102,
          ticketId: 42,
          senderType: 'admin',
          senderId: 1,
          senderName: 'Admin',
          message: 'Sure, we are looking into it',
          createdAt: DateTime.now(),
        ),
      ],
    );

    final chatTicket = ticket.toChatTicket();
    expect(chatTicket.id, 42);
    expect(chatTicket.ticketNumber, 'SM-TEST42');
    expect(chatTicket.messages.length, 2);
    expect(chatTicket.messages[0].message, 'Hello, I need help');
    expect(chatTicket.messages[0].isUser, true);
    expect(chatTicket.messages[1].isAdmin, true);

    final reverted = chatTicket.toSupportTicket();
    expect(reverted.id, 42);
    expect(reverted.messages.length, 2);
    expect(reverted.messages[0].message, 'Hello, I need help');
  });
}

