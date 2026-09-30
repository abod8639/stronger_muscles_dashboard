import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/admin_notification_entity.dart';
import '../../domain/usecases/notification_usecases.dart';

class NotificationsController extends GetxController {
  final GetNotificationsUseCase getNotificationsUseCase;
  final SendNotificationUseCase sendNotificationUseCase;
  final DeleteNotificationUseCase deleteNotificationUseCase;

  NotificationsController({
    required this.getNotificationsUseCase,
    required this.sendNotificationUseCase,
    required this.deleteNotificationUseCase,
  });

  final notifications = <AdminNotificationEntity>[].obs;
  final filteredNotifications = <AdminNotificationEntity>[].obs;
  final isLoading = true.obs;
  final isSending = false.obs;

  final searchQuery = ''.obs;
  final selectedFilterType = 'all'.obs;

  // Stats
  final totalCount = 0.obs;
  final todayCount = 0.obs;
  final broadcastCount = 0.obs;
  final targetedCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
    ever(searchQuery, (_) => _applyFilter());
    ever(selectedFilterType, (_) => _applyFilter());
  }

  void onSearchChanged(String query) => searchQuery.value = query;

  void onFilterTypeChanged(String type) => selectedFilterType.value = type;

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      final result = await getNotificationsUseCase();
      final List<AdminNotificationEntity> items = result['notifications'] ?? [];
      notifications.assignAll(items);

      final stats = result['stats'] ?? {};
      totalCount.value = (stats['total'] as num?)?.toInt() ?? items.length;
      todayCount.value = (stats['sent_today'] as num?)?.toInt() ?? 0;
      broadcastCount.value = (stats['broadcast'] as num?)?.toInt() ?? 0;
      targetedCount.value = (stats['targeted'] as num?)?.toInt() ?? 0;

      _applyFilter();
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء جلب قائمة الإشعارات: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _applyFilter() {
    var list = notifications.toList();

    if (selectedFilterType.value != 'all') {
      list = list.where((n) => n.type == selectedFilterType.value).toList();
    }

    if (searchQuery.value.trim().isNotEmpty) {
      final query = searchQuery.value.toLowerCase().trim();
      list = list.where((n) {
        final titleMatch = n.title.toLowerCase().contains(query);
        final bodyMatch = n.body.toLowerCase().contains(query);
        final userMatch = n.userName?.toLowerCase().contains(query) ?? false;
        return titleMatch || bodyMatch || userMatch;
      }).toList();
    }

    filteredNotifications.assignAll(list);
  }

  Future<bool> sendNotification({
    required String title,
    required String body,
    required String type,
    required String targetType,
    String? userId,
    String? imageUrl,
  }) async {
    try {
      isSending.value = true;
      final payload = {
        'title': title,
        'body': body,
        'type': type,
        'target_type': targetType,
        if (targetType == 'user' && userId != null && userId.isNotEmpty) 'user_id': userId,
        if (imageUrl != null && imageUrl.isNotEmpty) 'image_url': imageUrl,
      };

      final newNotification = await sendNotificationUseCase(payload);
      notifications.insert(0, newNotification);
      totalCount.value++;
      todayCount.value++;
      if (targetType == 'all') {
        broadcastCount.value++;
      } else {
        targetedCount.value++;
      }
      _applyFilter();

      Get.snackbar(
        'نجاح',
        'تم إرسال الإشعار بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
      return true;
    } catch (e) {
      Get.snackbar(
        'فشل الإرسال',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
      return false;
    } finally {
      isSending.value = false;
    }
  }

  Future<void> deleteNotification(String id) async {
    try {
      await deleteNotificationUseCase(id);
      notifications.removeWhere((n) => n.id == id);
      totalCount.value = (totalCount.value - 1).clamp(0, 999999);
      _applyFilter();

      Get.snackbar(
        'تم الحذف',
        'تم حذف الإشعار بنجاح',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل في حذف الإشعار: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    }
  }
}
