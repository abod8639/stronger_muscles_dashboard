import 'package:flutter/foundation.dart';
import '../../domain/entities/support_chat_ticket_entity.dart';

@immutable
class SupportChatState {
  final SupportChatTicketEntity? ticket;
  final bool isLoading;
  final bool isSendingReply;
  final bool isUpdating;
  final bool isDeleting;
  final bool isInternalNote;
  final String? replyStatus;
  final String? errorMessage;
  final String? successMessage;
  final List<String> cannedResponses;

  const SupportChatState({
    this.ticket,
    this.isLoading = false,
    this.isSendingReply = false,
    this.isUpdating = false,
    this.isDeleting = false,
    this.isInternalNote = false,
    this.replyStatus,
    this.errorMessage,
    this.successMessage,
    this.cannedResponses = const [
      'أهلاً بك يا {{name}}، تم استلام استفسارك وجارٍ المتابعة من فريق الدعم.',
      'عزيزي {{name}}، تم التحقق من المشكلة بخصوص التذكرة {{ticket}} وحلها بنجاح.',
      'مرحباً {{name}}، بخصوص الطلب {{order}}، الشحنة في طريقها للتوصيل قريباً.',
      'يرجى التكرم بتزويدنا بصورة توضح المشكلة أو رقم بوليصة الشحن.',
      'تم تحويل البلاغ للقسم المختص وسنوافيك بالتفاصيل في أقرب وقت.',
      'نشكر تواصلك معنا ويسعدنا دائماً خدمتك يا {{name}}!',
    ],
  });

  SupportChatState copyWith({
    SupportChatTicketEntity? Function()? ticket,
    bool? isLoading,
    bool? isSendingReply,
    bool? isUpdating,
    bool? isDeleting,
    bool? isInternalNote,
    String? Function()? replyStatus,
    String? Function()? errorMessage,
    String? Function()? successMessage,
    List<String>? cannedResponses,
  }) {
    return SupportChatState(
      ticket: ticket != null ? ticket() : this.ticket,
      isLoading: isLoading ?? this.isLoading,
      isSendingReply: isSendingReply ?? this.isSendingReply,
      isUpdating: isUpdating ?? this.isUpdating,
      isDeleting: isDeleting ?? this.isDeleting,
      isInternalNote: isInternalNote ?? this.isInternalNote,
      replyStatus: replyStatus != null ? replyStatus() : this.replyStatus,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      successMessage:
          successMessage != null ? successMessage() : this.successMessage,
      cannedResponses: cannedResponses ?? this.cannedResponses,
    );
  }
}

