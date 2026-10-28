import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../repositories/support_repository.dart';

/// Pure Dart UseCase to delete a support ticket.
class DeleteSupportTicketUseCase {
  final SupportRepository _repository;

  const DeleteSupportTicketUseCase(this._repository);

  Future<Either<Failure, Unit>> call(int ticketId) {
    return _repository.deleteTicket(ticketId);
  }
}
