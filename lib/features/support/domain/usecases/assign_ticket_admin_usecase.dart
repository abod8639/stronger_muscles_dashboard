import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/support_ticket_entity.dart';
import '../repositories/support_repository.dart';

/// Pure Dart UseCase to assign an admin to a support ticket.
class AssignTicketAdminUseCase {
  final SupportRepository _repository;

  const AssignTicketAdminUseCase(this._repository);

  Future<Either<Failure, SupportTicketEntity>> call(
    int ticketId,
    int? adminId,
  ) {
    return _repository.assignAdmin(ticketId, adminId);
  }
}
