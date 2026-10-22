import 'dart:async';
import 'package:dart_pusher_channels/dart_pusher_channels.dart';
import 'package:flutter/material.dart';
import '../../../../config/api_config.dart';
import '../../../../core/utils/ui_feedback.dart';
import '../../data/models/support_message_model.dart';
import '../../data/models/support_ticket_model.dart';
import '../../domain/entities/support_message_entity.dart';
import '../../domain/entities/support_stats_entity.dart';
import '../../domain/entities/support_ticket_entity.dart';
import '../../domain/usecases/support_usecases.dart';

class SupportController extends ChangeNotifier {
  final GetSupportTicketsUseCase getTicketsUseCase;
  final GetSupportTicketDetailUseCase getTicketDetailUseCase;
  final SendSupportMessageUseCase sendMessageUseCase;
  final UpdateTicketStatusUseCase updateStatusUseCase;
  final UpdateTicketPriorityUseCase updatePriorityUseCase;
  final AssignTicketAdminUseCase assignAdminUseCase;
  final DeleteSupportTicketUseCase deleteTicketUseCase;
  final GetSupportStatsUseCase getStatsUseCase;

  SupportController({
    required this.getTicketsUseCase,
    required this.getTicketDetailUseCase,
    required this.sendMessageUseCase,
    required this.updateStatusUseCase,
    required this.updatePriorityUseCase,
    required this.assignAdminUseCase,
    required this.deleteTicketUseCase,
    required this.getStatsUseCase,
  }) {
    fetchTickets();
    _initRealtimeWebSockets();
  }

  // State
  List<SupportTicketEntity> tickets = [];
  List<SupportTicketEntity> filteredTickets = [];
  SupportTicketEntity? selectedTicket;
  SupportStatsEntity stats = const SupportStatsEntity();

  bool isLoading = true;
  bool isLoadingDetail = false;
  bool isSendingReply = false;
  bool isUpdating = false;

  // Filters
  String selectedStatus = 'all';
  String selectedPriority = 'all';
  String selectedCategory = 'all';
  String searchQuery = '';

  // Reply Composer
  final replyController = TextEditingController();
  bool isInternalNote = false;
  String replyStatus = 'waiting_user';

  // WebSockets Client & Subscriptions
  PusherChannelsClient? _pusherClient;
  PublicChannel? _supportChannel;
  final List<StreamSubscription> _wsSubscriptions = [];
  Timer? _searchDebounce;

  // Canned Responses
  final List<String> cannedResponses = const [
    'أهلاً بك، شكراً لتواصلك مع Stronger Muscles. جاري متابعة استفسارك وسنوافيك بالتفاصيل في أقرب وقت.',
    'تم التحقق من المشكلة وحلها بنجاح. نتمنى لك تجربة رياضية وصحية مميزة دائماً!',
    'تم التواصل مع فريق التوصيل والشحن، شحنتك في طريقها إليك وستصلك خلال الموعد المحدد.',
    'نعتذر بشدة عن التأخير أو الخلل غير المقصود، يسعدنا تقديم استبدال فوري أو تعويضك.',
    'يرجى التكرم بتزويدنا برقم الطلب وصورة توضح المشكلة لنتمكن من خدمتك بأفضل شكل.',
  ];

  @override
  void dispose() {
    _searchDebounce?.cancel();
    for (final sub in _wsSubscriptions) {
      sub.cancel();
    }
    _wsSubscriptions.clear();
    _supportChannel?.unsubscribe();
    _pusherClient?.disconnect();
    replyController.dispose();
    super.dispose();
  }

  void _initRealtimeWebSockets() {
    try {
      final host = ApiConfigController().ip;
      final options = PusherChannelsOptions.fromHost(
        scheme: 'ws',
        host: host,
        port: 8085,
        key: 'r5srrlrufruxbdrppf6x',
      );

      _pusherClient = PusherChannelsClient.websocket(
        options: options,
        connectionErrorHandler: (exception, trace, refresh) async {
          refresh();
        },
      );

      _supportChannel = _pusherClient!.publicChannel('support.tickets');

      // 1. الاستماع لإنشاء تذكرة جديدة
      final subCreate =
          _supportChannel!.bind('SupportTicketCreated').listen((event) {
        final map = event.tryGetDataAsMap();
        if (map != null && map['ticket'] != null) {
          final ticketData = map['ticket'] is Map
              ? Map<String, dynamic>.from(map['ticket'] as Map)
              : null;
          if (ticketData != null) {
            final newTicket =
                SupportTicketModel.fromJson(ticketData).toEntity();
            final existingIndex =
                tickets.indexWhere((t) => t.id == newTicket.id);
            if (existingIndex == -1) {
              tickets.insert(0, newTicket);
              if (_matchesFilters(newTicket)) {
                filteredTickets.insert(0, newTicket);
              }
            } else {
              tickets[existingIndex] = newTicket;
              final fIndex =
                  filteredTickets.indexWhere((t) => t.id == newTicket.id);
              if (fIndex != -1) {
                if (_matchesFilters(newTicket)) {
                  filteredTickets[fIndex] = newTicket;
                } else {
                  filteredTickets.removeAt(fIndex);
                }
              } else if (_matchesFilters(newTicket)) {
                filteredTickets.insert(0, newTicket);
              }
            }
            notifyListeners();
          }
        }
      });

      // 2. الاستماع لتحديث تذكرة (حالة / أولوية / تعيين)
      final subUpdate =
          _supportChannel!.bind('SupportTicketUpdated').listen((event) {
        final map = event.tryGetDataAsMap();
        if (map != null && map['ticket'] != null) {
          final ticketData = map['ticket'] is Map
              ? Map<String, dynamic>.from(map['ticket'] as Map)
              : null;
          if (ticketData != null) {
            final updated =
                SupportTicketModel.fromJson(ticketData).toEntity();
            final index = tickets.indexWhere((t) => t.id == updated.id);
            if (index != -1) {
              tickets[index] = updated;
            }

            final fIndex =
                filteredTickets.indexWhere((t) => t.id == updated.id);
            if (fIndex != -1) {
              if (_matchesFilters(updated)) {
                filteredTickets[fIndex] = updated;
              } else {
                filteredTickets.removeAt(fIndex);
              }
            } else if (_matchesFilters(updated)) {
              filteredTickets.insert(0, updated);
            }

            if (selectedTicket?.id == updated.id) {
              selectedTicket = updated.copyWith(
                messages: updated.messages.isNotEmpty
                    ? updated.messages
                    : selectedTicket!.messages,
              );
            }
            notifyListeners();
          }
        }
      });

      // 3. الاستماع للرسائل الفورية الجديدة
      final subMessage =
          _supportChannel!.bind('SupportMessageSent').listen((event) {
        final map = event.tryGetDataAsMap();
        if (map != null && map['message'] != null) {
          final ticketId = map['ticket_id'] is int
              ? map['ticket_id'] as int
              : int.tryParse(map['ticket_id']?.toString() ?? '0') ?? 0;
          final msgData = map['message'] is Map
              ? Map<String, dynamic>.from(map['message'] as Map)
              : null;
          if (msgData != null) {
            final newMsg =
                SupportMessageModel.fromJson(msgData).toEntity();

            if (selectedTicket != null && selectedTicket!.id == ticketId) {
              final exists =
                  selectedTicket!.messages.any((m) => m.id == newMsg.id);
              if (!exists) {
                final updatedMessages =
                    List<SupportMessageEntity>.from(selectedTicket!.messages)
                      ..add(newMsg);
                selectedTicket = selectedTicket!.copyWith(
                  messages: updatedMessages,
                  messagesCount: selectedTicket!.messagesCount + 1,
                  lastReplyAt: newMsg.createdAt,
                  latestMessage: newMsg,
                );
              }
            }

            final tIndex = tickets.indexWhere((t) => t.id == ticketId);
            if (tIndex != -1) {
              final current = tickets[tIndex];
              final updated = current.copyWith(
                messagesCount: current.messagesCount + 1,
                lastReplyAt: newMsg.createdAt,
                latestMessage: newMsg,
              );
              tickets[tIndex] = updated;
              final fIndex =
                  filteredTickets.indexWhere((t) => t.id == ticketId);
              if (fIndex != -1) {
                filteredTickets[fIndex] = updated;
              }
            }
            notifyListeners();
          }
        }
      });

      _wsSubscriptions.addAll([subCreate, subUpdate, subMessage]);
      _wsSubscriptions.add(_pusherClient!.onConnectionEstablished.listen((_) {
        _supportChannel!.subscribeIfNotUnsubscribed();
      }));

      _pusherClient!.connect();
    } catch (e) {
      debugPrint('WebSocket initialization error: $e');
    }
  }

  bool _matchesFilters(SupportTicketEntity ticket) {
    if (selectedStatus != 'all' && ticket.status != selectedStatus) return false;
    if (selectedPriority != 'all' && ticket.priority != selectedPriority) return false;
    if (selectedCategory != 'all' && ticket.category != selectedCategory) return false;
    if (searchQuery.trim().isNotEmpty) {
      final q = searchQuery.trim().toLowerCase();
      final matchSubject = ticket.subject.toLowerCase().contains(q);
      final matchUser = ticket.userName.toLowerCase().contains(q);
      final matchNumber = ticket.ticketNumber.toLowerCase().contains(q);
      if (!matchSubject && !matchUser && !matchNumber) return false;
    }
    return true;
  }

  void updateSelectedStatus(String status) {
    selectedStatus = status;
    notifyListeners();
    fetchTickets(showLoading: false);
  }

  void updateSelectedPriority(String priority) {
    selectedPriority = priority;
    notifyListeners();
    fetchTickets(showLoading: false);
  }

  void updateSelectedCategory(String category) {
    selectedCategory = category;
    notifyListeners();
    fetchTickets(showLoading: false);
  }

  void onSearchChanged(String query) {
    searchQuery = query;
    notifyListeners();
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      fetchTickets(showLoading: false);
    });
  }

  void setInternalNote(bool val) {
    isInternalNote = val;
    notifyListeners();
  }

  void setReplyStatus(String val) {
    replyStatus = val;
    notifyListeners();
  }

  void setSelectedTicket(SupportTicketEntity? ticket) {
    selectedTicket = ticket;
    notifyListeners();
  }

  Future<void> fetchTickets({bool showLoading = true}) async {
    try {
      if (showLoading) {
        isLoading = true;
        notifyListeners();
      }

      final result = await getTicketsUseCase(
        status: selectedStatus,
        priority: selectedPriority,
        category: selectedCategory,
        search: searchQuery,
      );

      final List<SupportTicketEntity> items = result['tickets'] ?? [];
      tickets = List.from(items);
      filteredTickets = List.from(items);

      if (result['stats'] is SupportStatsEntity) {
        stats = result['stats'];
      }

      if (selectedTicket == null && items.isNotEmpty) {
        selectTicket(items.first);
      } else if (selectedTicket != null) {
        final exists =
            items.where((t) => t.id == selectedTicket!.id).firstOrNull;
        if (exists == null && items.isNotEmpty) {
          selectTicket(items.first);
        }
      }
    } catch (e) {
      AppFeedback.showError('تعذر تحميل تذاكر الدعم: ${e.toString()}');
    } finally {
      if (showLoading) {
        isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> selectTicket(SupportTicketEntity ticket) async {
    try {
      isLoadingDetail = true;
      selectedTicket = ticket;
      replyController.clear();
      isInternalNote = false;
      replyStatus = 'waiting_user';
      notifyListeners();

      final detailed = await getTicketDetailUseCase(ticket.id);
      selectedTicket = detailed;

      final index = tickets.indexWhere((t) => t.id == ticket.id);
      if (index != -1) {
        tickets[index] = detailed;
        filteredTickets = List.from(tickets);
      }
    } catch (e) {
      AppFeedback.showError('تعذر تحميل محادثة التذكرة: ${e.toString()}');
    } finally {
      isLoadingDetail = false;
      notifyListeners();
    }
  }

  void insertCannedResponse(String template) {
    replyController.text = template;
    notifyListeners();
  }

  Future<void> sendReply() async {
    final ticket = selectedTicket;
    if (ticket == null) return;

    final text = replyController.text.trim();
    if (text.isEmpty) {
      AppFeedback.showWarning('يرجى كتابة نص الرسالة أولاً');
      return;
    }

    try {
      isSendingReply = true;
      notifyListeners();

      final newMsg = await sendMessageUseCase(
        ticketId: ticket.id,
        message: text,
        isInternalNote: isInternalNote,
        status: isInternalNote ? null : replyStatus,
      );

      replyController.clear();

      final currentMessages =
          List<SupportMessageEntity>.from(selectedTicket!.messages);
      currentMessages.add(newMsg);

      final newStatus = isInternalNote ? ticket.status : replyStatus;
      selectedTicket = SupportTicketEntity(
        id: ticket.id,
        ticketNumber: ticket.ticketNumber,
        userId: ticket.userId,
        userName: ticket.userName,
        userEmail: ticket.userEmail,
        userPhone: ticket.userPhone,
        userAvatar: ticket.userAvatar,
        subject: ticket.subject,
        category: ticket.category,
        priority: ticket.priority,
        status: newStatus,
        orderId: ticket.orderId,
        orderNumber: ticket.orderNumber,
        orderTotal: ticket.orderTotal,
        adminId: ticket.adminId,
        adminName: ticket.adminName,
        adminRole: ticket.adminRole,
        messagesCount: ticket.messagesCount + 1,
        unreadMessagesCount: 0,
        messages: currentMessages,
        lastReplyAt: DateTime.now(),
        resolvedAt:
            newStatus == 'resolved' ? DateTime.now() : ticket.resolvedAt,
        closedAt: newStatus == 'closed' ? DateTime.now() : ticket.closedAt,
        createdAt: ticket.createdAt,
      );

      fetchTickets(showLoading: false);

      AppFeedback.showSuccess(
        isInternalNote
            ? 'تم حفظ الملاحظة الداخلية بنجاح'
            : 'تم إرسال الرد وإشعار العميل بنجاح',
      );
    } catch (e) {
      AppFeedback.showError('فشل في إرسال الرد: ${e.toString()}');
    } finally {
      isSendingReply = false;
      notifyListeners();
    }
  }

  Future<void> updateTicketStatus(String newStatus) async {
    final ticket = selectedTicket;
    if (ticket == null || ticket.status == newStatus) return;

    try {
      isUpdating = true;
      notifyListeners();

      final updated = await updateStatusUseCase(ticket.id, newStatus);
      selectedTicket = updated;
      await fetchTickets(showLoading: false);

      AppFeedback.showSuccess(
        'تم تغيير حالة التذكرة إلى: ${updated.statusArabic}',
      );
    } catch (e) {
      AppFeedback.showError('تعذر تحديث الحالة: ${e.toString()}');
    } finally {
      isUpdating = false;
      notifyListeners();
    }
  }

  Future<void> updateTicketPriority(String newPriority) async {
    final ticket = selectedTicket;
    if (ticket == null || ticket.priority == newPriority) return;

    try {
      isUpdating = true;
      notifyListeners();

      final updated = await updatePriorityUseCase(ticket.id, newPriority);
      selectedTicket = updated;
      await fetchTickets(showLoading: false);

      AppFeedback.showSuccess(
        'تم تعديل الأولوية إلى: ${updated.priorityArabic}',
      );
    } catch (e) {
      AppFeedback.showError('تعذر تعديل الأولوية: ${e.toString()}');
    } finally {
      isUpdating = false;
      notifyListeners();
    }
  }

  Future<void> assignTicketAdmin(int? adminId) async {
    final ticket = selectedTicket;
    if (ticket == null) return;

    try {
      isUpdating = true;
      notifyListeners();

      final updated = await assignAdminUseCase(ticket.id, adminId);
      selectedTicket = updated;
      await fetchTickets(showLoading: false);

      AppFeedback.showSuccess('تم تعيين المشرف المسؤول عن التذكرة بنجاح');
    } catch (e) {
      AppFeedback.showError('تعذر تعيين المشرف: ${e.toString()}');
    } finally {
      isUpdating = false;
      notifyListeners();
    }
  }

  Future<void> deleteTicket(int ticketId) async {
    try {
      await deleteTicketUseCase(ticketId);
      selectedTicket = null;
      await fetchTickets();
      AppFeedback.showSuccess('تم حذف التذكرة بنجاح');
    } catch (e) {
      AppFeedback.showError('تعذر حذف التذكرة: ${e.toString()}');
    }
  }
}
