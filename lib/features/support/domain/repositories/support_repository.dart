import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/support_message_entity.dart';
import '../entities/support_stats_entity.dart';
import '../entities/support_ticket_entity.dart';
import '../entities/support_tickets_page_entity.dart';

/// 100% Pure Dart Abstract Repository contract for the Support & Complaints feature.
/// Adheres strictly to Clean Architecture & Functional Error Handling via [fpdart.Either].
abstract class SupportRepository {
  /// Fetches paginated support tickets with filters and real-time dashboard stats.
  Future<Either<Failure, SupportTicketsPageEntity>> getTickets({
    String? status,
    String? priority,
    String? category,
    String? search,
    int? adminId,
    int page = 1,
    int perPage = 15,
  });

  /// Fetches detailed conversation thread and metadata for a specific ticket.
  Future<Either<Failure, SupportTicketEntity>> getTicketDetail(int ticketId);

  /// Sends a reply or internal note within a ticket thread.
  Future<Either<Failure, SupportMessageEntity>> sendMessage({
    required int ticketId,
    required String message,
    bool isInternalNote = false,
    String? status,
    List<String>? attachments,
  });

  /// Updates ticket status (e.g. open, in_progress, waiting_user, resolved, closed).
  Future<Either<Failure, SupportTicketEntity>> updateStatus(
    int ticketId,
    String status,
  );

  /// Updates ticket urgency/priority (low, normal, high, urgent).
  Future<Either<Failure, SupportTicketEntity>> updatePriority(
    int ticketId,
    String priority,
  );

  /// Assigns an admin supervisor to handle the ticket.
  Future<Either<Failure, SupportTicketEntity>> assignAdmin(
    int ticketId,
    int? adminId,
  );

  /// Deletes a support ticket permanently.
  Future<Either<Failure, Unit>> deleteTicket(int ticketId);

  /// Retrieves high-level support metrics and analytics.
  Future<Either<Failure, SupportStatsEntity>> getStats();

  /// Real-time stream of incoming support tickets.
  Stream<SupportTicketEntity> get ticketCreatedStream;

  /// Real-time stream of updated support tickets.
  Stream<SupportTicketEntity> get ticketUpdatedStream;

  /// Real-time stream of incoming messages across tickets.
  Stream<(int ticketId, SupportMessageEntity message)> get messageSentStream;
}
