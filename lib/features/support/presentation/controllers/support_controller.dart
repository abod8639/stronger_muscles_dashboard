import 'dart:async';
import 'package:dart_pusher_channels/dart_pusher_channels.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/api_config.dart';
import '../../data/models/support_message_model.dart';
import '../../data/models/support_ticket_model.dart';
import '../../domain/entities/support_message_entity.dart';
import '../../domain/entities/support_stats_entity.dart';
import '../../domain/entities/support_ticket_entity.dart';
import '../../domain/usecases/support_usecases.dart';

class SupportController extends GetxController {
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
  });

  // State
  final tickets = <SupportTicketEntity>[].obs;
  final filteredTickets = <SupportTicketEntity>[].obs;
  final selectedTicket = Rxn<SupportTicketEntity>();
  final stats = const SupportStatsEntity().obs;

  final isLoading = true.obs;
  final isLoadingDetail = false.obs;
  final isSendingReply = false.obs;
  final isUpdating = false.obs;

  // Filters
  final selectedStatus = 'all'.obs;
  final selectedPriority = 'all'.obs;
  final selectedCategory = 'all'.obs;
  final searchQuery = ''.obs;

  // Reply Composer
  final replyController = TextEditingController();
  final isInternalNote = false.obs;
  final replyStatus = 'waiting_user'.obs;

  // WebSockets Client & Subscriptions
  PusherChannelsClient? _pusherClient;
  PublicChannel? _supportChannel;
  final List<StreamSubscription> _wsSubscriptions = [];

  // Canned Responses
  final List<String> cannedResponses = const [
    'أهلاً بك، شكراً لتواصلك مع Stronger Muscles. جاري متابعة استفسارك وسنوافيك بالتفاصيل في أقرب وقت.',
    'تم التحقق من المشكلة وحلها بنجاح. نتمنى لك تجربة رياضية وصحية مميزة دائماً!',
    'تم التواصل مع فريق التوصيل والشحن، شحنتك في طريقها إليك وستصلك خلال الموعد المحدد.',
    'نعتذر بشدة عن التأخير أو الخلل غير المقصود، يسعدنا تقديم استبدال فوري أو تعويضك.',
    'يرجى التكرم بتزويدنا برقم الطلب وصورة توضح المشكلة لنتمكن من خدمتك بأفضل شكل.',
  ];

  @override
  void onInit() {
    super.onInit();
    fetchTickets();
    _initRealtimeWebSockets();

    ever(selectedStatus, (_) => fetchTickets(showLoading: false));
    ever(selectedPriority, (_) => fetchTickets(showLoading: false));
    ever(selectedCategory, (_) => fetchTickets(showLoading: false));
    debounce(searchQuery, (_) => fetchTickets(showLoading: false), time: const Duration(milliseconds: 350));
  }

  @override
  void onClose() {
    for (final sub in _wsSubscriptions) {
      sub.cancel();
    }
    _wsSubscriptions.clear();
    _supportChannel?.unsubscribe();
    _pusherClient?.disconnect();
    replyController.dispose();
    super.onClose();
  }

  void _initRealtimeWebSockets() {
    try {
      final ipController = Get.isRegistered<ApiConfigController>()
          ? Get.find<ApiConfigController>()
          : null;
      final host = ipController?.ip ?? '127.0.0.1';
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
      final subCreate = _supportChannel!.bind('SupportTicketCreated').listen((event) {
        final map = event.tryGetDataAsMap();
        if (map != null && map['ticket'] != null) {
          final ticketData = map['ticket'] is Map ? Map<String, dynamic>.from(map['ticket'] as Map) : null;
          if (ticketData != null) {
            final newTicket = SupportTicketModel.fromJson(ticketData).toEntity();
            final existingIndex = tickets.indexWhere((t) => t.id == newTicket.id);
            if (existingIndex == -1) {
              tickets.insert(0, newTicket);
              if (_matchesFilters(newTicket)) {
                filteredTickets.insert(0, newTicket);
              }
            } else {
              tickets[existingIndex] = newTicket;
              final fIndex = filteredTickets.indexWhere((t) => t.id == newTicket.id);
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
          }
        }
      });

      // 2. الاستماع لتحديث تذكرة (حالة / أولوية / تعيين)
      final subUpdate = _supportChannel!.bind('SupportTicketUpdated').listen((event) {
        final map = event.tryGetDataAsMap();
        if (map != null && map['ticket'] != null) {
          final ticketData = map['ticket'] is Map ? Map<String, dynamic>.from(map['ticket'] as Map) : null;
          if (ticketData != null) {
            final updated = SupportTicketModel.fromJson(ticketData).toEntity();
            final index = tickets.indexWhere((t) => t.id == updated.id);
            if (index != -1) {
              tickets[index] = updated;
            }

            final fIndex = filteredTickets.indexWhere((t) => t.id == updated.id);
            if (fIndex != -1) {
              if (_matchesFilters(updated)) {
                filteredTickets[fIndex] = updated;
              } else {
                filteredTickets.removeAt(fIndex);
              }
            } else if (_matchesFilters(updated)) {
              filteredTickets.insert(0, updated);
            }

            if (selectedTicket.value?.id == updated.id) {
              selectedTicket.value = updated.copyWith(
                messages: updated.messages.isNotEmpty
                    ? updated.messages
                    : selectedTicket.value!.messages,
              );
            }
          }
        }
      });

      // 3. الاستماع للرسائل الفورية الجديدة
      final subMessage = _supportChannel!.bind('SupportMessageSent').listen((event) {
        final map = event.tryGetDataAsMap();
        if (map != null && map['message'] != null) {
          final ticketId = map['ticket_id'] is int
              ? map['ticket_id'] as int
              : int.tryParse(map['ticket_id']?.toString() ?? '0') ?? 0;
          final msgData = map['message'] is Map ? Map<String, dynamic>.from(map['message'] as Map) : null;
          if (msgData != null) {
            final newMsg = SupportMessageModel.fromJson(msgData).toEntity();

            // تحديث محادثة التذكرة المفتوحة حالياً فوراً
            if (selectedTicket.value != null && selectedTicket.value!.id == ticketId) {
              final exists = selectedTicket.value!.messages.any((m) => m.id == newMsg.id);
              if (!exists) {
                final updatedMessages = List<SupportMessageEntity>.from(selectedTicket.value!.messages)..add(newMsg);
                selectedTicket.value = selectedTicket.value!.copyWith(
                  messages: updatedMessages,
                  messagesCount: selectedTicket.value!.messagesCount + 1,
                  lastReplyAt: newMsg.createdAt,
                  latestMessage: newMsg,
                );
              }
            }

            // تحديث البطاقة في قائمة التذاكر
            final tIndex = tickets.indexWhere((t) => t.id == ticketId);
            if (tIndex != -1) {
              final current = tickets[tIndex];
              final updated = current.copyWith(
                messagesCount: current.messagesCount + 1,
                lastReplyAt: newMsg.createdAt,
                latestMessage: newMsg,
              );
              tickets[tIndex] = updated;
              final fIndex = filteredTickets.indexWhere((t) => t.id == ticketId);
              if (fIndex != -1) {
                filteredTickets[fIndex] = updated;
              }
            }
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
    if (selectedStatus.value != 'all' && ticket.status != selectedStatus.value) return false;
    if (selectedPriority.value != 'all' && ticket.priority != selectedPriority.value) return false;
    if (selectedCategory.value != 'all' && ticket.category != selectedCategory.value) return false;
    if (searchQuery.value.trim().isNotEmpty) {
      final q = searchQuery.value.trim().toLowerCase();
      final matchSubject = ticket.subject.toLowerCase().contains(q);
      final matchUser = ticket.userName.toLowerCase().contains(q);
      final matchNumber = ticket.ticketNumber.toLowerCase().contains(q);
      if (!matchSubject && !matchUser && !matchNumber) return false;
    }
    return true;
  }

  Future<void> fetchTickets({bool showLoading = true}) async {
    try {
      if (showLoading) isLoading.value = true;

      final result = await getTicketsUseCase(
        status: selectedStatus.value,
        priority: selectedPriority.value,
        category: selectedCategory.value,
        search: searchQuery.value,
      );

      final List<SupportTicketEntity> items = result['tickets'] ?? [];
      tickets.assignAll(items);
      filteredTickets.assignAll(items);

      if (result['stats'] is SupportStatsEntity) {
        stats.value = result['stats'];
      }

      // If no ticket selected yet and list not empty, select the first one
      if (selectedTicket.value == null && items.isNotEmpty) {
        selectTicket(items.first);
      } else if (selectedTicket.value != null) {
        // Keep selected ticket up to date
        final exists = items.firstWhereOrNull((t) => t.id == selectedTicket.value!.id);
        if (exists == null && items.isNotEmpty) {
          selectTicket(items.first);
        }
      }
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'تعذر تحميل تذاكر الدعم: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  Future<void> selectTicket(SupportTicketEntity ticket) async {
    try {
      isLoadingDetail.value = true;
      selectedTicket.value = ticket;
      replyController.clear();
      isInternalNote.value = false;
      replyStatus.value = 'waiting_user';

      final detailed = await getTicketDetailUseCase(ticket.id);
      selectedTicket.value = detailed;

      // Update in local list if read status changed
      final index = tickets.indexWhere((t) => t.id == ticket.id);
      if (index != -1) {
        tickets[index] = detailed;
        filteredTickets.assignAll(tickets);
      }
    } catch (e) {
      Get.snackbar('خطأ', 'تعذر تحميل محادثة التذكرة: ${e.toString()}');
    } finally {
      isLoadingDetail.value = false;
    }
  }

  void insertCannedResponse(String template) {
    replyController.text = template;
  }

  Future<void> sendReply() async {
    final ticket = selectedTicket.value;
    if (ticket == null) return;

    final text = replyController.text.trim();
    if (text.isEmpty) {
      Get.snackbar('تنبيه', 'يرجى كتابة نص الرسالة أولاً', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      isSendingReply.value = true;
      final newMsg = await sendMessageUseCase(
        ticketId: ticket.id,
        message: text,
        isInternalNote: isInternalNote.value,
        status: isInternalNote.value ? null : replyStatus.value,
      );

      replyController.clear();

      // Append new message to selected ticket
      final currentMessages = List<SupportMessageEntity>.from(selectedTicket.value!.messages);
      currentMessages.add(newMsg);

      final newStatus = isInternalNote.value ? ticket.status : replyStatus.value;
      selectedTicket.value = SupportTicketEntity(
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
        resolvedAt: newStatus == 'resolved' ? DateTime.now() : ticket.resolvedAt,
        closedAt: newStatus == 'closed' ? DateTime.now() : ticket.closedAt,
        createdAt: ticket.createdAt,
      );

      // Refresh tickets list
      fetchTickets(showLoading: false);

      Get.snackbar(
        'نجاح',
        isInternalNote.value
            ? 'تم حفظ الملاحظة الداخلية بنجاح'
            : 'تم إرسال الرد وإشعار العميل عبر فايربيس بنجاح',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في إرسال الرد: ${e.toString()}');
    } finally {
      isSendingReply.value = false;
    }
  }

  Future<void> updateTicketStatus(String newStatus) async {
    final ticket = selectedTicket.value;
    if (ticket == null || ticket.status == newStatus) return;

    try {
      isUpdating.value = true;
      final updated = await updateStatusUseCase(ticket.id, newStatus);
      selectedTicket.value = updated;
      await fetchTickets(showLoading: false);

      Get.snackbar(
        'تم التحديث',
        'تم تغيير حالة التذكرة إلى: ${updated.statusArabic}',
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar('خطأ', 'تعذر تحديث الحالة: ${e.toString()}');
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> updateTicketPriority(String newPriority) async {
    final ticket = selectedTicket.value;
    if (ticket == null || ticket.priority == newPriority) return;

    try {
      isUpdating.value = true;
      final updated = await updatePriorityUseCase(ticket.id, newPriority);
      selectedTicket.value = updated;
      await fetchTickets(showLoading: false);

      Get.snackbar(
        'تم التحديث',
        'تم تعديل الأولوية إلى: ${updated.priorityArabic}',
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar('خطأ', 'تعذر تعديل الأولوية: ${e.toString()}');
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> assignTicketAdmin(int? adminId) async {
    final ticket = selectedTicket.value;
    if (ticket == null) return;

    try {
      isUpdating.value = true;
      final updated = await assignAdminUseCase(ticket.id, adminId);
      selectedTicket.value = updated;
      await fetchTickets(showLoading: false);

      Get.snackbar('تم التعيين', 'تم تعيين المشرف المسؤول عن التذكرة بنجاح');
    } catch (e) {
      Get.snackbar('خطأ', 'تعذر تعيين المشرف: ${e.toString()}');
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> deleteTicket(int ticketId) async {
    try {
      await deleteTicketUseCase(ticketId);
      selectedTicket.value = null;
      await fetchTickets();
      Get.snackbar('تم الحذف', 'تم حذف التذكرة بنجاح');
    } catch (e) {
      Get.snackbar('خطأ', 'تعذر حذف التذكرة: ${e.toString()}');
    }
  }
}
