import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:stronger_muscles_dashboard/core/components/confirm_dialog.dart';
import 'package:stronger_muscles_dashboard/core/components/generic_list_card.dart';
import 'package:stronger_muscles_dashboard/core/components/info_pill.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';
import 'package:stronger_muscles_dashboard/core/utils/ui_feedback.dart';
import '../../domain/entities/admin_notification_entity.dart';
import '../controllers/notifications_providers.dart';
import 'notification_type_ui.dart';

/// Card widget rendering individual notification item with metadata and action buttons.
class NotificationItemCard extends ConsumerWidget {
  final AdminNotificationEntity notification;

  const NotificationItemCard({super.key, required this.notification});

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
