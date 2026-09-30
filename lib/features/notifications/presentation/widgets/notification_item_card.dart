import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/admin_notification_entity.dart';
import '../controllers/notifications_controller.dart';

class NotificationItemCard extends StatelessWidget {
  final AdminNotificationEntity notification;

  const NotificationItemCard({super.key, required this.notification});

  Color _getTypeColor(String type) {
    switch (type) {
      case 'promo':
        return Colors.orange;
      case 'order':
        return Colors.blue;
      case 'system':
        return Colors.redAccent;
      default:
        return Colors.teal;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'promo':
        return Icons.local_offer_rounded;
      case 'order':
        return Icons.local_shipping_rounded;
      case 'system':
        return Icons.security_rounded;
      default:
        return Icons.campaign_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final typeColor = _getTypeColor(notification.type);
    final controller = Get.find<NotificationsController>();

    final dateStr = notification.createdAt != null
        ? DateFormat('yyyy/MM/dd  •  hh:mm a').format(notification.createdAt!)
        : 'الآن';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  Color.lerp(colorScheme.surfaceContainer, Colors.white, 0.03)!,
                  Color.lerp(colorScheme.surfaceContainer, Colors.black, 0.09)!,
                ]
              : [
                  Color.lerp(colorScheme.surfaceContainer, Colors.white, 0.75)!,
                  Color.lerp(colorScheme.surfaceContainer, Colors.black, 0.03)!,
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.5)
                : const Color(0xFFA3B1C6).withValues(alpha: 0.35),
            offset: const Offset(4, 5),
            blurRadius: 10,
          ),
          BoxShadow(
            color: isDark
                ? Colors.white.withValues(alpha: 0.04)
                : Colors.white.withValues(alpha: 0.95),
            offset: const Offset(-2, -2),
            blurRadius: 6,
          ),
        ],
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.white.withValues(alpha: 0.8),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: Type badge, target chip, date, and delete action
            Row(
              children: [
                // Type badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: typeColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: typeColor.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_getTypeIcon(notification.type), size: 14, color: typeColor),
                      const SizedBox(width: 5),
                      Text(
                        notification.typeLabel,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: typeColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Audience chip
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        notification.targetType == 'all' ? Icons.public_rounded : Icons.person_rounded,
                        size: 13,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        notification.targetLabel,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),

                // Date
                Text(
                  dateStr,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(width: 8),

                // Delete button
                IconButton(
                  icon: Icon(Icons.delete_outline_rounded, size: 20, color: colorScheme.error.withValues(alpha: 0.8)),
                  tooltip: 'حذف الإشعار',
                  onPressed: () {
                    Get.defaultDialog(
                      title: 'تأكيد الحذف',
                      middleText: 'هل أنت متأكد من رغبتك في حذف هذا الإشعار؟',
                      textConfirm: 'حذف',
                      textCancel: 'إلغاء',
                      confirmTextColor: Colors.white,
                      buttonColor: colorScheme.error,
                      onConfirm: () {
                        Get.back();
                        controller.deleteNotification(notification.id);
                      },
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Notification Title
            Text(
              notification.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 6),

            // Notification Body
            Text(
              notification.body,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),

            if (notification.adminName != null) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.shield_outlined, size: 14, color: colorScheme.outline),
                  const SizedBox(width: 4),
                  Text(
                    'أُرسل بواسطة: ${notification.adminName}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
