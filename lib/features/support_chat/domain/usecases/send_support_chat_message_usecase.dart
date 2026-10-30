import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import '../entities/support_chat_message_entity.dart';
import '../repositories/support_chat_repository.dart';

class SendSupportChatMessageUseCase {
  final SupportChatRepository repository;

  const SendSupportChatMessageUseCase(this.repository);

  Future<Either<Failure, SupportChatMessageEntity>> call({
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

