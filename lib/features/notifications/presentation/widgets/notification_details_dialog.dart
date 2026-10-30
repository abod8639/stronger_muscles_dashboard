import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:stronger_muscles_dashboard/core/components/confirm_dialog.dart';
import 'package:stronger_muscles_dashboard/core/components/info_pill.dart';
import 'package:stronger_muscles_dashboard/core/router/app_routes.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';
import 'package:stronger_muscles_dashboard/core/utils/ui_feedback.dart';
import 'package:stronger_muscles_dashboard/features/navigation/domain/entities/navigation_tab.dart';
import 'package:stronger_muscles_dashboard/features/navigation/presentation/controllers/navigation_providers.dart';
import 'package:stronger_muscles_dashboard/features/support/presentation/controllers/support_providers.dart';
import 'package:stronger_muscles_dashboard/functions/cache_manager.dart';
import '../../domain/entities/admin_notification_entity.dart';
import '../controllers/notifications_providers.dart';
import 'notification_type_ui.dart';

/// Helper function to display the full notification details dialog.
void showNotificationDetailsDialog(
  BuildContext context,
  AdminNotificationEntity notification,
) {
  showDialog(
    context: context,
    builder: (ctx) => NotificationDetailsDialog(notification: notification),
  );
}

/// Dialog displaying the complete details of an administrative or system notification,
/// with dynamic actions to navigate to linked tickets or orders.
class NotificationDetailsDialog extends ConsumerWidget {
  final AdminNotificationEntity notification;

  const NotificationDetailsDialog({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final type = NotificationTypeUi.of(notification.type);

    final dateStr = notification.createdAt != null
        ? DateFormat('yyyy/MM/dd  •  hh:mm a').format(notification.createdAt!)
        : 'الآن';

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 580, maxHeight: 720),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.grey.withValues(alpha: 0.15),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 28,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Header: Type Icon, Dialog Title, and Close Button
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: type.color.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(type.icon, color: type.color, size: 26),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'تفاصيل الإشعار',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.textLight : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            dateStr,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.outline,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      tooltip: 'إغلاق',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const Divider(height: 1),
                const SizedBox(height: 16),

                // Scrollable Body Content
                Flexible(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Title
                        SelectableText(
                          notification.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: isDark ? AppColors.textLight : Colors.black87,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Body message
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: colorScheme.outlineVariant.withValues(alpha: 0.2),
                            ),
                          ),
                          child: SelectableText(
                            notification.body,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              height: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Image / Avatar preview if present
                        if (notification.displayImage != null &&
                            notification.displayImage!.isNotEmpty) ...[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: CachedNetworkImage(
                              imageUrl: notification.displayImage!,
                              cacheManager: CustomCacheManager.instance,
                              fit: BoxFit.cover,
                              height: 180,
                              width: double.infinity,
                              placeholder: (_, _) => Container(
                                height: 180,
                                color: colorScheme.surfaceContainerHigh,
                                child: const Center(
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              ),
                              errorWidget: (_, _, _) => Container(
                                height: 100,
                                color: colorScheme.surfaceContainerHigh,
                                child: Center(
                                  child: Icon(
                                    Icons.person_rounded,
                                    size: 40,
                                    color: colorScheme.outline,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Metadata pills
                        Wrap(
                          spacing: AppDesignTokens.space8,
                          runSpacing: AppDesignTokens.space8,
                          children: [
                            InfoPill(
                              label: type.label,
                              icon: type.icon,
                              color: type.color,
                            ),
                            if (notification.isTicket && notification.messagesCount > 1)
                              InfoPill(
                                label: '${notification.messagesCount} رسائل في التذكرة',
                                icon: Icons.mark_chat_unread_rounded,
                                color: const Color(0xFFA855F7),
                              ),
                            if (notification.ticketId != null)
                              InfoPill(
                                label: '#${notification.data?['ticket_number'] ?? notification.ticketId}',
                                icon: Icons.confirmation_number_outlined,
                              ),
                            InfoPill(
                              label: notification.targetLabel,
                              icon: notification.targetType == 'all'
                                  ? Icons.public_rounded
                                  : Icons.person_rounded,
                            ),
                            if (notification.adminName != null)
                              InfoPill(
                                label: 'بواسطة: ${notification.adminName}',
                                icon: Icons.admin_panel_settings_rounded,
                              ),
                            if (notification.userEmail != null)
                              InfoPill(
                                label: notification.userEmail!,
                                icon: Icons.alternate_email_rounded,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(height: 1),
                const SizedBox(height: 16),

                // Bottom Action Buttons
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    // Delete Button
                    TextButton.icon(
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        color: colorScheme.error,
                        size: 20,
                      ),
                      label: Text(
                        'حذف الإشعار',
                        style: TextStyle(
                          color: colorScheme.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () => _confirmDelete(context, ref, colorScheme),
                    ),

                    // Navigation & Dismiss Actions
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (notification.isTicket) ...[
                          ElevatedButton.icon(
                            icon: const Icon(Icons.support_agent_rounded, size: 18),
                            label: Text(
                              notification.ticketId != null
                                  ? 'فتح التذكرة (#${notification.ticketId})'
                                  : 'فتح الدعم الفني',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFA855F7),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: () => _navigateToTicket(context, ref),
                          ),
                          const SizedBox(width: 8),
                        ],
                        if (notification.isOrder && !notification.isTicket) ...[
                          ElevatedButton.icon(
                            icon: const Icon(Icons.local_shipping_rounded, size: 18),
                            label: Text(
                              notification.orderId != null
                                  ? 'عرض الطلب (#${notification.orderId})'
                                  : 'قائمة الطلبات',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.info,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: () => _navigateToOrders(context, ref),
                          ),
                          const SizedBox(width: 8),
                        ],
                        OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text('إغلاق'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToTicket(BuildContext context, WidgetRef ref) {
    Navigator.of(context).pop();
    final ticketId = notification.ticketId;
    if (ticketId != null) {
      ref.read(supportControllerProvider.notifier).selectTicketById(
            ticketId,
            ticketNumber: notification.data?['ticket_number']?.toString(),
            subject: notification.title,
            userName: notification.userName,
            userEmail: notification.userEmail,
          );
    }
    ref
        .read(navigationControllerProvider.notifier)
        .selectTab(NavigationTab.support.tabIndex);

    final currentLoc = GoRouterState.of(context).uri.toString();
    if (currentLoc != AppRoutes.dashboard) {
      context.go(AppRoutes.dashboard);
    }
  }

  void _navigateToOrders(BuildContext context, WidgetRef ref) {
    Navigator.of(context).pop();
    ref
        .read(navigationControllerProvider.notifier)
        .selectTab(NavigationTab.orders.tabIndex);

    final currentLoc = GoRouterState.of(context).uri.toString();
    if (currentLoc != AppRoutes.dashboard) {
      context.go(AppRoutes.dashboard);
    }
  }

  void _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    ColorScheme colorScheme,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => ConfirmDialog(
        title: 'تأكيد الحذف',
        message: 'هل أنت متأكد من رغبتك في حذف هذا الإشعار؟',
        confirmText: 'حذف',
        confirmColor: colorScheme.error,
        icon: Icons.delete_forever_rounded,
        onConfirm: () async {
          Navigator.of(ctx).pop();
          Navigator.of(context).pop();
          if (notification.groupedNotificationIds.isNotEmpty) {
            for (final nid in notification.groupedNotificationIds) {
              await ref
                  .read(notificationsControllerProvider.notifier)
                  .deleteNotification(nid);
            }
            AppFeedback.showSuccess('تم حذف إشعارات التذكرة بنجاح');
          } else {
            final result = await ref
                .read(notificationsControllerProvider.notifier)
                .deleteNotification(notification.id);
            result.fold(
              (failure) => AppFeedback.showError(failure.message),
              (_) => AppFeedback.showSuccess('تم حذف الإشعار بنجاح'),
            );
          }
        },
      ),
    );
  }
}

