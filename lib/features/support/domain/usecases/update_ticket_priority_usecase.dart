import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/support_ticket_entity.dart';
import '../repositories/support_repository.dart';

/// Pure Dart UseCase to update the priority level of a support ticket.
class UpdateTicketPriorityUseCase {
  final SupportRepository _repository;

  const UpdateTicketPriorityUseCase(this._repository);

  Future<Either<Failure, SupportTicketEntity>> call(int ticketId, String priority) {
    return _repository.updatePriority(ticketId, priority);
  }
}
