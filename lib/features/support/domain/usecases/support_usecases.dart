import '../entities/support_message_entity.dart';
import '../entities/support_stats_entity.dart';
import '../entities/support_ticket_entity.dart';
import '../repositories/support_repository.dart';

class GetSupportTicketsUseCase {
  final SupportRepository repository;
  GetSupportTicketsUseCase(this.repository);

  Future<Map<String, dynamic>> call({
    String? status,
    String? priority,
    String? category,
    String? search,
    int? adminId,
    int page = 1,
    int perPage = 15,
  }) {
    return repository.getTickets(
      status: status,
      priority: priority,
      category: category,
      search: search,
      adminId: adminId,
      page: page,
      perPage: perPage,
    );
  }
}

class GetSupportTicketDetailUseCase {
  final SupportRepository repository;
  GetSupportTicketDetailUseCase(this.repository);

  Future<SupportTicketEntity> call(int ticketId) {
    return repository.getTicketDetail(ticketId);
  }
}

class SendSupportMessageUseCase {
  final SupportRepository repository;
  SendSupportMessageUseCase(this.repository);

  Future<SupportMessageEntity> call({
    required int ticketId,
    required String message,
    bool isInternalNote = false,
    String? status,
    List<String>? attachments,
  }) {
    return repository.sendMessage(
      ticketId: ticketId,
      message: message,
      isInternalNote: isInternalNote,
      status: status,
      attachments: attachments,
    );
  }
}

class UpdateTicketStatusUseCase {
  final SupportRepository repository;
  UpdateTicketStatusUseCase(this.repository);

  Future<SupportTicketEntity> call(int ticketId, String status) {
    return repository.updateStatus(ticketId, status);
  }
}

class UpdateTicketPriorityUseCase {
  final SupportRepository repository;
  UpdateTicketPriorityUseCase(this.repository);

  Future<SupportTicketEntity> call(int ticketId, String priority) {
    return repository.updatePriority(ticketId, priority);
  }
}

class AssignTicketAdminUseCase {
  final SupportRepository repository;
  AssignTicketAdminUseCase(this.repository);

  Future<SupportTicketEntity> call(int ticketId, int? adminId) {
    return repository.assignAdmin(ticketId, adminId);
  }
}

class DeleteSupportTicketUseCase {
  final SupportRepository repository;
  DeleteSupportTicketUseCase(this.repository);

  Future<void> call(int ticketId) {
    return repository.deleteTicket(ticketId);
  }
}

class GetSupportStatsUseCase {
  final SupportRepository repository;
  GetSupportStatsUseCase(this.repository);

  Future<SupportStatsEntity> call() {
    return repository.getStats();
  }
}
