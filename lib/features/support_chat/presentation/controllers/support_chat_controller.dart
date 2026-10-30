import 'package:flutter_riverpod/legacy.dart';
import '../../domain/entities/support_chat_message_entity.dart';
import '../../domain/entities/support_chat_ticket_entity.dart';
import '../../domain/usecases/assign_support_chat_admin_usecase.dart';
import '../../domain/usecases/delete_support_chat_ticket_usecase.dart';
import '../../domain/usecases/get_ticket_chat_detail_usecase.dart';
import '../../domain/usecases/send_support_chat_message_usecase.dart';
import '../../domain/usecases/update_support_chat_priority_usecase.dart';
import '../../domain/usecases/update_support_chat_status_usecase.dart';
import 'support_chat_state.dart';

class SupportChatNotifier extends StateNotifier<SupportChatState> {
  final GetTicketChatDetailUseCase _getTicketDetailUseCase;
  final SendSupportChatMessageUseCase _sendMessageUseCase;
  final UpdateSupportChatStatusUseCase _updateStatusUseCase;
  final UpdateSupportChatPriorityUseCase _updatePriorityUseCase;
  final AssignSupportChatAdminUseCase _assignAdminUseCase;
  final DeleteSupportChatTicketUseCase _deleteTicketUseCase;

  SupportChatNotifier({
    required GetTicketChatDetailUseCase getTicketDetailUseCase,
    required SendSupportChatMessageUseCase sendMessageUseCase,
    required UpdateSupportChatStatusUseCase updateStatusUseCase,
    required UpdateSupportChatPriorityUseCase updatePriorityUseCase,
    required AssignSupportChatAdminUseCase assignAdminUseCase,
    required DeleteSupportChatTicketUseCase deleteTicketUseCase,
  }) : _getTicketDetailUseCase = getTicketDetailUseCase,
       _sendMessageUseCase = sendMessageUseCase,
       _updateStatusUseCase = updateStatusUseCase,
       _updatePriorityUseCase = updatePriorityUseCase,
       _assignAdminUseCase = assignAdminUseCase,
       _deleteTicketUseCase = deleteTicketUseCase,
       super(const SupportChatState());

  /// Loads ticket conversation by ID with optimistic placeholder support.
  Future<void> loadTicket(
    int ticketId, {
    SupportChatTicketEntity? initialTicket,
  }) async {
    final currentTicket = state.ticket;
    if (currentTicket?.id == ticketId && currentTicket!.messages.isNotEmpty) {
      // Already loaded, just refresh silently in background
      _silentRefresh(ticketId);
      return;
    }

    final placeholder =
        initialTicket ??
        currentTicket ??
        SupportChatTicketEntity(
          id: ticketId,
          ticketNumber: 'SM-$ticketId',
          userName: 'العميل',
          userEmail: '',
          subject: 'تذكرة #$ticketId',
          category: 'عام',
          priority: 'normal',
          status: 'open',
          createdAt: DateTime.now(),
        );

    state = state.copyWith(
      ticket: () => placeholder,
      isLoading: true,
      errorMessage: () => null,
    );

    final result = await _getTicketDetailUseCase(ticketId);

    // Race condition guard: if another ticket was selected meanwhile, ignore
    if (state.ticket?.id != ticketId) return;

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: () => failure.message,
        );
      },
      (detailed) {
        state = state.copyWith(
          isLoading: false,
          ticket: () => detailed,
          errorMessage: () => null,
        );
      },
    );
  }

  Future<void> _silentRefresh(int ticketId) async {
    final result = await _getTicketDetailUseCase(ticketId);
    if (state.ticket?.id != ticketId) return;
    result.fold((_) => null, (detailed) {
      state = state.copyWith(ticket: () => detailed);
    });
  }

  /// Sets an active ticket directly into state
  void setTicket(SupportChatTicketEntity? ticket) {
    state = state.copyWith(
      ticket: () => ticket,
      errorMessage: () => null,
    );
  }

  /// Sends a reply message or internal supervisor note with Optimistic UI updates.
  Future<bool> sendReply({
    required String message,
    List<String>? attachments,
  }) async {
    final ticket = state.ticket;
    final trimmed = message.trim();
    if (ticket == null || trimmed.isEmpty || state.isSendingReply) {
      return false;
    }

    final isNote = state.isInternalNote;
    final requestedStatus = state.replyStatus;
    final tempId = -DateTime.now().millisecondsSinceEpoch;

    // 1. Optimistic UI update: message appears on screen instantly
    final optimisticMessage = SupportChatMessageEntity(
      id: tempId,
      ticketId: ticket.id,
      senderId: 0,
      senderName: isNote ? 'المشرف (ملاحظة)' : 'الدعم الفني',
      senderType: 'admin',
      message: trimmed,
      isInternalNote: isNote,
      attachments: attachments ?? const [],
      createdAt: DateTime.now(),
      isOptimistic: true,
    );

    final newStatus = requestedStatus ?? ticket.status;
    final optimisticTicket = ticket.copyWith(
      status: newStatus,
      messages: [...ticket.messages, optimisticMessage],
      messagesCount: ticket.messagesCount + 1,
    );

    state = state.copyWith(
      isSendingReply: true,
      ticket: () => optimisticTicket,
      isInternalNote: false,
      replyStatus: () => null,
      errorMessage: () => null,
    );

    // 2. Dispatch network call
    final result = await _sendMessageUseCase(
      ticketId: ticket.id,
      message: trimmed,
      isInternalNote: isNote,
      status: requestedStatus,
      attachments: attachments,
    );

    return result.fold(
      (failure) {
        // Rollback optimistic message on network error
        final rollbackMessages = List<SupportChatMessageEntity>.from(
          state.ticket?.messages ?? [],
        )..removeWhere((m) => m.id == tempId);

        final rollbackTicket = ticket.copyWith(
          messages: rollbackMessages,
          messagesCount: ticket.messagesCount,
        );

        state = state.copyWith(
          isSendingReply: false,
          ticket: () => rollbackTicket,
          errorMessage: () => 'فشل إرسال الرد: ${failure.message}',
        );
        return false;
      },
      (confirmedMessage) {
        // Replace optimistic placeholder with confirmed server message
        final currentMessages = List<SupportChatMessageEntity>.from(
          state.ticket?.messages ?? [],
        )..removeWhere((m) => m.id == tempId);

        if (!currentMessages.any((m) => m.id == confirmedMessage.id)) {
          currentMessages.add(confirmedMessage);
        }

        final confirmedTicket = (state.ticket ?? ticket).copyWith(
          status: newStatus,
          messages: currentMessages,
        );

        state = state.copyWith(
          isSendingReply: false,
          ticket: () => confirmedTicket,
          errorMessage: () => null,
        );
        return true;
      },
    );
  }

  /// Updates ticket status
  Future<void> updateStatus(String newStatus) async {
    final ticket = state.ticket;
    if (ticket == null || ticket.status == newStatus || state.isUpdating) {
      return;
    }

    state = state.copyWith(isUpdating: true, errorMessage: () => null);

    final result = await _updateStatusUseCase(ticket.id, newStatus);

    result.fold(
      (failure) {
        state = state.copyWith(
          isUpdating: false,
          errorMessage: () => 'تعذر تحديث الحالة: ${failure.message}',
        );
      },
      (updated) {
        state = state.copyWith(
          isUpdating: false,
          ticket: () => updated,
          successMessage: () =>
              'تم تحديث حالة التذكرة إلى: ${updated.statusArabic}',
        );
      },
    );
  }

  /// Updates ticket priority
  Future<void> updatePriority(String newPriority) async {
    final ticket = state.ticket;
    if (ticket == null || ticket.priority == newPriority || state.isUpdating) {
      return;
    }

    state = state.copyWith(isUpdating: true, errorMessage: () => null);

    final result = await _updatePriorityUseCase(ticket.id, newPriority);

    result.fold(
      (failure) {
        state = state.copyWith(
          isUpdating: false,
          errorMessage: () => 'تعذر تعديل الأولوية: ${failure.message}',
        );
      },
      (updated) {
        state = state.copyWith(
          isUpdating: false,
          ticket: () => updated,
          successMessage: () =>
              'تم تعديل الأولوية إلى: ${updated.priorityArabic}',
        );
      },
    );
  }

  /// Assigns an admin supervisor
  Future<void> assignAdmin(int? adminId) async {
    final ticket = state.ticket;
    if (ticket == null || state.isUpdating) return;

    state = state.copyWith(isUpdating: true, errorMessage: () => null);

    final result = await _assignAdminUseCase(ticket.id, adminId);

    result.fold(
      (failure) {
        state = state.copyWith(
          isUpdating: false,
          errorMessage: () => 'تعذر تعيين المشرف: ${failure.message}',
        );
      },
      (updated) {
        state = state.copyWith(
          isUpdating: false,
          ticket: () => updated,
          successMessage: () => 'تم تعيين المشرف المسؤول بنجاح',
        );
      },
    );
  }

  /// Deletes ticket
  Future<bool> deleteTicket() async {
    final ticket = state.ticket;
    if (ticket == null || state.isDeleting) return false;

    state = state.copyWith(isDeleting: true, errorMessage: () => null);

    final result = await _deleteTicketUseCase(ticket.id);

    return result.fold(
      (failure) {
        state = state.copyWith(
          isDeleting: false,
          errorMessage: () => 'فشل في حذف التذكرة: ${failure.message}',
        );
        return false;
      },
      (_) {
        state = state.copyWith(
          isDeleting: false,
          ticket: () => null,
          successMessage: () => 'تم حذف التذكرة بنجاح',
        );
        return true;
      },
    );
  }

  void toggleInternalNote() {
    state = state.copyWith(isInternalNote: !state.isInternalNote);
  }

  void setReplyStatus(String? status) {
    state = state.copyWith(replyStatus: () => status);
  }

  void clearMessages() {
    state = state.copyWith(
      errorMessage: () => null,
      successMessage: () => null,
    );
  }
}
