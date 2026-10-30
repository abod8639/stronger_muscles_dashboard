import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:stronger_muscles_dashboard/core/components/confirm_dialog.dart';
import 'package:stronger_muscles_dashboard/core/components/generic_list_card.dart';
import 'package:stronger_muscles_dashboard/core/components/info_pill.dart';
import 'package:stronger_muscles_dashboard/core/router/app_routes.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';
import 'package:stronger_muscles_dashboard/core/utils/ui_feedback.dart';
import 'package:stronger_muscles_dashboard/features/navigation/domain/entities/navigation_tab.dart';
import 'package:stronger_muscles_dashboard/features/navigation/presentation/controllers/navigation_providers.dart';
import 'package:stronger_muscles_dashboard/features/support/presentation/controllers/support_providers.dart';
import '../../domain/entities/admin_notification_entity.dart';
import '../controllers/notifications_providers.dart';
import 'notification_details_dialog.dart';
import 'notification_type_ui.dart';

/// Card widget rendering individual notification item with metadata and action buttons.
class NotificationItemCard extends ConsumerWidget {
  final AdminNotificationEntity notification;
  final VoidCallback? onTap;

  const NotificationItemCard({
    super.key,
    required this.notification,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final type = NotificationTypeUi.of(notification.type);

    final dateStr = notification.createdAt != null
        ? DateFormat('yyyy/MM/dd  •  hh:mm a').format(notification.createdAt!)
        : 'الآن';
    final metadata = notification.adminName != null
        ? '$dateStr  •  بواسطة ${notification.adminName}'
        : dateStr;

    return GenericListCard<AdminNotificationEntity>(
      data: notification,
      margin: EdgeInsets.zero,
      title: notification.title,
      subtitle: notification.body,
      subtitleMaxLines: 2,
      metadata: metadata,
      imageUrl: notification.imageUrl,
      fallbackIcon: type.icon,
      imageWidget: Icon(type.icon, color: type.color),
      onTap: onTap ?? () => _handleTap(context, ref),
      statusWidget: Wrap(
        spacing: AppDesignTokens.space6,
        runSpacing: AppDesignTokens.space6,
        children: [
          InfoPill(label: type.label, icon: type.icon, color: type.color),
          InfoPill(
            label: notification.targetLabel,
            icon: notification.targetType == 'all'
                ? Icons.public_rounded
                : Icons.person_rounded,
          ),
        ],
      ),
      actions: [
        ActionButtonConfig(
          icon: Icons.delete_outline_rounded,
          color: colorScheme.error,
          onPressed: () => _confirmDelete(context, ref, colorScheme),
        ),
      ],
    );
  }

  void _handleTap(BuildContext context, WidgetRef ref) {
    if (notification.isTicket) {
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
    } else {
      showNotificationDetailsDialog(context, notification);
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
          final result = await ref
              .read(notificationsControllerProvider.notifier)
              .deleteNotification(notification.id);
          result.fold(
            (failure) => AppFeedback.showError(failure.message),
            (_) => AppFeedback.showSuccess('تم حذف الإشعار'),
          );
        },
      ),
    );
  }
}
