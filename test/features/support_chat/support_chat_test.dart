import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import 'package:stronger_muscles_dashboard/features/support_chat/data/models/support_chat_message_model.dart';
import 'package:stronger_muscles_dashboard/features/support_chat/data/models/support_chat_ticket_model.dart';
import 'package:stronger_muscles_dashboard/features/support_chat/domain/entities/support_chat_message_entity.dart';
import 'package:stronger_muscles_dashboard/features/support_chat/domain/entities/support_chat_ticket_entity.dart';
import 'package:stronger_muscles_dashboard/features/support_chat/domain/repositories/support_chat_repository.dart';
import 'package:stronger_muscles_dashboard/features/support_chat/domain/usecases/assign_support_chat_admin_usecase.dart';
import 'package:stronger_muscles_dashboard/features/support_chat/domain/usecases/delete_support_chat_ticket_usecase.dart';
import 'package:stronger_muscles_dashboard/features/support_chat/domain/usecases/get_ticket_chat_detail_usecase.dart';
import 'package:stronger_muscles_dashboard/features/support_chat/domain/usecases/send_support_chat_message_usecase.dart';
import 'package:stronger_muscles_dashboard/features/support_chat/domain/usecases/update_support_chat_priority_usecase.dart';
import 'package:stronger_muscles_dashboard/features/support_chat/domain/usecases/update_support_chat_status_usecase.dart';
import 'package:stronger_muscles_dashboard/features/support_chat/presentation/controllers/support_chat_controller.dart';

class MockSupportChatRepository implements SupportChatRepository {
  SupportChatTicketEntity? ticketDetailResult;
  SupportChatMessageEntity? sendMessageResult;
  Failure? failureToThrow;

  @override
  Future<Either<Failure, SupportChatTicketEntity>> getTicketChatDetail(
    int ticketId,
  ) async {
    if (failureToThrow != null) return Left(failureToThrow!);
    return Right(
      ticketDetailResult ??
          SupportChatTicketEntity(
            id: ticketId,
            ticketNumber: 'SM-$ticketId',
            userName: 'محمد',
            userEmail: 'mohammed@example.com',
            subject: 'استفسار عن الشحن',
            category: 'orders_shipping',
            priority: 'normal',
            status: 'open',
            createdAt: DateTime.now(),
          ),
    );
  }

  @override
  Future<Either<Failure, SupportChatMessageEntity>> sendMessage({
    required int ticketId,
    required String message,
    bool isInternalNote = false,
    String? status,
    List<String>? attachments,
  }) async {
    if (failureToThrow != null) return Left(failureToThrow!);
    return Right(
      sendMessageResult ??
          SupportChatMessageEntity(
            id: 999,
            ticketId: ticketId,
            senderId: 1,
            senderName: 'الدعم الفني',
            senderType: 'admin',
            message: message,
            isInternalNote: isInternalNote,
            createdAt: DateTime.now(),
          ),
    );
  }

  @override
  Future<Either<Failure, SupportChatTicketEntity>> updateStatus(
    int ticketId,
    String status,
  ) async {
    if (failureToThrow != null) return Left(failureToThrow!);
    return Right(
      (ticketDetailResult ??
              SupportChatTicketEntity(
                id: ticketId,
                ticketNumber: 'SM-$ticketId',
                userName: 'محمد',
                userEmail: 'mohammed@example.com',
                subject: 'استفسار',
                category: 'general',
                priority: 'normal',
                status: 'open',
                createdAt: DateTime.now(),
              ))
          .copyWith(status: status),
    );
  }

  @override
  Future<Either<Failure, SupportChatTicketEntity>> updatePriority(
    int ticketId,
    String priority,
  ) async {
    if (failureToThrow != null) return Left(failureToThrow!);
    return Right(
      (ticketDetailResult ??
              SupportChatTicketEntity(
                id: ticketId,
                ticketNumber: 'SM-$ticketId',
                userName: 'محمد',
                userEmail: 'mohammed@example.com',
                subject: 'استفسار',
                category: 'general',
                priority: 'normal',
                status: 'open',
                createdAt: DateTime.now(),
              ))
          .copyWith(priority: priority),
    );
  }

  @override
  Future<Either<Failure, SupportChatTicketEntity>> assignAdmin(
    int ticketId,
    int? adminId,
  ) async {
    if (failureToThrow != null) return Left(failureToThrow!);
    return Right(
      (ticketDetailResult ??
              SupportChatTicketEntity(
                id: ticketId,
                ticketNumber: 'SM-$ticketId',
                userName: 'محمد',
                userEmail: 'mohammed@example.com',
                subject: 'استفسار',
                category: 'general',
                priority: 'normal',
                status: 'open',
                createdAt: DateTime.now(),
              ))
          .copyWith(assignedAdminId: adminId),
    );
  }

  @override
  Future<Either<Failure, void>> deleteTicket(int ticketId) async {
    if (failureToThrow != null) return Left(failureToThrow!);
    return const Right(null);
  }
}

void main() {
  group('SupportChatMessageEntity & SupportChatMessageModel Tests', () {
    final now = DateTime(2026, 10, 30, 3, 0);

    test('SupportChatMessageEntity copyWith, roles, and equality', () {
      final msg1 = SupportChatMessageEntity(
        id: 1,
        ticketId: 10,
        senderId: 5,
        senderName: 'أحمد',
        senderType: 'user',
        message: 'مرحباً، لدي استفسار',
        createdAt: now,
      );

      final msg2 = SupportChatMessageEntity(
        id: 1,
        ticketId: 10,
        senderId: 5,
        senderName: 'أحمد',
        senderType: 'user',
        message: 'مرحباً، لدي استفسار',
        createdAt: now,
      );

      final msg3 = msg1.copyWith(message: 'رسالة أخرى');

      expect(msg1, equals(msg2));
      expect(msg1.hashCode, equals(msg2.hashCode));
      expect(msg1, isNot(equals(msg3)));
      expect(msg1.isUser, isTrue);
      expect(msg1.isAdmin, isFalse);
    });

    test('SupportChatMessageModel JSON deserialization & conversion to entity', () {
      final json = {
        'id': 20,
        'ticket_id': 100,
        'sender_type': 'admin',
        'sender_id': 2,
        'sender_name': 'الدعم الفني',
        'message': 'تم استلام طلبك',
        'attachments': ['https://example.com/receipt.jpg'],
        'is_internal_note': false,
        'is_read': true,
        'created_at': now.toIso8601String(),
      };

      final model = SupportChatMessageModel.fromJson(json);
      expect(model.id, 20);
      expect(model.ticketId, 100);
      expect(model.senderType, 'admin');
      expect(model.attachments, hasLength(1));

      final entity = model.toEntity();
      expect(entity.id, 20);
      expect(entity.isAdmin, isTrue);
      expect(entity.isInternalNote, isFalse);
    });
  });

  group('SupportChatTicketEntity & SupportChatTicketModel Tests', () {
    final now = DateTime(2026, 10, 30, 3, 0);

    test('SupportChatTicketEntity Arabic getters and status flags', () {
      final ticket = SupportChatTicketEntity(
        id: 42,
        ticketNumber: 'SM-42',
        userName: 'خالد',
        userEmail: 'khaled@example.com',
        subject: 'تأخير في التوصيل',
        category: 'orders_shipping',
        priority: 'urgent',
        status: 'in_progress',
        createdAt: now,
      );

      expect(ticket.statusArabic, 'قيد المعالجة');
      expect(ticket.priorityArabic, 'عاجلة 🔥');
      expect(ticket.isOpen, isTrue);
      expect(ticket.isClosed, isFalse);
    });

    test('SupportChatTicketModel fromJson parses nested messages and user safely', () {
      final json = {
        'id': 50,
        'ticket_number': 'SM-50',
        'user': {
          'name': 'عمر',
          'email': 'omar@example.com',
          'phone_number': '+966500000000',
        },
        'subject': 'شكوى',
        'category': 'complaint',
        'priority': 'high',
        'status': 'open',
        'messages': [
          {
            'id': 1,
            'ticket_id': 50,
            'sender_type': 'user',
            'sender_name': 'عمر',
            'message': 'تفاصيل الشكوى',
            'created_at': now.toIso8601String(),
          }
        ],
        'created_at': now.toIso8601String(),
      };

      final model = SupportChatTicketModel.fromJson(json);
      expect(model.id, 50);
      expect(model.userName, 'عمر');
      expect(model.userEmail, 'omar@example.com');
      expect(model.messages, hasLength(1));

      final entity = model.toEntity();
      expect(entity.userName, 'عمر');
      expect(entity.messages.first.message, 'تفاصيل الشكوى');
    });
  });

  group('SupportChatNotifier Tests', () {
    late MockSupportChatRepository mockRepo;
    late SupportChatNotifier notifier;

    setUp(() {
      mockRepo = MockSupportChatRepository();
      notifier = SupportChatNotifier(
        getTicketDetailUseCase: GetTicketChatDetailUseCase(mockRepo),
        sendMessageUseCase: SendSupportChatMessageUseCase(mockRepo),
        updateStatusUseCase: UpdateSupportChatStatusUseCase(mockRepo),
        updatePriorityUseCase: UpdateSupportChatPriorityUseCase(mockRepo),
        assignAdminUseCase: AssignSupportChatAdminUseCase(mockRepo),
        deleteTicketUseCase: DeleteSupportChatTicketUseCase(mockRepo),
      );
    });

    test('loadTicket fetches and updates state with ticket conversation', () async {
      await notifier.loadTicket(10);

      expect(notifier.state.ticket, isNotNull);
      expect(notifier.state.ticket?.id, 10);
      expect(notifier.state.isLoading, isFalse);
      expect(notifier.state.errorMessage, isNull);
    });

    test('sendReply applies instant Optimistic UI update and confirms on server response', () async {
      await notifier.loadTicket(10);
      expect(notifier.state.ticket?.messages, isEmpty);

      final success = await notifier.sendReply(message: 'تم حل مشكلتك');

      expect(success, isTrue);
      expect(notifier.state.ticket?.messages, hasLength(1));
      expect(notifier.state.ticket?.messages.first.id, 999);
      expect(notifier.state.ticket?.messages.first.message, 'تم حل مشكلتك');
    });

    test('sendReply rolls back optimistic message when repository fails', () async {
      await notifier.loadTicket(10);
      mockRepo.failureToThrow = const ServerFailure(message: 'خطأ في الاتصال بالخادم');

      final success = await notifier.sendReply(message: 'رد فاشل');

      expect(success, isFalse);
      expect(notifier.state.ticket?.messages, isEmpty);
      expect(notifier.state.errorMessage, contains('فشل إرسال الرد'));
    });

    test('updateStatus updates ticket status successfully', () async {
      await notifier.loadTicket(10);
      await notifier.updateStatus('resolved');

      expect(notifier.state.ticket?.status, 'resolved');
      expect(notifier.state.successMessage, contains('تم الحل'));
    });

    test('deleteTicket clears ticket from state upon success', () async {
      await notifier.loadTicket(10);
      expect(notifier.state.ticket, isNotNull);

      final deleted = await notifier.deleteTicket();

      expect(deleted, isTrue);
      expect(notifier.state.ticket, isNull);
    });
  });
}
