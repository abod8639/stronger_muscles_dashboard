import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import 'package:stronger_muscles_dashboard/core/error/network_error_handler.dart';
import '../../domain/entities/support_message_entity.dart';
import '../../domain/entities/support_stats_entity.dart';
import '../../domain/entities/support_ticket_entity.dart';
import '../../domain/entities/support_tickets_page_entity.dart';
import '../../domain/repositories/support_repository.dart';
import '../datasources/support_local_data_source.dart';
import '../datasources/support_realtime_data_source.dart';
import '../datasources/support_remote_data_source.dart';
import '../mappers/support_mapper.dart';

/// Single Source of Truth (SSOT) implementation of [SupportRepository].
/// Coordinates between [SupportRemoteDataSource] (Dio), [SupportLocalDataSource] (Hive),
/// and [SupportRealtimeDataSource] (WebSockets) with functional error handling via [fpdart.Either].
class SupportRepositoryImpl implements SupportRepository {
  final SupportRemoteDataSource _remoteDataSource;
  final SupportLocalDataSource _localDataSource;
  final SupportRealtimeDataSource? _realtimeDataSource;

  const SupportRepositoryImpl({
    required SupportRemoteDataSource remoteDataSource,
    required SupportLocalDataSource localDataSource,
    SupportRealtimeDataSource? realtimeDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _realtimeDataSource = realtimeDataSource;

  @override
  Future<Either<Failure, SupportTicketsPageEntity>> getTickets({
    String? status,
    String? priority,
    String? category,
    String? search,
    int? adminId,
    int page = 1,
    int perPage = 15,
  }) async {
    try {
      final remotePage = await _remoteDataSource.getTickets(
        status: status,
        priority: priority,
        category: category,
        search: search,
        adminId: adminId,
        page: page,
        perPage: perPage,
      );

      // Cache primary page in Hive for offline resilience
      if (page == 1 &&
          (status == null || status == 'all') &&
          (search == null || search.isEmpty)) {
        await _localDataSource.cacheTicketsPage(remotePage);
        await _localDataSource.cacheStats(remotePage.stats);
      }

      return Right(remotePage.toEntity());
    } catch (e, stackTrace) {
      debugPrint('[SupportRepositoryImpl.getTickets] Error: $e\n$stackTrace');

      // Offline Cache Fallback for initial load
      if (page == 1) {
        try {
          final cached = await _localDataSource.getCachedTicketsPage();
          if (cached != null) {
            return Right(cached.toEntity());
          }
        } catch (cacheError) {
          debugPrint(
            '[SupportRepositoryImpl.getTickets] Cache error: $cacheError',
          );
        }
      }

      return Left(NetworkErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, SupportTicketEntity>> getTicketDetail(
    int ticketId,
  ) async {
    try {
      final model = await _remoteDataSource.getTicketDetail(ticketId);
      await _localDataSource.cacheTicketDetail(model);
      return Right(model.toEntity());
    } catch (e, stackTrace) {
      debugPrint(
        '[SupportRepositoryImpl.getTicketDetail] Error: $e\n$stackTrace',
      );

      // Cache fallback
      try {
        final cached = await _localDataSource.getCachedTicketDetail(ticketId);
        if (cached != null) {
          return Right(cached.toEntity());
        }
      } catch (cacheError) {
        debugPrint(
          '[SupportRepositoryImpl.getTicketDetail] Cache error: $cacheError',
        );
      }

      return Left(NetworkErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, SupportMessageEntity>> sendMessage({
    required int ticketId,
    required String message,
    bool isInternalNote = false,
    String? status,
    List<String>? attachments,
  }) async {
    try {
      final model = await _remoteDataSource.sendMessage(
        ticketId: ticketId,
        message: message,
        isInternalNote: isInternalNote,
        status: status,
        attachments: attachments,
      );
      return Right(model.toEntity());
    } catch (e, stackTrace) {
      debugPrint('[SupportRepositoryImpl.sendMessage] Error: $e\n$stackTrace');
      return Left(NetworkErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, SupportTicketEntity>> updateStatus(
    int ticketId,
    String status,
  ) async {
    try {
      final model = await _remoteDataSource.updateStatus(ticketId, status);
      await _localDataSource.cacheTicketDetail(model);
      return Right(model.toEntity());
    } catch (e, stackTrace) {
      debugPrint('[SupportRepositoryImpl.updateStatus] Error: $e\n$stackTrace');
      return Left(NetworkErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, SupportTicketEntity>> updatePriority(
    int ticketId,
    String priority,
  ) async {
    try {
      final model = await _remoteDataSource.updatePriority(ticketId, priority);
      await _localDataSource.cacheTicketDetail(model);
      return Right(model.toEntity());
    } catch (e, stackTrace) {
      debugPrint(
        '[SupportRepositoryImpl.updatePriority] Error: $e\n$stackTrace',
      );
      return Left(NetworkErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, SupportTicketEntity>> assignAdmin(
    int ticketId,
    int? adminId,
  ) async {
    try {
      final model = await _remoteDataSource.assignAdmin(ticketId, adminId);
      await _localDataSource.cacheTicketDetail(model);
      return Right(model.toEntity());
    } catch (e, stackTrace) {
      debugPrint('[SupportRepositoryImpl.assignAdmin] Error: $e\n$stackTrace');
      return Left(NetworkErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteTicket(int ticketId) async {
    try {
      await _remoteDataSource.deleteTicket(ticketId);
      return const Right(unit);
    } catch (e, stackTrace) {
      debugPrint('[SupportRepositoryImpl.deleteTicket] Error: $e\n$stackTrace');
      return Left(NetworkErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, SupportStatsEntity>> getStats() async {
    try {
      final stats = await _remoteDataSource.getStats();
      await _localDataSource.cacheStats(stats);
      return Right(stats.toEntity());
    } catch (e, stackTrace) {
      debugPrint('[SupportRepositoryImpl.getStats] Error: $e\n$stackTrace');
      try {
        final cached = await _localDataSource.getCachedStats();
        if (cached != null) {
          return Right(cached.toEntity());
        }
      } catch (cacheError) {
        debugPrint('[SupportRepositoryImpl.getStats] Cache error: $cacheError');
      }
      return Left(NetworkErrorHandler.handleException(e));
    }
  }

  @override
  Stream<SupportTicketEntity> get ticketCreatedStream {
    if (_realtimeDataSource == null) return const Stream.empty();
    return _realtimeDataSource.onTicketCreated.map((model) => model.toEntity());
  }

  @override
  Stream<SupportTicketEntity> get ticketUpdatedStream {
    if (_realtimeDataSource == null) return const Stream.empty();
    return _realtimeDataSource.onTicketUpdated.map((model) => model.toEntity());
  }

  @override
  Stream<(int, SupportMessageEntity)> get messageSentStream {
    if (_realtimeDataSource == null) return const Stream.empty();
    return _realtimeDataSource.onMessageSent.map(
      (tuple) => (tuple.$1, tuple.$2.toEntity()),
    );
  }
}
