import 'dart:async';
import 'package:flutter_riverpod/legacy.dart';
import 'package:stronger_muscles_dashboard/features/support/data/datasources/support_realtime_data_source.dart';
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
  final SupportRealtimeDataSource? _realtimeDataSource;
  final List<StreamSubscription> _streamSubscriptions = [];

  SupportChatNotifier({
    required GetTicketChatDetailUseCase getTicketDetailUseCase,
    required SendSupportChatMessageUseCase sendMessageUseCase,
    required UpdateSupportChatStatusUseCase updateStatusUseCase,
    required UpdateSupportChatPriorityUseCase updatePriorityUseCase,
    required AssignSupportChatAdminUseCase assignAdminUseCase,
    required DeleteSupportChatTicketUseCase deleteTicketUseCase,
    SupportRealtimeDataSource? realtimeDataSource,
  }) : _getTicketDetailUseCase = getTicketDetailUseCase,
       _sendMessageUseCase = sendMessageUseCase,
       _updateStatusUseCase = updateStatusUseCase,
       _updatePriorityUseCase = updatePriorityUseCase,
       _assignAdminUseCase = assignAdminUseCase,
       _deleteTicketUseCase = deleteTicketUseCase,
       _realtimeDataSource = realtimeDataSource,
       super(const SupportChatState()) {
    _setupRealtimeListeners();
  }

  void _setupRealtimeListeners() {
    if (_realtimeDataSource == null) return;

    _streamSubscriptions.add(
      _realtimeDataSource.onMessageSent.listen((event) {
        final ticketId = event.$1;
        final newMsg = event.$2;
        final currentTicket = state.ticket;
        if (currentTicket != null && currentTicket.id == ticketId) {
          final exists = currentTicket.messages.any((m) => m.id == newMsg.id);
          if (!exists) {
            final converted = SupportChatMessageEntity(
              id: newMsg.id,
              ticketId: newMsg.ticketId,
              senderId: newMsg.senderId ?? 0,
              senderName: newMsg.senderName,
              senderType: newMsg.senderType,
              message: newMsg.message,
              attachments: newMsg.attachments,
              isInternalNote: newMsg.isInternalNote,
              createdAt: newMsg.createdAt,
            );
            final updatedMessages = List<SupportChatMessageEntity>.from(currentTicket.messages);
            final optimisticIdx = updatedMessages.indexWhere(
              (m) => m.id < 0 && m.message == newMsg.message,
            );
            if (optimisticIdx != -1) {
              updatedMessages[optimisticIdx] = converted;
            } else {
              updatedMessages.add(converted);
            }
            state = state.copyWith(
              ticket: () => currentTicket.copyWith(
                messages: updatedMessages,
                messagesCount: optimisticIdx != -1
                    ? currentTicket.messagesCount
                    : currentTicket.messagesCount + 1,
              ),
            );
          }
        }
      }),
    );

    _streamSubscriptions.add(
      _realtimeDataSource.onTicketUpdated.listen((updatedTicket) {
        final currentTicket = state.ticket;
        if (currentTicket != null && currentTicket.id == updatedTicket.id) {
          state = state.copyWith(
            ticket: () => currentTicket.copyWith(
              status: updatedTicket.status,
              priority: updatedTicket.priority,
              assignedAdminId: updatedTicket.adminId,
              assignedAdminName: updatedTicket.adminName,
            ),
          );
        }
      }),
    );
  }

  @override
  void dispose() {
    for (final sub in _streamSubscriptions) {
      sub.cancel();
    }
    _streamSubscriptions.clear();
    super.dispose();
  }

  /// Loads ticket conversation by ID with optimistic placeholder support.
  Future<void> loadTicket(
    int ticketId, {
    SupportChatTicketEntity? initialTicket,
  }) async {
    final currentTicket = state.ticket;
    final validCurrent = currentTicket?.id == ticketId ? currentTicket : null;

    if (validCurrent != null && validCurrent.messages.isNotEmpty) {
      if (initialTicket != null &&
          initialTicket.messages.length > validCurrent.messages.length) {
        state = state.copyWith(ticket: () => initialTicket);
      }
      _silentRefresh(ticketId);
      return;
    }

    final placeholder =
        initialTicket ??
        validCurrent ??
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
      isLoading: placeholder.messages.isEmpty,
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
        final pending = state.ticket?.messages
                .where((m) => m.isOptimistic || m.isFailed)
                .toList() ??
            [];
        final merged = [...detailed.messages];
        for (final p in pending) {
          if (!merged.any((m) => m.id == p.id)) {
            merged.add(p);
          }
        }

        state = state.copyWith(
          isLoading: false,
          ticket: () => detailed.copyWith(messages: merged),
          errorMessage: () => null,
        );
      },
    );
  }

  Future<void> _silentRefresh(int ticketId) async {
    final result = await _getTicketDetailUseCase(ticketId);
    if (state.ticket?.id != ticketId) return;
    result.fold((_) => null, (detailed) {
      final pending = state.ticket?.messages
              .where((m) => m.isOptimistic || m.isFailed)
              .toList() ??
          [];
      final merged = [...detailed.messages];
      for (final p in pending) {
        if (!merged.any((m) => m.id == p.id)) {
          merged.add(p);
        }
      }
      state = state.copyWith(
        ticket: () => detailed.copyWith(messages: merged),
      );
    });
  }

  /// Sets an active ticket directly into state
  void setTicket(SupportChatTicketEntity? ticket) {
    state = state.copyWith(
      ticket: () => ticket,
      isLoading: ticket != null && ticket.messages.isEmpty,
      errorMessage: () => null,
    );
  }

  /// Synchronizes an externally updated ticket (e.g. from split-view parent)
  void syncInitialTicket(SupportChatTicketEntity initial) {
    final current = state.ticket;
    if (current == null || current.id != initial.id) {
      state = state.copyWith(
        ticket: () => initial,
        isLoading: initial.messages.isEmpty,
        errorMessage: () => null,
      );
    } else {
      final hasMoreMessages = initial.messages.length > current.messages.length;
      final statusChanged = initial.status != current.status ||
          initial.priority != current.priority ||
          initial.assignedAdminId != current.assignedAdminId;
      if (hasMoreMessages || statusChanged) {
        state = state.copyWith(
          ticket: () => initial,
          isLoading: false,
        );
      }
    }
  }

  /// Sends a reply message or internal supervisor note with Optimistic UI updates.
  Future<bool> sendReply({
    required String message,
    List<String>? attachments,
    int? retryMessageId,
  }) async {
    final ticket = state.ticket;
    final trimmed = message.trim();
    if (ticket == null || trimmed.isEmpty) {
      return false;
    }

    final isNote = state.isInternalNote;
    final requestedStatus = state.replyStatus;
    final tempId = retryMessageId ?? -DateTime.now().millisecondsSinceEpoch;

    // 1. Optimistic UI update: message appears on screen instantly or updates retry state
    final currentMessages = List<SupportChatMessageEntity>.from(ticket.messages);
    final existingIdx = currentMessages.indexWhere((m) => m.id == tempId);

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
      isFailed: false,
    );

    if (existingIdx != -1) {
      currentMessages[existingIdx] = optimisticMessage;
    } else {
      currentMessages.add(optimisticMessage);
    }

    final newStatus = requestedStatus ?? ticket.status;
    final optimisticTicket = ticket.copyWith(
      status: newStatus,
      messages: currentMessages,
      messagesCount: existingIdx == -1 ? ticket.messagesCount + 1 : ticket.messagesCount,
    );

    // Keep UI fully responsive without blocking typing or sending
    state = state.copyWith(
      isSendingReply: false,
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
        // Mark optimistic message as failed rather than deleting it
        final failedMessages = List<SupportChatMessageEntity>.from(
          state.ticket?.messages ?? [],
        );
        final fIdx = failedMessages.indexWhere((m) => m.id == tempId);
        if (fIdx != -1) {
          failedMessages[fIdx] = failedMessages[fIdx].copyWith(
            isOptimistic: false,
            isFailed: true,
          );
        }

        final failedTicket = (state.ticket ?? ticket).copyWith(
          messages: failedMessages,
        );

        state = state.copyWith(
          isSendingReply: false,
          ticket: () => failedTicket,
          errorMessage: () => 'فشل إرسال الرد: ${failure.message}. اضغط لإعادة المحاولة.',
        );
        return false;
      },
      (confirmedMessage) {
        // Replace optimistic placeholder with confirmed server message
        final confirmedMessages = List<SupportChatMessageEntity>.from(
          state.ticket?.messages ?? [],
        );
        final index = confirmedMessages.indexWhere((m) => m.id == tempId);

        if (index != -1) {
          confirmedMessages[index] = confirmedMessage;
        } else if (!confirmedMessages.any((m) => m.id == confirmedMessage.id)) {
          confirmedMessages.add(confirmedMessage);
        }

        final confirmedTicket = (state.ticket ?? ticket).copyWith(
          status: newStatus,
          messages: confirmedMessages,
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

  /// Retries sending a previously failed message
  Future<bool> retryMessage(SupportChatMessageEntity failedMessage) async {
    return sendReply(
      message: failedMessage.message,
      attachments: failedMessage.attachments,
      retryMessageId: failedMessage.id,
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
