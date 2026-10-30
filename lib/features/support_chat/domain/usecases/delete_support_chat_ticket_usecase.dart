import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../repositories/support_chat_repository.dart';

class DeleteSupportChatTicketUseCase {
  final SupportChatRepository repository;

  const DeleteSupportChatTicketUseCase(this.repository);

  Future<Either<Failure, void>> call(int ticketId) {
    return repository.deleteTicket(ticketId);
  }
}

