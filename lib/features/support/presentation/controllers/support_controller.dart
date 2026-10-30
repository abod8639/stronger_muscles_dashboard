import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/support_message_entity.dart';
import '../../domain/entities/support_ticket_entity.dart';
import '../../domain/repositories/support_repository.dart';
import '../../domain/usecases/assign_ticket_admin_usecase.dart';
import '../../domain/usecases/delete_support_ticket_usecase.dart';
import '../../domain/usecases/get_support_stats_usecase.dart';
import '../../domain/usecases/get_support_ticket_detail_usecase.dart';
import '../../domain/usecases/get_support_tickets_usecase.dart';
import '../../domain/usecases/send_support_message_usecase.dart';
import '../../domain/usecases/update_ticket_priority_usecase.dart';
import '../../domain/usecases/update_ticket_status_usecase.dart';
import 'support_providers.dart';
import 'support_state.dart';

/// Riverpod StateNotifier controlling Support tickets, conversation threads, and metrics.
/// Enforces:
/// - Immutable [SupportState]
/// - Zero try-catch blocks (uses functional Either error handling)
/// - Strict guard clauses against duplicate mutations
/// - Search debouncing and realtime stream lifecycle management
class SupportNotifier extends Notifier<SupportState> {
  final GetSupportTicketsUseCase? _customGetTicketsUseCase;
  final GetSupportTicketDetailUseCase? _customGetTicketDetailUseCase;
  final SendSupportMessageUseCase? _customSendMessageUseCase;
  final UpdateTicketStatusUseCase? _customUpdateStatusUseCase;
  final UpdateTicketPriorityUseCase? _customUpdatePriorityUseCase;
  final AssignTicketAdminUseCase? _customAssignAdminUseCase;
  final DeleteSupportTicketUseCase? _customDeleteTicketUseCase;
  final GetSupportStatsUseCase? _customGetStatsUseCase;
  final SupportRepository? _customRepository;

  SupportNotifier({
    GetSupportTicketsUseCase? getTicketsUseCase,
    GetSupportTicketDetailUseCase? getTicketDetailUseCase,
    SendSupportMessageUseCase? sendMessageUseCase,
    UpdateTicketStatusUseCase? updateStatusUseCase,
    UpdateTicketPriorityUseCase? updatePriorityUseCase,
    AssignTicketAdminUseCase? assignAdminUseCase,
    DeleteSupportTicketUseCase? deleteTicketUseCase,
    GetSupportStatsUseCase? getStatsUseCase,
    SupportRepository? repository,
  }) : _customGetTicketsUseCase = getTicketsUseCase,
       _customGetTicketDetailUseCase = getTicketDetailUseCase,
       _customSendMessageUseCase = sendMessageUseCase,
       _customUpdateStatusUseCase = updateStatusUseCase,
       _customUpdatePriorityUseCase = updatePriorityUseCase,
       _customAssignAdminUseCase = assignAdminUseCase,
       _customDeleteTicketUseCase = deleteTicketUseCase,
       _customGetStatsUseCase = getStatsUseCase,
       _customRepository = repository;

  GetSupportTicketsUseCase get _getTickets =>
      _customGetTicketsUseCase ?? ref.read(getSupportTicketsUseCaseProvider);
  GetSupportTicketDetailUseCase get _getTicketDetail =>
      _customGetTicketDetailUseCase ??
      ref.read(getSupportTicketDetailUseCaseProvider);
  SendSupportMessageUseCase get _sendMessage =>
      _customSendMessageUseCase ?? ref.read(sendSupportMessageUseCaseProvider);
  UpdateTicketStatusUseCase get _updateStatus =>
      _customUpdateStatusUseCase ?? ref.read(updateTicketStatusUseCaseProvider);
  UpdateTicketPriorityUseCase get _updatePriority =>
      _customUpdatePriorityUseCase ??
      ref.read(updateTicketPriorityUseCaseProvider);
  AssignTicketAdminUseCase get _assignAdmin =>
      _customAssignAdminUseCase ?? ref.read(assignTicketAdminUseCaseProvider);
  DeleteSupportTicketUseCase get _deleteTicket =>
      _customDeleteTicketUseCase ??
      ref.read(deleteSupportTicketUseCaseProvider);
  GetSupportStatsUseCase get _getStats =>
      _customGetStatsUseCase ?? ref.read(getSupportStatsUseCaseProvider);
  SupportRepository get _repo =>
      _customRepository ?? ref.read(supportRepositoryProvider);

  Timer? _searchDebounce;
  final List<StreamSubscription> _streamSubscriptions = [];

  static const List<String> cannedResponses = [
    'أهلاً بك، شكراً لتواصلك مع Stronger Muscles. جاري متابعة استفسارك وسنوافيك بالتفاصيل في أقرب وقت.',
    'تم التحقق من المشكلة وحلها بنجاح. نتمنى لك تجربة رياضية وصحية مميزة دائماً!',
    'تم التواصل مع فريق التوصيل والشحن، شحنتك في طريقها إليك وستصلك خلال الموعد المحدد.',
    'نعتذر بشدة عن التأخير أو الخلل غير المقصود، يسعدنا تقديم استبدال فوري أو تعويضك.',
    'يرجى التكرم بتزويدنا برقم الطلب وصورة توضح المشكلة لنتمكن من خدمتك بأفضل شكل.',
  ];

  @override
  SupportState build() {
    ref.onDispose(() {
      _searchDebounce?.cancel();
      for (final sub in _streamSubscriptions) {
        sub.cancel();
      }
      _streamSubscriptions.clear();
    });

    _listenToRealtimeEvents();

    Future.microtask(() => fetchTickets());

    return const SupportState(isLoading: true);
  }

  void _listenToRealtimeEvents() {
    _streamSubscriptions.add(
      _repo.ticketCreatedStream.listen((ticket) {
        final existingIndex = state.tickets.indexWhere(
          (t) => t.id == ticket.id,
        );
        List<SupportTicketEntity> updatedTickets;
        if (existingIndex == -1) {
          updatedTickets = [ticket, ...state.tickets];
        } else {
          updatedTickets = List.from(state.tickets);
          updatedTickets[existingIndex] = ticket;
        }

        final updatedFiltered = _applyLocalFilters(
          updatedTickets,
          state.selectedStatus,
          state.selectedPriority,
          state.selectedCategory,
          state.searchQuery,
        );

        state = state.copyWith(
          tickets: updatedTickets,
          filteredTickets: updatedFiltered,
        );
      }),
    );

    _streamSubscriptions.add(
      _repo.ticketUpdatedStream.listen((updatedTicket) {
        final index = state.tickets.indexWhere((t) => t.id == updatedTicket.id);
        if (index != -1) {
          final updatedTickets = List<SupportTicketEntity>.from(state.tickets);
          updatedTickets[index] = updatedTicket;

          final updatedFiltered = _applyLocalFilters(
            updatedTickets,
            state.selectedStatus,
            state.selectedPriority,
            state.selectedCategory,
            state.searchQuery,
          );

          SupportTicketEntity? updatedSelected = state.selectedTicket;
          if (state.selectedTicket?.id == updatedTicket.id) {
            updatedSelected = updatedTicket.copyWith(
              messages: updatedTicket.messages.isNotEmpty
                  ? updatedTicket.messages
                  : state.selectedTicket!.messages,
            );
          }

          state = state.copyWith(
            tickets: updatedTickets,
            filteredTickets: updatedFiltered,
            selectedTicket: () => updatedSelected,
          );
        }
      }),
    );

    _streamSubscriptions.add(
      _repo.messageSentStream.listen((event) {
        final ticketId = event.$1;
        final newMsg = event.$2;

        if (state.selectedTicket != null &&
            state.selectedTicket!.id == ticketId) {
          final exists = state.selectedTicket!.messages.any(
            (m) => m.id == newMsg.id,
          );
          if (!exists) {
            final updatedMessages = List<SupportMessageEntity>.from(
              state.selectedTicket!.messages,
            )..add(newMsg);
            final updatedSelected = state.selectedTicket!.copyWith(
              messages: updatedMessages,
              messagesCount: state.selectedTicket!.messagesCount + 1,
              lastReplyAt: newMsg.createdAt,
              latestMessage: newMsg,
            );
            state = state.copyWith(selectedTicket: () => updatedSelected);
          }
        }

        final tIndex = state.tickets.indexWhere((t) => t.id == ticketId);
        if (tIndex != -1) {
          final current = state.tickets[tIndex];
          final updated = current.copyWith(
            messagesCount: current.messagesCount + 1,
            lastReplyAt: newMsg.createdAt,
            latestMessage: newMsg,
          );
          final updatedTickets = List<SupportTicketEntity>.from(state.tickets);
          updatedTickets[tIndex] = updated;

          final updatedFiltered = _applyLocalFilters(
            updatedTickets,
            state.selectedStatus,
            state.selectedPriority,
            state.selectedCategory,
            state.searchQuery,
          );

          state = state.copyWith(
            tickets: updatedTickets,
            filteredTickets: updatedFiltered,
          );
        }
      }),
    );
  }

  List<SupportTicketEntity> _applyLocalFilters(
    List<SupportTicketEntity> source,
    String status,
    String priority,
    String category,
    String query,
  ) {
    return source.where((ticket) {
      if (status != 'all' && ticket.status != status) return false;
      if (priority != 'all' && ticket.priority != priority) return false;
      if (category != 'all' && ticket.category != category) return false;
      if (query.trim().isNotEmpty) {
        final q = query.trim().toLowerCase();
        final matchSubject = ticket.subject.toLowerCase().contains(q);
        final matchUser = ticket.userName.toLowerCase().contains(q);
        final matchNumber = ticket.ticketNumber.toLowerCase().contains(q);
        if (!matchSubject && !matchUser && !matchNumber) return false;
      }
      return true;
    }).toList();
  }

  Future<void> fetchTickets({bool showLoading = true}) async {
    if (showLoading) {
      state = state.copyWith(isLoading: true, errorMessage: () => null);
    }

    final result = await _getTickets(
      status: state.selectedStatus,
      priority: state.selectedPriority,
      category: state.selectedCategory,
      search: state.searchQuery,
      page: 1,
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: () => failure.message,
        );
      },
      (page) {
        final filtered = _applyLocalFilters(
          page.tickets,
          state.selectedStatus,
          state.selectedPriority,
          state.selectedCategory,
          state.searchQuery,
        );

        SupportTicketEntity? selected = state.selectedTicket;
        if (selected == null && page.tickets.isNotEmpty) {
          selected = page.tickets.first;
        } else if (selected != null) {
          final exists = page.tickets
              .where((t) => t.id == selected!.id)
              .firstOrNull;
          if (exists != null) {
            selected = exists.copyWith(
              messages: selected.messages.isNotEmpty
                  ? selected.messages
                  : exists.messages,
            );
          }
        }

        state = state.copyWith(
          isLoading: false,
          tickets: page.tickets,
          filteredTickets: filtered,
          stats: page.stats,
          currentPage: page.currentPage,
          hasMore: page.hasMore,
          selectedTicket: () => selected,
          errorMessage: () => null,
        );

        if (selected != null && selected.messages.isEmpty) {
          selectTicket(selected);
        }
      },
    );
  }

  Future<void> loadMoreTickets() async {
    if (state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true);

    final nextPage = state.currentPage + 1;
    final result = await _getTickets(
      status: state.selectedStatus,
      priority: state.selectedPriority,
      category: state.selectedCategory,
      search: state.searchQuery,
      page: nextPage,
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoadingMore: false,
          errorMessage: () => failure.message,
        );
      },
      (page) {
        final combined = [...state.tickets, ...page.tickets];
        final filtered = _applyLocalFilters(
          combined,
          state.selectedStatus,
          state.selectedPriority,
          state.selectedCategory,
          state.searchQuery,
        );

        state = state.copyWith(
          isLoadingMore: false,
          tickets: combined,
          filteredTickets: filtered,
          currentPage: page.currentPage,
          hasMore: page.hasMore,
          errorMessage: () => null,
        );
      },
    );
  }

  Future<void> fetchStats() async {
    final result = await _getStats();
    result.fold(
      (failure) => null,
      (stats) => state = state.copyWith(stats: stats),
    );
  }

  Future<void> selectTicket(SupportTicketEntity ticket) async {
    state = state.copyWith(
      selectedTicket: () => ticket,
      isLoadingDetail: true,
      errorMessage: () => null,
    );

    final result = await _getTicketDetail(ticket.id);

    // Guard against race condition if user selected another ticket while fetching
    if (state.selectedTicket?.id != ticket.id) return;

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoadingDetail: false,
          errorMessage: () => failure.message,
        );
      },
      (detailed) {
        final index = state.tickets.indexWhere((t) => t.id == ticket.id);
        List<SupportTicketEntity> updatedTickets = state.tickets;
        if (index != -1) {
          updatedTickets = List.from(state.tickets);
          updatedTickets[index] = detailed;
        }

        final filtered = _applyLocalFilters(
          updatedTickets,
          state.selectedStatus,
          state.selectedPriority,
          state.selectedCategory,
          state.searchQuery,
        );

        state = state.copyWith(
          isLoadingDetail: false,
          selectedTicket: () => detailed,
          tickets: updatedTickets,
          filteredTickets: filtered,
          errorMessage: () => null,
        );
      },
    );
  }

  Future<void> selectTicketById(
    int ticketId, {
    String? ticketNumber,
    String? subject,
    String? userName,
    String? userEmail,
  }) async {
    // Reset filters so the selected ticket is visible and not filtered out
    state = state.copyWith(
      selectedStatus: 'all',
      selectedPriority: 'all',
      selectedCategory: 'all',
      searchQuery: '',
      filteredTickets: state.tickets,
    );

    // 1. If already present in current tickets list, reuse it
    final existing = state.tickets.where((t) => t.id == ticketId).firstOrNull;
    if (existing != null) {
      await selectTicket(existing);
      return;
    }

    // 2. Set temporary placeholder so UI (both desktop and mobile) immediately transitions
    final placeholder = SupportTicketEntity(
      id: ticketId,
      ticketNumber: ticketNumber ?? '$ticketId',
      userName: userName ?? 'المستخدم',
      userEmail: userEmail ?? '',
      subject: subject ?? 'تذكرة الدعم #$ticketId',
      category: 'عام',
      createdAt: DateTime.now(),
      status: 'open',
      priority: 'normal',
    );

    state = state.copyWith(
      selectedTicket: () => placeholder,
      isLoadingDetail: true,
      errorMessage: () => null,
    );

    final result = await _getTicketDetail(ticketId);

    // Guard against race condition if user selected another ticket while fetching
    if (state.selectedTicket?.id != ticketId) return;

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoadingDetail: false,
          errorMessage: () => failure.message,
        );
      },
      (detailed) {
        final index = state.tickets.indexWhere((t) => t.id == ticketId);
        List<SupportTicketEntity> updatedTickets = List.from(state.tickets);
        if (index != -1) {
          updatedTickets[index] = detailed;
        } else {
          updatedTickets.insert(0, detailed);
        }

        final filtered = _applyLocalFilters(
          updatedTickets,
          state.selectedStatus,
          state.selectedPriority,
          state.selectedCategory,
          state.searchQuery,
        );

        state = state.copyWith(
          isLoadingDetail: false,
          selectedTicket: () => detailed,
          tickets: updatedTickets,
          filteredTickets: filtered,
          errorMessage: () => null,
        );
      },
    );
  }

  void setSelectedTicket(SupportTicketEntity? ticket) {
    state = state.copyWith(selectedTicket: () => ticket);
  }

  void updateSelectedStatus(String status) {
    state = state.copyWith(selectedStatus: status);
    fetchTickets(showLoading: false);
  }

  void updateSelectedPriority(String priority) {
    state = state.copyWith(selectedPriority: priority);
    fetchTickets(showLoading: false);
  }

  void updateSelectedCategory(String category) {
    state = state.copyWith(selectedCategory: category);
    fetchTickets(showLoading: false);
  }

  void onSearchChanged(String query) {
    state = state.copyWith(searchQuery: query);
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      fetchTickets(showLoading: false);
    });
  }

  void setInternalNote(bool val) {
    state = state.copyWith(isInternalNote: val);
  }

  void setReplyStatus(String val) {
    state = state.copyWith(replyStatus: val);
  }

  Future<bool> sendReply(String text) async {
    final ticket = state.selectedTicket;
    if (ticket == null || state.isSendingReply) return false;

    final messageText = text.trim();
    if (messageText.isEmpty) {
      state = state.copyWith(errorMessage: () => 'يرجى كتابة نص الرسالة أولاً');
      return false;
    }

    // 1. Generate unique temporary negative ID for optimistic update
    final tempId = -DateTime.now().millisecondsSinceEpoch;
    final now = DateTime.now();
    final newStatus = state.isInternalNote ? ticket.status : state.replyStatus;

    final optimisticMsg = SupportMessageEntity(
      id: tempId,
      ticketId: ticket.id,
      senderType: 'admin',
      senderName: ticket.adminName ?? 'أنت (الدعم الفني)',
      message: messageText,
      isInternalNote: state.isInternalNote,
      isRead: true,
      createdAt: now,
    );

    // 2. Immediately update local state with optimistic message (zero UI lag)
    final optimisticMessages = List<SupportMessageEntity>.from(ticket.messages)
      ..add(optimisticMsg);

    final optimisticTicket = ticket.copyWith(
      status: newStatus,
      messages: optimisticMessages,
      messagesCount: ticket.messagesCount + 1,
      unreadMessagesCount: 0,
      lastReplyAt: now,
      resolvedAt: newStatus == 'resolved' ? now : ticket.resolvedAt,
      closedAt: newStatus == 'closed' ? now : ticket.closedAt,
    );

    final ticketIndex = state.tickets.indexWhere((t) => t.id == ticket.id);
    List<SupportTicketEntity> optimisticTickets = state.tickets;
    if (ticketIndex != -1) {
      optimisticTickets = List.from(state.tickets);
      optimisticTickets[ticketIndex] = optimisticTicket;
    }

    final optimisticFiltered = _applyLocalFilters(
      optimisticTickets,
      state.selectedStatus,
      state.selectedPriority,
      state.selectedCategory,
      state.searchQuery,
    );

    state = state.copyWith(
      isSendingReply: true,
      selectedTicket: () => optimisticTicket,
      tickets: optimisticTickets,
      filteredTickets: optimisticFiltered,
      errorMessage: () => null,
    );

    // 3. Dispatch actual network request in background
    final result = await _sendMessage(
      ticketId: ticket.id,
      message: messageText,
      isInternalNote: state.isInternalNote,
      status: state.isInternalNote ? null : state.replyStatus,
    );

    return result.fold(
      (failure) {
        // Rollback optimistic message upon failure
        final rollbackMessages = List<SupportMessageEntity>.from(
          state.selectedTicket?.messages ?? ticket.messages,
        )..removeWhere((m) => m.id == tempId);

        final rollbackTicket = (state.selectedTicket ?? ticket).copyWith(
          messages: rollbackMessages,
          messagesCount: ticket.messagesCount,
        );

        final idx = state.tickets.indexWhere((t) => t.id == ticket.id);
        List<SupportTicketEntity> rollbackTickets = state.tickets;
        if (idx != -1) {
          rollbackTickets = List.from(state.tickets);
          rollbackTickets[idx] = rollbackTicket;
        }

        final rollbackFiltered = _applyLocalFilters(
          rollbackTickets,
          state.selectedStatus,
          state.selectedPriority,
          state.selectedCategory,
          state.searchQuery,
        );

        state = state.copyWith(
          isSendingReply: false,
          selectedTicket: () => rollbackTicket,
          tickets: rollbackTickets,
          filteredTickets: rollbackFiltered,
          errorMessage: () => 'فشل في إرسال الرد: ${failure.message}',
        );
        return false;
      },
      (newMsg) {
        // Replace optimistic message with confirmed entity from server
        final currentSelected = state.selectedTicket ?? optimisticTicket;
        final confirmedMessages =
            List<SupportMessageEntity>.from(currentSelected.messages)
              ..removeWhere((m) => m.id == tempId);

        // Guard against duplicate if WebSocket already appended it
        if (!confirmedMessages.any((m) => m.id == newMsg.id)) {
          confirmedMessages.add(newMsg);
        }

        final confirmedTicket = currentSelected.copyWith(
          status: newStatus,
          messages: confirmedMessages,
          latestMessage: newMsg,
        );

        final idx = state.tickets.indexWhere((t) => t.id == ticket.id);
        List<SupportTicketEntity> confirmedTickets = state.tickets;
        if (idx != -1) {
          confirmedTickets = List.from(state.tickets);
          confirmedTickets[idx] = confirmedTicket;
        }

        final confirmedFiltered = _applyLocalFilters(
          confirmedTickets,
          state.selectedStatus,
          state.selectedPriority,
          state.selectedCategory,
          state.searchQuery,
        );

        state = state.copyWith(
          isSendingReply: false,
          selectedTicket: () => confirmedTicket,
          tickets: confirmedTickets,
          filteredTickets: confirmedFiltered,
          errorMessage: () => null,
        );

        // Refresh stats silently without blocking or refetching all tickets
        fetchStats();
        return true;
      },
    );
  }

  Future<void> updateTicketStatus(String newStatus) async {
    final ticket = state.selectedTicket;
    if (ticket == null || ticket.status == newStatus || state.isUpdating) {
      return;
    }

    state = state.copyWith(isUpdating: true, errorMessage: () => null);

    final result = await _updateStatus(ticket.id, newStatus);

    result.fold(
      (failure) {
        state = state.copyWith(
          isUpdating: false,
          errorMessage: () => 'تعذر تحديث الحالة: ${failure.message}',
        );
      },
      (updated) {
        final index = state.tickets.indexWhere((t) => t.id == ticket.id);
        List<SupportTicketEntity> updatedTickets = state.tickets;
        if (index != -1) {
          updatedTickets = List.from(state.tickets);
          updatedTickets[index] = updated;
        }

        final filtered = _applyLocalFilters(
          updatedTickets,
          state.selectedStatus,
          state.selectedPriority,
          state.selectedCategory,
          state.searchQuery,
        );

        state = state.copyWith(
          isUpdating: false,
          selectedTicket: () => updated,
          tickets: updatedTickets,
          filteredTickets: filtered,
          successMessage: () =>
              'تم تغيير حالة التذكرة إلى: ${updated.statusArabic}',
        );

        fetchTickets(showLoading: false);
      },
    );
  }

  Future<void> updateTicketPriority(String newPriority) async {
    final ticket = state.selectedTicket;
    if (ticket == null || ticket.priority == newPriority || state.isUpdating) {
      return;
    }

    state = state.copyWith(isUpdating: true, errorMessage: () => null);

    final result = await _updatePriority(ticket.id, newPriority);

    result.fold(
      (failure) {
        state = state.copyWith(
          isUpdating: false,
          errorMessage: () => 'تعذر تعديل الأولوية: ${failure.message}',
        );
      },
      (updated) {
        final index = state.tickets.indexWhere((t) => t.id == ticket.id);
        List<SupportTicketEntity> updatedTickets = state.tickets;
        if (index != -1) {
          updatedTickets = List.from(state.tickets);
          updatedTickets[index] = updated;
        }

        final filtered = _applyLocalFilters(
          updatedTickets,
          state.selectedStatus,
          state.selectedPriority,
          state.selectedCategory,
          state.searchQuery,
        );

        state = state.copyWith(
          isUpdating: false,
          selectedTicket: () => updated,
          tickets: updatedTickets,
          filteredTickets: filtered,
          successMessage: () =>
              'تم تعديل الأولوية إلى: ${updated.priorityArabic}',
        );

        fetchTickets(showLoading: false);
      },
    );
  }

  Future<void> assignTicketAdmin(int? adminId) async {
    final ticket = state.selectedTicket;
    if (ticket == null || state.isUpdating) return;

    state = state.copyWith(isUpdating: true, errorMessage: () => null);

    final result = await _assignAdmin(ticket.id, adminId);

    result.fold(
      (failure) {
        state = state.copyWith(
          isUpdating: false,
          errorMessage: () => 'تعذر تعيين المشرف: ${failure.message}',
        );
      },
      (updated) {
        final index = state.tickets.indexWhere((t) => t.id == ticket.id);
        List<SupportTicketEntity> updatedTickets = state.tickets;
        if (index != -1) {
          updatedTickets = List.from(state.tickets);
          updatedTickets[index] = updated;
        }

        final filtered = _applyLocalFilters(
          updatedTickets,
          state.selectedStatus,
          state.selectedPriority,
          state.selectedCategory,
          state.searchQuery,
        );

        state = state.copyWith(
          isUpdating: false,
          selectedTicket: () => updated,
          tickets: updatedTickets,
          filteredTickets: filtered,
          successMessage: () => 'تم تعيين المشرف المسؤول بنجاح',
        );

        fetchTickets(showLoading: false);
      },
    );
  }

  Future<void> deleteTicket(int ticketId) async {
    if (state.isDeleting) return;

    state = state.copyWith(isDeleting: true, errorMessage: () => null);

    final result = await _deleteTicket(ticketId);

    result.fold(
      (failure) {
        state = state.copyWith(
          isDeleting: false,
          errorMessage: () => 'تعذر حذف التذكرة: ${failure.message}',
        );
      },
      (_) {
        final updatedTickets = state.tickets
            .where((t) => t.id != ticketId)
            .toList();
        final filtered = _applyLocalFilters(
          updatedTickets,
          state.selectedStatus,
          state.selectedPriority,
          state.selectedCategory,
          state.searchQuery,
        );

        SupportTicketEntity? nextSelected;
        if (state.selectedTicket?.id == ticketId) {
          nextSelected = filtered.isNotEmpty ? filtered.first : null;
        } else {
          nextSelected = state.selectedTicket;
        }

        state = state.copyWith(
          isDeleting: false,
          tickets: updatedTickets,
          filteredTickets: filtered,
          selectedTicket: () => nextSelected,
          successMessage: () => 'تم حذف التذكرة بنجاح',
        );

        fetchTickets(showLoading: false);
      },
    );
  }

  void clearMessages() {
    state = state.copyWith(
      errorMessage: () => null,
      successMessage: () => null,
    );
  }
}
