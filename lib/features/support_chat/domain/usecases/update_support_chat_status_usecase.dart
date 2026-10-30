import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/support_chat_ticket_entity.dart';
import '../repositories/support_chat_repository.dart';

class UpdateSupportChatStatusUseCase {
  final SupportChatRepository repository;

  const UpdateSupportChatStatusUseCase(this.repository);

  Future<Either<Failure, SupportChatTicketEntity>> call(
    int ticketId,
    String status,
  ) {
    return repository.updateStatus(ticketId, status);
  }
}

