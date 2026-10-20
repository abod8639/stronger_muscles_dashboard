import '../entities/support_message_entity.dart';
import '../entities/support_stats_entity.dart';
import '../entities/support_ticket_entity.dart';

abstract class SupportRepository {
  Future<Map<String, dynamic>> getTickets({
    String? status,
    String? priority,
    String? category,
    String? search,
    int? adminId,
    int page = 1,
    int perPage = 15,
  });

  Future<SupportTicketEntity> getTicketDetail(int ticketId);

  Future<SupportMessageEntity> sendMessage({
    required int ticketId,
    required String message,
    bool isInternalNote = false,
    String? status,
    List<String>? attachments,
  });

  Future<SupportTicketEntity> updateStatus(int ticketId, String status);

  Future<SupportTicketEntity> updatePriority(int ticketId, String priority);

  Future<SupportTicketEntity> assignAdmin(int ticketId, int? adminId);

  Future<void> deleteTicket(int ticketId);

  Future<SupportStatsEntity> getStats();
}
