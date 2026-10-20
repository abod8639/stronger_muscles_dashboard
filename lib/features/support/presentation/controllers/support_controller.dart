import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  // Polling Timer for Real-Time Sync
  Timer? _pollingTimer;

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
    _startPolling();

    ever(selectedStatus, (_) => fetchTickets(showLoading: false));
    ever(selectedPriority, (_) => fetchTickets(showLoading: false));
    ever(selectedCategory, (_) => fetchTickets(showLoading: false));
    debounce(searchQuery, (_) => fetchTickets(showLoading: false), time: const Duration(milliseconds: 350));
  }

  @override
  void onClose() {
    _pollingTimer?.cancel();
    replyController.dispose();
    super.onClose();
  }

  void _startPolling() {
    _pollingTimer?.cancel();
    // Periodically sync tickets and currently open conversation every 12 seconds
    _pollingTimer = Timer.periodic(const Duration(seconds: 12), (_) {
      _silentRefresh();
    });
  }

  Future<void> _silentRefresh() async {
    try {
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

      // If a ticket is currently selected, refresh its messages thread
      if (selectedTicket.value != null) {
        final currentId = selectedTicket.value!.id;
        final updatedDetail = await getTicketDetailUseCase(currentId);
        selectedTicket.value = updatedDetail;
      }
    } catch (_) {
      // Background sync failures are silent
    }
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
