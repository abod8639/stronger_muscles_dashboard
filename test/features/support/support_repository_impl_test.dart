import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import 'package:stronger_muscles_dashboard/features/support/data/datasources/support_local_data_source.dart';
import 'package:stronger_muscles_dashboard/features/support/data/datasources/support_remote_data_source.dart';
import 'package:stronger_muscles_dashboard/features/support/data/models/support_message_model.dart';
import 'package:stronger_muscles_dashboard/features/support/data/models/support_stats_model.dart';
import 'package:stronger_muscles_dashboard/features/support/data/models/support_ticket_model.dart';
import 'package:stronger_muscles_dashboard/features/support/data/models/support_tickets_page_model.dart';
import 'package:stronger_muscles_dashboard/features/support/data/repositories/support_repository_impl.dart';

class MockSupportLocalDataSource implements SupportLocalDataSource {
  SupportTicketsPageModel? cachedPage;
  SupportStatsModel? cachedStats;
  final Map<int, SupportTicketModel> cachedTickets = {};
  Exception? exceptionToThrow;

  @override
  Future<void> cacheTicketsPage(SupportTicketsPageModel page) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    cachedPage = page;
  }

  @override
  Future<SupportTicketsPageModel?> getCachedTicketsPage() async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return cachedPage;
  }

  @override
  Future<void> cacheTicketDetail(SupportTicketModel ticket) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    cachedTickets[ticket.id] = ticket;
  }

  @override
  Future<SupportTicketModel?> getCachedTicketDetail(int ticketId) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return cachedTickets[ticketId];
  }

  @override
  Future<void> cacheStats(SupportStatsModel stats) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    cachedStats = stats;
  }

  @override
  Future<SupportStatsModel?> getCachedStats() async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return cachedStats;
  }

  @override
  Future<void> clearCache() async {
    cachedPage = null;
    cachedStats = null;
    cachedTickets.clear();
  }
}

class MockSupportRemoteDataSource implements SupportRemoteDataSource {
  SupportTicketsPageModel? remotePage;
  SupportTicketModel? remoteTicket;
  SupportMessageModel? sentMessage;
  SupportStatsModel? remoteStats;
  Exception? exceptionToThrow;

  @override
  Future<SupportTicketsPageModel> getTickets({
    String? status,
    String? priority,
    String? category,
    String? search,
    int? adminId,
    int page = 1,
    int perPage = 15,
  }) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return remotePage ??
        const SupportTicketsPageModel(tickets: [], stats: SupportStatsModel());
  }

  @override
  Future<SupportTicketModel> getTicketDetail(int ticketId) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return remoteTicket ??
        SupportTicketModel(
          id: ticketId,
          ticketNumber: 'SM-$ticketId',
          userName: 'عميل تجريبي',
          userEmail: 'test@example.com',
          subject: 'موضوع تجريبي',
          category: 'general',
          createdAt: DateTime.now(),
        );
  }

  @override
  Future<SupportMessageModel> sendMessage({
    required int ticketId,
    required String message,
    bool isInternalNote = false,
    String? status,
    List<String>? attachments,
  }) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return sentMessage ??
        SupportMessageModel(
          id: 99,
          ticketId: ticketId,
          senderType: 'admin',
          senderName: 'مشرف',
          message: message,
          createdAt: DateTime.now(),
        );
  }

  @override
  Future<SupportTicketModel> updateStatus(int ticketId, String status) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    final base = await getTicketDetail(ticketId);
    return base.copyWith(status: status);
  }

  @override
  Future<SupportTicketModel> updatePriority(
    int ticketId,
    String priority,
  ) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    final base = await getTicketDetail(ticketId);
    return base.copyWith(priority: priority);
  }

  @override
  Future<SupportTicketModel> assignAdmin(int ticketId, int? adminId) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    final base = await getTicketDetail(ticketId);
    return base.copyWith(adminId: adminId, adminName: 'مشرف معين');
  }

  @override
  Future<void> deleteTicket(int ticketId) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
  }

  @override
  Future<SupportStatsModel> getStats() async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return remoteStats ?? const SupportStatsModel(total: 10, open: 3);
  }
}

void main() {
  late MockSupportLocalDataSource mockLocal;
  late MockSupportRemoteDataSource mockRemote;
  late SupportRepositoryImpl repository;

  setUp(() {
    mockLocal = MockSupportLocalDataSource();
    mockRemote = MockSupportRemoteDataSource();
    repository = SupportRepositoryImpl(
      remoteDataSource: mockRemote,
      localDataSource: mockLocal,
    );
  });

  group('SupportRepositoryImpl SSOT & Caching Tests', () {
    final testTicket = SupportTicketModel(
      id: 5,
      ticketNumber: 'SM-005',
      userName: 'ياسر',
      userEmail: 'yaser@test.com',
      subject: 'استفسار طلبية',
      category: 'orders_shipping',
      createdAt: DateTime(2026, 10, 28),
    );

    test('getTickets returns remote data and caches in local Hive', () async {
      final pageModel = SupportTicketsPageModel(
        tickets: [testTicket],
        stats: const SupportStatsModel(total: 1, open: 1),
      );
      mockRemote.remotePage = pageModel;

      final result = await repository.getTickets();

      expect(result.isRight(), isTrue);
      result.fold((_) => fail('Expected Right'), (page) {
        expect(page.tickets.length, 1);
        expect(page.tickets.first.ticketNumber, 'SM-005');
      });
      expect(mockLocal.cachedPage, isNotNull);
      expect(mockLocal.cachedPage?.tickets.first.ticketNumber, 'SM-005');
    });

    test(
      'getTickets falls back to local cache when remote throws DioException',
      () async {
        mockLocal.cachedPage = SupportTicketsPageModel(
          tickets: [testTicket],
          stats: const SupportStatsModel(total: 1, open: 1),
        );
        mockRemote.exceptionToThrow = DioException(
          requestOptions: RequestOptions(path: '/tickets'),
          type: DioExceptionType.connectionError,
        );

        final result = await repository.getTickets();

        expect(result.isRight(), isTrue);
        result.fold((_) => fail('Expected Right cache fallback'), (page) {
          expect(page.tickets.length, 1);
          expect(page.tickets.first.userName, 'ياسر');
        });
      },
    );

    test('getTicketDetail caches detailed ticket in local Hive', () async {
      mockRemote.remoteTicket = testTicket;

      final result = await repository.getTicketDetail(5);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (ticket) => expect(ticket.id, 5),
      );
      expect(mockLocal.cachedTickets[5]?.ticketNumber, 'SM-005');
    });

    test('sendMessage sends message and returns domain entity', () async {
      final result = await repository.sendMessage(
        ticketId: 5,
        message: 'تم إرسال الطلب',
      );

      expect(result.isRight(), isTrue);
      result.fold((_) => fail('Expected Right'), (msg) {
        expect(msg.ticketId, 5);
        expect(msg.message, 'تم إرسال الطلب');
      });
    });

    test(
      'updateStatus updates ticket status and updates local cache',
      () async {
        mockRemote.remoteTicket = testTicket;

        final result = await repository.updateStatus(5, 'resolved');

        expect(result.isRight(), isTrue);
        result.fold(
          (_) => fail('Expected Right'),
          (ticket) => expect(ticket.status, 'resolved'),
        );
        expect(mockLocal.cachedTickets[5]?.status, 'resolved');
      },
    );

    test('deleteTicket returns Right(unit) on success', () async {
      final result = await repository.deleteTicket(5);

      expect(result.isRight(), isTrue);
    });

    test('getStats caches stats and falls back to cache on failure', () async {
      mockLocal.cachedStats = const SupportStatsModel(total: 15, open: 2);
      mockRemote.exceptionToThrow = DioException(
        requestOptions: RequestOptions(path: '/stats'),
        type: DioExceptionType.connectionTimeout,
      );

      final result = await repository.getStats();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right cache fallback'),
        (stats) => expect(stats.total, 15),
      );
    });

    test(
      'returns Left(Failure) when remote throws and no cache is present',
      () async {
        mockRemote.exceptionToThrow = DioException(
          requestOptions: RequestOptions(path: '/tickets'),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: '/tickets'),
            statusCode: 500,
            data: {'message': 'خطأ داخلي في الخادم'},
          ),
        );

        final result = await repository.getTickets();

        expect(result.isLeft(), isTrue);
        result.fold((failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.statusCode, 500);
        }, (_) => fail('Expected Left Failure'));
      },
    );
  });
}
