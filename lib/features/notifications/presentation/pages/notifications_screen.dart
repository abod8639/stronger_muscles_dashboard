import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/responsive.dart';
import '../../../../core/utils/components/base_app_bar.dart';
import '../../../../core/utils/components/custom_search_bar.dart';
import '../../../../core/utils/components/enhanced_error_widget.dart';
import '../../../../core/utils/components/enhanced_loading_widget.dart';
import '../../../../core/utils/components/generic_empty_state.dart';
import '../../../../core/utils/components/my_refresh_indicator.dart';
import '../../../../core/utils/components/top_section.dart';
import '../controllers/notifications_providers.dart';
import '../widgets/notification_item_card.dart';
import '../widgets/notifications_stats_header.dart';
import '../widgets/send_notification_dialog.dart';

/// Screen displaying notifications management interface with real-time stats and filters.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final responsive = context.responsive;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final notificationsAsync = ref.watch(notificationsControllerProvider);
    final filteredNotifications = ref.watch(filteredNotificationsListProvider);
    final currentSearch = ref.watch(notificationsSearchQueryProvider);
    final currentFilter = ref.watch(notificationsFilterTypeProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: BaseAppBar(
        title: 'الإشعارات (Notifications)',
        icon: Icons.add_comment_rounded,
        onPressed: () => showSendNotificationDialog(context),
      ),
      body: notificationsAsync.when(
        loading: () => const EnhancedLoadingWidget(
          message: 'جاري تحميل قائمة الإشعارات...',
        ),
        error: (error, stackTrace) => Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 550),
              child: EnhancedErrorWidget(
                title: 'خطأ في تحميل الإشعارات',
                message: error.toString(),
                onRetry: () => ref
                    .read(notificationsControllerProvider.notifier)
                    .refreshNotifications(),
              ),
            ),
          ),
        ),
        data: (data) {
          return Column(
            children: [
              TopSection(
                children: [
                  CustomSearchBar(
                    hintText: 'ابحث في عنوان أو نص الإشعار...',
                    padding: responsive.defaultPadding,
                    onSearch: (value) {
                      ref
                          .read(notificationsSearchQueryProvider.notifier)
                          .setQuery(value);
                    },
                  ),
                  const NotificationsStatsHeader(),
                  const SizedBox(height: 8),

                  // Category filter chips
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.defaultPadding.left,
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip(
                            ref,
                            'all',
                            'الكل (${data.notifications.length})',
                            currentFilter,
                          ),
                          const SizedBox(width: 8),
                          _buildFilterChip(ref, 'general', 'عام', currentFilter),
                          const SizedBox(width: 8),
                          _buildFilterChip(ref, 'promo', 'إعلانات', currentFilter),
                          const SizedBox(width: 8),
                          _buildFilterChip(ref, 'order', 'طلبات', currentFilter),
                          const SizedBox(width: 8),
                          _buildFilterChip(ref, 'system', 'نظام', currentFilter),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Expanded(
                child: filteredNotifications.isEmpty
                    ? GenericEmptyState(
                        title: 'لا توجد إشعارات',
                        message: currentSearch.isNotEmpty
                            ? 'لم يتم العثور على أي نتائج تطابق البحث: "$currentSearch"'
                            : 'لم يتم إرسال أي إشعارات بعد. يمكنك إرسال إشعار جديد الآن!',
                        icon: Icons.notifications_none_rounded,
                        actionLabel: 'إرسال إشعار جديد',
                        onAction: () => showSendNotificationDialog(context),
                      )
                    : MyRefreshIndicator(
                        onRefresh: () => ref
                            .read(notificationsControllerProvider.notifier)
                            .refreshNotifications(),
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                            horizontal: responsive.defaultPadding.left,
                            vertical: 10,
                          ),
                          itemCount: filteredNotifications.length,
                          itemBuilder: (context, index) {
                            final notification = filteredNotifications[index];
                            return NotificationItemCard(
                              key: ValueKey(notification.id),
                              notification: notification,
                            );
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(
    WidgetRef ref,
    String value,
    String label,
    String currentFilter,
  ) {
    final isSelected = currentFilter == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        ref.read(notificationsFilterTypeProvider.notifier).setType(value);
      },
    );
  }
}
