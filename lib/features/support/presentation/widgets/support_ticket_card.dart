import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/support_ticket_entity.dart';

class SupportTicketCard extends StatelessWidget {
  final SupportTicketEntity ticket;
  final bool isSelected;
  final VoidCallback onTap;

  const SupportTicketCard({
    super.key,
    required this.ticket,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final dateStr = DateFormat('MM/dd • h:mm a').format(ticket.lastReplyAt ?? ticket.createdAt);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isSelected
                  ? colorScheme.primaryContainer.withValues(alpha: isDark ? 0.35 : 0.6)
                  : colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? colorScheme.primary
                    : ticket.isUrgent
                        ? colorScheme.error.withValues(alpha: 0.5)
                        : colorScheme.outlineVariant,
                width: isSelected ? 1.5 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: isSelected ? (isDark ? 0.35 : 0.08) : (isDark ? 0.2 : 0.03)),
                  offset: const Offset(0, 2),
                  blurRadius: isSelected ? 8 : 4,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Row 1: Ticket Number, Priority & Time ────────────────────
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: ticket.ticketNumber));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('تم نسخ رقم التذكرة: ${ticket.ticketNumber}'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              ticket.ticketNumber,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.copy_rounded, size: 11, color: colorScheme.primary),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    _buildPriorityBadge(context, ticket.priority),
                    const Spacer(),
                    Text(
                      dateStr,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // ── Row 2: Subject Title ─────────────────────────────────────
                Text(
                  ticket.subject,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),

                // ── Row 3: Customer Info & Avatar ────────────────────────────
                Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      backgroundImage: ticket.userAvatar != null
                          ? CachedNetworkImageProvider(ticket.userAvatar!)
                          : null,
                      child: ticket.userAvatar == null
                          ? Text(
                              ticket.userName.isNotEmpty ? ticket.userName[0].toUpperCase() : 'U',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        ticket.userName,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (ticket.unreadMessagesCount > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: colorScheme.error,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${ticket.unreadMessagesCount} جديد',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onError,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),

                // ── Row 4: Category & Status Badge ───────────────────────────
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.6)),
                      ),
                      child: Text(
                        ticket.categoryArabic,
                        style: TextStyle(
                          fontSize: 10,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const Spacer(),
                    _buildStatusPill(context, ticket.status, ticket.statusArabic),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityBadge(BuildContext context, String priority) {
    final colorScheme = Theme.of(context).colorScheme;
    Color bg;
    Color fg;
    IconData? icon;

    switch (priority) {
      case 'urgent':
        bg = colorScheme.error.withValues(alpha: 0.15);
        fg = colorScheme.error;
        icon = Icons.flash_on_rounded;
        break;
      case 'high':
        bg = colorScheme.tertiary.withValues(alpha: 0.15);
        fg = colorScheme.tertiary;
        break;
      case 'normal':
        bg = colorScheme.secondary.withValues(alpha: 0.12);
        fg = colorScheme.secondary;
        break;
      case 'low':
      default:
        bg = colorScheme.surfaceContainerHighest;
        fg = colorScheme.onSurfaceVariant;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: fg),
            const SizedBox(width: 2),
          ],
          Text(
            priority == 'urgent'
                ? 'عاجل'
                : priority == 'high'
                    ? 'مرتفع'
                    : priority == 'low'
                        ? 'منخفض'
                        : 'عادي',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusPill(BuildContext context, String status, String label) {
    final colorScheme = Theme.of(context).colorScheme;
    Color bg;
    Color fg;

    switch (status) {
      case 'open':
        bg = colorScheme.primaryContainer;
        fg = colorScheme.onPrimaryContainer;
        break;
      case 'in_progress':
        bg = colorScheme.secondaryContainer;
        fg = colorScheme.onSecondaryContainer;
        break;
      case 'waiting_user':
        bg = colorScheme.tertiaryContainer;
        fg = colorScheme.onTertiaryContainer;
        break;
      case 'resolved':
        bg = colorScheme.surfaceContainerHighest;
        fg = colorScheme.primary;
        break;
      case 'closed':
      default:
        bg = colorScheme.surfaceContainerHigh;
        fg = colorScheme.onSurfaceVariant;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: fg,
        ),
      ),
    );
  }
}
