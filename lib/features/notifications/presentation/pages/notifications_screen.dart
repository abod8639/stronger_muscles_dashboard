import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/core/components/base_app_bar.dart';
import 'package:stronger_muscles_dashboard/core/components/base_data_view.dart';
import 'package:stronger_muscles_dashboard/core/components/custom_search_bar.dart';
import 'package:stronger_muscles_dashboard/core/components/enhanced_error_widget.dart';
import 'package:stronger_muscles_dashboard/core/components/enhanced_loading_widget.dart';
import 'package:stronger_muscles_dashboard/core/components/generic_empty_state.dart';
import 'package:stronger_muscles_dashboard/core/components/horizontal_chips_selector.dart';
import 'package:stronger_muscles_dashboard/core/components/my_refresh_indicator.dart';
import 'package:stronger_muscles_dashboard/core/components/top_section.dart';
import 'package:stronger_muscles_dashboard/core/theme/responsive.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';
import '../../domain/entities/admin_notification_entity.dart';
import '../controllers/notifications_providers.dart';
import '../widgets/notification_item_card.dart';
import '../widgets/notification_type_ui.dart';
import '../widgets/notifications_stats_header.dart';
import '../widgets/send_notification_dialog.dart';

/// Screen displaying notifications management interface with real-time stats and filters.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  /// أقصى عرض للمحتوى على الشاشات العريضة حتى لا تتمدد البطاقات بشكل مبالغ
  static const double _maxContentWidth = 1400;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsControllerProvider);
    final notifier = ref.read(notificationsControllerProvider.notifier);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: BaseAppBar(
        title: 'الإشعارات',
        onPressed: notifier.refreshNotifications,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showSendNotificationDialog(context),
        icon: const Icon(Icons.add_comment_rounded),
        label: const Text('إشعار جديد'),
      ),
      body: notificationsAsync.when(
        loading: () => const EnhancedLoadingWidget(
          message: 'جاري تحميل قائمة الإشعارات...',
        ),
        error: (error, stackTrace) => EnhancedErrorWidget.fromError(
          error,
          fallbackTitle: 'خطأ في تحميل الإشعارات',
          onRetry: notifier.refreshNotifications,
        ),
        data: (data) => MyRefreshIndicator(
          onRefresh: notifier.refreshNotifications,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            // مساحة سفلية حتى لا يغطي الزر العائم آخر بطاقة
            padding: const EdgeInsets.only(bottom: 96),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _maxContentWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _NotificationsFilters(
                      totalCount: data.notifications.length,
                    ),
                    const SizedBox(height: AppDesignTokens.space8),
                    const _NotificationsList(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// القسم العلوي: البحث، الإحصائيات، وشرائح التصفية حسب النوع
class _NotificationsFilters extends ConsumerWidget {
  final int totalCount;

  const _NotificationsFilters({required this.totalCount});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final responsive = context.responsive;
    final currentFilter = ref.watch(notificationsFilterTypeProvider);

    return TopSection(
      children: [
        CustomSearchBar(
          hintText: 'ابحث في عنوان أو نص الإشعار...',
          padding: responsive.defaultPadding,
          onSearch: ref
              .read(notificationsSearchQueryProvider.notifier)
              .setQuery,
        ),
        const NotificationsStatsHeader(),
        const SizedBox(height: AppDesignTokens.space8),
        HorizontalChipsSelector(
          items: NotificationTypeUi.values,
          selectedId: currentFilter,
          allLabel: 'الكل ($totalCount)',
          labelBuilder: (item) => (item as NotificationTypeUi).label,
          idBuilder: (item) => (item as NotificationTypeUi).id,
          onSelect: ref.read(notificationsFilterTypeProvider.notifier).setType,
        ),
      ],
    );
  }
}

/// قائمة الإشعارات: عمود واحد على الهاتف والجهاز اللوحي وعمودان على الحاسوب
class _NotificationsList extends ConsumerWidget {
  const _NotificationsList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(filteredNotificationsListProvider);
    final currentSearch = ref.watch(notificationsSearchQueryProvider);
    final currentFilter = ref.watch(notificationsFilterTypeProvider);

    if (notifications.isEmpty) {
      final message = currentSearch.isNotEmpty
          ? 'لم يتم العثور على أي نتائج تطابق البحث: "$currentSearch"'
          : currentFilter != 'all'
          ? 'لا توجد إشعارات من نوع "${NotificationTypeUi.of(currentFilter).label}".'
          : 'لم يتم إرسال أي إشعارات بعد. يمكنك إرسال إشعار جديد الآن!';

      return GenericEmptyState(
        title: 'لا توجد إشعارات',
        message: message,
        icon: Icons.notifications_none_rounded,
        actionLabel: 'إرسال إشعار جديد',
        actionIcon: Icons.add_comment_rounded,
        onAction: () => showSendNotificationDialog(context),
      );
    }

    return BaseDataView<AdminNotificationEntity>(
      title: 'سجل الإشعارات',
      items: notifications,
      useListView: !context.isDesktop,
      crossAxisCount: 2,
      mainAxisExtent: 172,
      itemBuilder: (context, notification, _) => NotificationItemCard(
        key: ValueKey(notification.id),
        notification: notification,
      ),
    );
  }
}
