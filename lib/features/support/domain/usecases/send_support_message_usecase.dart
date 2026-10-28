import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/support_message_entity.dart';
import '../repositories/support_repository.dart';

/// Pure Dart UseCase to send a reply or internal note for a ticket.
class SendSupportMessageUseCase {
  final SupportRepository _repository;

  const SendSupportMessageUseCase(this._repository);

  Future<Either<Failure, SupportMessageEntity>> call({
    required int ticketId,
    required String message,
    bool isInternalNote = false,
    String? status,
    List<String>? attachments,
  }) {
    return _repository.sendMessage(
      ticketId: ticketId,
      message: message,
      isInternalNote: isInternalNote,
      status: status,
      attachments: attachments,
    );
  }
}
