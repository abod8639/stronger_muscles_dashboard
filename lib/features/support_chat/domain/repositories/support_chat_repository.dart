import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/support_chat_message_entity.dart';
import '../entities/support_chat_ticket_entity.dart';

/// Clean Architecture Repository Contract for the Support Chat feature.
abstract class SupportChatRepository {
  /// Fetches detailed conversation thread and metadata for a specific ticket.
  Future<Either<Failure, SupportChatTicketEntity>> getTicketChatDetail(
    int ticketId,
  );

  /// Sends a reply or internal supervisor note within a ticket conversation.
  Future<Either<Failure, SupportChatMessageEntity>> sendMessage({
    required int ticketId,
    required String message,
    bool isInternalNote = false,
    String? status,
    List<String>? attachments,
  });

  /// Updates ticket status (e.g. open, in_progress, waiting_user, resolved, closed).
  Future<Either<Failure, SupportChatTicketEntity>> updateStatus(
    int ticketId,
    String status,
  );

  /// Updates ticket urgency/priority (low, normal, high, urgent).
  Future<Either<Failure, SupportChatTicketEntity>> updatePriority(
    int ticketId,
    String priority,
  );

  /// Assigns an admin supervisor to handle the ticket.
  Future<Either<Failure, SupportChatTicketEntity>> assignAdmin(
    int ticketId,
    int? adminId,
  );

  /// Deletes the ticket and its entire message history.
  Future<Either<Failure, void>> deleteTicket(int ticketId);
}
