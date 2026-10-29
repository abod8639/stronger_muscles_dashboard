import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/support_ticket_entity.dart';
import '../repositories/support_repository.dart';

/// Pure Dart UseCase to update the status of a support ticket.
class UpdateTicketStatusUseCase {
  final SupportRepository _repository;

  const UpdateTicketStatusUseCase(this._repository);

  Future<Either<Failure, SupportTicketEntity>> call(
    int ticketId,
    String status,
  ) {
    return _repository.updateStatus(ticketId, status);
  }
}
