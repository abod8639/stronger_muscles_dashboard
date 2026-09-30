import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/responsive.dart';
import '../../../../core/utils/components/base_app_bar.dart';
import '../../../../core/utils/components/custom_search_bar.dart';
import '../../../../core/utils/components/enhanced_loading_widget.dart';
import '../../../../core/utils/components/generic_empty_state.dart';
import '../../../../core/utils/components/my_refresh_indicator.dart';
import '../../../../core/utils/components/top_section.dart';
import '../controllers/notifications_controller.dart';
import '../widgets/notification_item_card.dart';
import '../widgets/notifications_stats_header.dart';
import '../widgets/send_notification_dialog.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationsController>();
    final responsive = context.responsive;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: BaseAppBar(
        title: 'الإشعارات (Notifications)',
        icon: Icons.add_comment_rounded,
        onPressed: () => showSendNotificationDialog(context),
      ),
      body: Column(
        children: [
          TopSection(
            children: [
              CustomSearchBar(
                hintText: 'ابحث في عنوان أو نص الإشعار...',
                padding: responsive.defaultPadding,
                onSearch: (value) => controller.onSearchChanged(value),
              ),
              const NotificationsStatsHeader(),
              const SizedBox(height: 8),

              // Filter Chips
              Obx(() => Padding(
                    padding: EdgeInsets.symmetric(horizontal: responsive.defaultPadding.left),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip('all', 'الكل (${controller.notifications.length})', controller),
                          const SizedBox(width: 8),
                          _buildFilterChip('general', 'عام', controller),
                          const SizedBox(width: 8),
                          _buildFilterChip('promo', 'إعلانات', controller),
                          const SizedBox(width: 8),
                          _buildFilterChip('order', 'طلبات', controller),
                          const SizedBox(width: 8),
                          _buildFilterChip('system', 'نظام', controller),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
          const SizedBox(height: 8),

          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.notifications.isEmpty) {
                return const EnhancedLoadingWidget(
                  message: 'جاري تحميل قائمة الإشعارات...',
                );
              }

              if (controller.filteredNotifications.isEmpty) {
                return GenericEmptyState(
                  title: 'لا توجد إشعارات',
                  message: controller.searchQuery.value.isNotEmpty
                      ? 'لم يتم العثور على أي نتائج تطابق البحث: "${controller.searchQuery.value}"'
                      : 'لم يتم إرسال أي إشعارات بعد. يمكنك إرسال إشعار جديد الآن!',
                  icon: Icons.notifications_none_rounded,
                  actionLabel: 'إرسال إشعار جديد',
                  onAction: () => showSendNotificationDialog(context),
                );
              }

              return MyRefreshIndicator(
                onRefresh: () => controller.fetchNotifications(),
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.defaultPadding.left,
                    vertical: 10,
                  ),
                  itemCount: controller.filteredNotifications.length,
                  itemBuilder: (context, index) {
                    final notification = controller.filteredNotifications[index];
                    return NotificationItemCard(notification: notification);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String value, String label, NotificationsController controller) {
    final isSelected = controller.selectedFilterType.value == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => controller.onFilterTypeChanged(value),
    );
  }
}
