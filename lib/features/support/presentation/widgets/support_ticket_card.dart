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
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isSelected
                    ? (isDark
                        ? [
                            Color.lerp(colorScheme.primaryContainer, Colors.black, 0.4)!,
                            Color.lerp(colorScheme.surfaceContainer, Colors.black, 0.2)!,
                          ]
                        : [
                            Color.lerp(colorScheme.primaryContainer, Colors.white, 0.7)!,
                            Colors.white,
                          ])
                    : (isDark
                        ? [
                            Color.lerp(colorScheme.surfaceContainer, Colors.white, 0.02)!,
                            Color.lerp(colorScheme.surfaceContainer, Colors.black, 0.08)!,
                          ]
                        : [
                            Colors.white,
                            Color.lerp(colorScheme.surfaceContainer, Colors.black, 0.02)!,
                          ]),
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: isSelected ? 0.6 : 0.35)
                      : const Color(0xFFA3B1C6).withValues(alpha: isSelected ? 0.45 : 0.25),
                  offset: const Offset(3, 4),
                  blurRadius: isSelected ? 12 : 8,
                ),
                BoxShadow(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.03)
                      : Colors.white.withValues(alpha: 0.9),
                  offset: const Offset(-2, -2),
                  blurRadius: 6,
                ),
              ],
              border: Border.all(
                color: isSelected
                    ? colorScheme.primary
                    : ticket.isUrgent
                        ? Colors.redAccent.withValues(alpha: 0.4)
                        : (isDark
                            ? Colors.white.withValues(alpha: 0.06)
                            : Colors.white.withValues(alpha: 0.8)),
                width: isSelected ? 1.6 : 1,
              ),
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
                    _buildPriorityBadge(ticket.priority),
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
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${ticket.unreadMessagesCount} جديد',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
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
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.06)
                            : Colors.black.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(6),
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
                    _buildStatusPill(ticket.status, ticket.statusArabic),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityBadge(String priority) {
    Color bg;
    Color fg;
    IconData? icon;

    switch (priority) {
      case 'urgent':
        bg = Colors.redAccent.withValues(alpha: 0.15);
        fg = Colors.redAccent;
        icon = Icons.flash_on_rounded;
        break;
      case 'high':
        bg = Colors.orange.withValues(alpha: 0.15);
        fg = Colors.orange;
        break;
      case 'normal':
        bg = Colors.blueGrey.withValues(alpha: 0.12);
        fg = Colors.blueGrey;
        break;
      case 'low':
      default:
        bg = Colors.grey.withValues(alpha: 0.12);
        fg = Colors.grey;
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

  Widget _buildStatusPill(String status, String label) {
    Color bg;
    Color fg;

    switch (status) {
      case 'open':
        bg = Colors.amber.withValues(alpha: 0.15);
        fg = Colors.amber[800]!;
        break;
      case 'in_progress':
        bg = Colors.blue.withValues(alpha: 0.15);
        fg = Colors.blue[700]!;
        break;
      case 'waiting_user':
        bg = Colors.purple.withValues(alpha: 0.15);
        fg = Colors.purple[700]!;
        break;
      case 'resolved':
        bg = Colors.green.withValues(alpha: 0.15);
        fg = Colors.green[700]!;
        break;
      case 'closed':
      default:
        bg = Colors.grey.withValues(alpha: 0.15);
        fg = Colors.grey[700]!;
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
