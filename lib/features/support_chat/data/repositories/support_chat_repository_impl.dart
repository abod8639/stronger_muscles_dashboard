import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import 'package:stronger_muscles_dashboard/core/error/network_error_handler.dart';
import '../../domain/entities/support_chat_message_entity.dart';
import '../../domain/entities/support_chat_ticket_entity.dart';
import '../../domain/repositories/support_chat_repository.dart';
import '../datasources/support_chat_remote_datasource.dart';

class SupportChatRepositoryImpl implements SupportChatRepository {
  final SupportChatRemoteDataSource _remoteDataSource;

  const SupportChatRepositoryImpl({
    required SupportChatRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, SupportChatTicketEntity>> getTicketChatDetail(
    int ticketId,
  ) async {
    try {
      final model = await _remoteDataSource.getTicketChatDetail(ticketId);
      return Right(model.toEntity());
    } catch (e, stack) {
      debugPrint('[SupportChatRepository.getTicketChatDetail] Error: $e\n$stack');
      return Left(NetworkErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, SupportChatMessageEntity>> sendMessage({
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
    } catch (e, stack) {
      debugPrint('[SupportChatRepository.sendMessage] Error: $e\n$stack');
      return Left(NetworkErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, SupportChatTicketEntity>> updateStatus(
    int ticketId,
    String status,
  ) async {
    try {
      final model = await _remoteDataSource.updateStatus(ticketId, status);
      return Right(model.toEntity());
    } catch (e, stack) {
      debugPrint('[SupportChatRepository.updateStatus] Error: $e\n$stack');
      return Left(NetworkErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, SupportChatTicketEntity>> updatePriority(
    int ticketId,
    String priority,
  ) async {
    try {
      final model = await _remoteDataSource.updatePriority(ticketId, priority);
      return Right(model.toEntity());
    } catch (e, stack) {
      debugPrint('[SupportChatRepository.updatePriority] Error: $e\n$stack');
      return Left(NetworkErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, SupportChatTicketEntity>> assignAdmin(
    int ticketId,
    int? adminId,
  ) async {
    try {
      final model = await _remoteDataSource.assignAdmin(ticketId, adminId);
      return Right(model.toEntity());
    } catch (e, stack) {
      debugPrint('[SupportChatRepository.assignAdmin] Error: $e\n$stack');
      return Left(NetworkErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTicket(int ticketId) async {
    try {
      await _remoteDataSource.deleteTicket(ticketId);
      return const Right(null);
    } catch (e, stack) {
      debugPrint('[SupportChatRepository.deleteTicket] Error: $e\n$stack');
      return Left(NetworkErrorHandler.handleException(e));
    }
  }
}

