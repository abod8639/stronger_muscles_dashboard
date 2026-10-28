import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/admin_notification_entity.dart';
import '../controllers/notifications_providers.dart';

/// Card widget rendering individual notification item with metadata and action buttons.
class NotificationItemCard extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final typeColor = _getTypeColor(notification.type);

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
                  Color.lerp(colorScheme.surface, Colors.white, 0.85)!,
                  Color.lerp(colorScheme.surface, const Color(0xFFA3B1C6), 0.08)!,
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.35)
                : const Color(0xFFA3B1C6).withValues(alpha: 0.28),
            offset: const Offset(4, 5),
            blurRadius: 10,
          ),
          BoxShadow(
            color: isDark
                ? Colors.white.withValues(alpha: 0.02)
                : Colors.white.withValues(alpha: 0.9),
            offset: const Offset(-3, -3),
            blurRadius: 8,
          ),
        ],
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.white.withValues(alpha: 0.9),
          width: 1.2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Type badge + Target badge + Delete button
            Row(
              children: [
                // Type Badge
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

                // Target Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        notification.targetType == 'all'
                            ? Icons.public_rounded
                            : Icons.person_rounded,
                        size: 13,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
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

                // Delete button with confirmation
                IconButton(
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    size: 20,
                    color: colorScheme.error.withValues(alpha: 0.8),
                  ),
                  tooltip: 'حذف الإشعار',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('تأكيد الحذف'),
                        content: const Text('هل أنت متأكد من رغبتك في حذف هذا الإشعار؟'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: const Text('إلغاء'),
                          ),
                          FilledButton(
                            style: FilledButton.styleFrom(backgroundColor: colorScheme.error),
                            onPressed: () {
                              Navigator.of(ctx).pop();
                              ref
                                  .read(notificationsControllerProvider.notifier)
                                  .deleteNotification(notification.id);
                            },
                            child: const Text('حذف'),
                          ),
                        ],
                      ),
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

            // Footer metadata: Date & Admin
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: 13,
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                ),
                const SizedBox(width: 5),
                Text(
                  dateStr,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                    fontSize: 11,
                  ),
                ),
                if (notification.adminName != null) ...[
                  const Spacer(),
                  Icon(Icons.shield_outlined, size: 13, color: colorScheme.outline),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      'أُرسل بواسطة: ${notification.adminName}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.outline,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
