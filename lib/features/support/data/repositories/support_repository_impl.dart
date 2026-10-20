import '../../domain/entities/support_message_entity.dart';
import '../../domain/entities/support_stats_entity.dart';
import '../../domain/entities/support_ticket_entity.dart';
import '../../domain/repositories/support_repository.dart';
import '../datasources/support_remote_data_source.dart';
import '../models/support_stats_model.dart';
import '../models/support_ticket_model.dart';

class SupportRepositoryImpl implements SupportRepository {
  final SupportRemoteDataSource remoteDataSource;

  SupportRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Map<String, dynamic>> getTickets({
    String? status,
    String? priority,
    String? category,
    String? search,
    int? adminId,
    int page = 1,
    int perPage = 15,
  }) async {
    final result = await remoteDataSource.getTickets(
      status: status,
      priority: priority,
      category: category,
      search: search,
      adminId: adminId,
      page: page,
      perPage: perPage,
    );

    final List<SupportTicketModel> models = result['tickets'] ?? [];
    final SupportStatsModel? statsModel = result['stats'];

    return {
      'tickets': models.map((m) => m.toEntity()).toList(),
      'stats': statsModel?.toEntity() ?? const SupportStatsEntity(),
    };
  }

  @override
  Future<SupportTicketEntity> getTicketDetail(int ticketId) async {
    final model = await remoteDataSource.getTicketDetail(ticketId);
    return model.toEntity();
  }

  @override
  Future<SupportMessageEntity> sendMessage({
    required int ticketId,
    required String message,
    bool isInternalNote = false,
    String? status,
    List<String>? attachments,
  }) async {
    final model = await remoteDataSource.sendMessage(
      ticketId: ticketId,
      message: message,
      isInternalNote: isInternalNote,
      status: status,
      attachments: attachments,
    );
    return model.toEntity();
  }

  @override
  Future<SupportTicketEntity> updateStatus(int ticketId, String status) async {
    final model = await remoteDataSource.updateStatus(ticketId, status);
    return model.toEntity();
  }

  @override
  Future<SupportTicketEntity> updatePriority(int ticketId, String priority) async {
    final model = await remoteDataSource.updatePriority(ticketId, priority);
    return model.toEntity();
  }

  @override
  Future<SupportTicketEntity> assignAdmin(int ticketId, int? adminId) async {
    final model = await remoteDataSource.assignAdmin(ticketId, adminId);
    return model.toEntity();
  }

  @override
  Future<void> deleteTicket(int ticketId) async {
    return await remoteDataSource.deleteTicket(ticketId);
  }

  @override
  Future<SupportStatsEntity> getStats() async {
    final model = await remoteDataSource.getStats();
    return model.toEntity();
  }
}
