import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles_dashboard/features/support/data/mappers/support_mapper.dart';
import 'package:stronger_muscles_dashboard/features/support/data/models/support_message_model.dart';
import 'package:stronger_muscles_dashboard/features/support/data/models/support_stats_model.dart';
import 'package:stronger_muscles_dashboard/features/support/data/models/support_ticket_model.dart';
import 'package:stronger_muscles_dashboard/features/support/data/models/support_tickets_page_model.dart';
import 'package:stronger_muscles_dashboard/features/support/domain/entities/support_message_entity.dart';
import 'package:stronger_muscles_dashboard/features/support/domain/entities/support_stats_entity.dart';
import 'package:stronger_muscles_dashboard/features/support/domain/entities/support_ticket_entity.dart';
import 'package:stronger_muscles_dashboard/features/support/presentation/controllers/support_state.dart';

void main() {
  group('SupportMessageEntity & SupportMessageModel Tests', () {
    final now = DateTime(2026, 10, 28, 12, 0);

    test('SupportMessageEntity properties, copyWith and equality', () {
      final msg1 = SupportMessageEntity(
        id: 1,
        ticketId: 10,
        senderType: 'user',
        senderName: 'أحمد',
        message: 'استفسار بخصوص الطلب',
        createdAt: now,
      );
      final msg2 = SupportMessageEntity(
        id: 1,
        ticketId: 10,
        senderType: 'user',
        senderName: 'أحمد',
        message: 'استفسار بخصوص الطلب',
        createdAt: now,
      );
      final msg3 = msg1.copyWith(message: 'تم التعديل');

      expect(msg1, equals(msg2));
      expect(msg1.hashCode, equals(msg2.hashCode));
      expect(msg1, isNot(equals(msg3)));
      expect(msg1.isUser, isTrue);
      expect(msg1.isAdmin, isFalse);
      expect(msg1.isSystem, isFalse);
    });

    test('SupportMessageModel serialization and mapper conversion', () {
      final json = {
        'id': 101,
        'ticket_id': 50,
        'sender_type': 'admin',
        'sender_id': 2,
        'sender_name': 'مشرف الدعم',
        'message': 'أهلاً بك',
        'attachments': ['https://example.com/file.png'],
        'is_internal_note': false,
        'is_read': true,
        'created_at': now.toIso8601String(),
      };

      final model = SupportMessageModel.fromJson(json);
      expect(model.id, 101);
      expect(model.ticketId, 50);
      expect(model.senderType, 'admin');
      expect(model.attachments.length, 1);

      final entity = model.toEntity();
      expect(entity.id, 101);
      expect(entity.isAdmin, isTrue);

      final backToModel = entity.toModel();
      expect(backToModel, equals(model));
      expect(backToModel.toJson()['id'], 101);
    });
  });

  group('SupportStatsEntity & SupportStatsModel Tests', () {
    test('SupportStatsEntity equality and copyWith', () {
      const stats1 = SupportStatsEntity(total: 10, open: 4, urgent: 2);
      const stats2 = SupportStatsEntity(total: 10, open: 4, urgent: 2);
      final stats3 = stats1.copyWith(open: 5);

      expect(stats1, equals(stats2));
      expect(stats1, isNot(equals(stats3)));
      expect(stats3.open, 5);
      expect(stats3.total, 10);
    });

    test('SupportStatsModel serialization and bidirectional mapping', () {
      final json = {
        'total': 25,
        'open': 8,
        'in_progress': 5,
        'waiting_user': 3,
        'resolved': 7,
        'closed': 2,
        'urgent': 1,
        'resolved_today': 4,
        'by_category': {'orders': 15, 'supplements': 10},
        'by_priority': {'urgent': 1, 'high': 4, 'normal': 20},
      };

      final model = SupportStatsModel.fromJson(json);
      expect(model.total, 25);
      expect(model.open, 8);
      expect(model.byCategory['orders'], 15);

      final entity = model.toEntity();
      expect(entity.total, 25);
      expect(entity.resolvedToday, 4);

      final backToModel = entity.toModel();
      expect(backToModel, equals(model));
      expect(backToModel.toJson()['total'], 25);
    });
  });

  group('SupportTicketEntity & SupportTicketModel Tests', () {
    final now = DateTime(2026, 10, 28, 10, 30);

    test(
      'SupportTicketEntity status, priority and category Arabic getters',
      () {
        final ticket = SupportTicketEntity(
          id: 1,
          ticketNumber: 'SM-1',
          userName: 'خالد',
          userEmail: 'khaled@example.com',
          subject: 'تأخر في الشحنة',
          category: 'orders_shipping',
          priority: 'urgent',
          status: 'open',
          createdAt: now,
        );

        expect(ticket.isOpen, isTrue);
        expect(ticket.isUrgent, isTrue);
        expect(ticket.isResolved, isFalse);
        expect(ticket.isClosed, isFalse);
        expect(ticket.statusArabic, 'تذكرة جديدة');
        expect(ticket.priorityArabic, 'عاجلة جداً');
        expect(ticket.categoryArabic, 'الطلبات والشحن');
      },
    );

    test('SupportTicketModel serialization and bidirectional mapping', () {
      final json = {
        'id': 7,
        'ticket_number': 'SM-007',
        'user_id': 12,
        'name': 'محمد علي',
        'email': 'mohamed@test.com',
        'subject': 'استفسار عن البروتين',
        'category': 'supplements',
        'priority': 'high',
        'status': 'in_progress',
        'messages_count': 3,
        'unread_messages_count': 1,
        'created_at': now.toIso8601String(),
      };

      final model = SupportTicketModel.fromJson(json);
      expect(model.id, 7);
      expect(model.ticketNumber, 'SM-007');
      expect(model.userName, 'محمد علي');

      final entity = model.toEntity();
      expect(entity.id, 7);
      expect(entity.status, 'in_progress');

      final backToModel = entity.toModel();
      expect(backToModel.id, 7);
      expect(backToModel.ticketNumber, 'SM-007');
    });
  });

  group('SupportTicketsPageEntity & SupportState Tests', () {
    test('SupportTicketsPageModel and SupportTicketsPageEntity mapping', () {
      final pageModel = SupportTicketsPageModel(
        tickets: [
          SupportTicketModel(
            id: 1,
            ticketNumber: 'SM-1',
            userName: 'سارة',
            userEmail: 'sara@test.com',
            subject: 'طلب إلغاء',
            category: 'payment_refunds',
            createdAt: DateTime.now(),
          ),
        ],
        stats: const SupportStatsModel(total: 1, open: 1),
        currentPage: 1,
        totalCount: 1,
        hasMore: false,
      );

      final pageEntity = pageModel.toEntity();
      expect(pageEntity.tickets.length, 1);
      expect(pageEntity.stats.total, 1);
      expect(pageEntity.currentPage, 1);

      final backToModel = pageEntity.toModel();
      expect(backToModel.tickets.length, 1);
      expect(backToModel.totalCount, 1);
    });

    test('SupportState immutability and copyWith', () {
      const state1 = SupportState(
        isLoading: false,
        selectedStatus: 'open',
        searchQuery: '',
      );
      final state2 = state1.copyWith(searchQuery: 'بروتين');

      expect(state1.searchQuery, '');
      expect(state2.searchQuery, 'بروتين');
      expect(state2.selectedStatus, 'open');
    });
  });
}
