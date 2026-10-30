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
      'أهلاً بك، تم استلام استفسارك وجارٍ المتابعة.',
      'تم حل المشكلة وتحديث الطلب بنجاح.',
      'يرجى تزويدنا بصورة للمنتج أو تفاصيل إضافية.',
      'تم تحويل المشكلة للقسم المختص وسنوافيك بالرد قريباً.',
      'نشكر تواصلك معنا ويسعدنا دائماً خدمتك.',
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

