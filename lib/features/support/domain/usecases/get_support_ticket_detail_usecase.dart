import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/support_ticket_entity.dart';
import '../repositories/support_repository.dart';

/// Pure Dart UseCase to fetch detailed ticket metadata and conversation thread.
class GetSupportTicketDetailUseCase {
  final SupportRepository _repository;

  const GetSupportTicketDetailUseCase(this._repository);

  Future<Either<Failure, SupportTicketEntity>> call(int ticketId) {
    return _repository.getTicketDetail(ticketId);
  }
}
