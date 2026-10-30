import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/core/components/confirm_dialog.dart';
import 'package:stronger_muscles_dashboard/core/theme/responsive.dart';
import '../../domain/entities/support_chat_ticket_entity.dart';
import '../controllers/support_chat_providers.dart';

class SupportChatHeader extends ConsumerWidget {
  final SupportChatTicketEntity ticket;
  final bool isDark;
  final bool showBackButton;
  final VoidCallback? onBack;

  const SupportChatHeader({
    super.key,
    required this.ticket,
    required this.isDark,
    this.showBackButton = false,
    this.onBack,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isMobile = context.isMobile;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 20,
        vertical: isMobile ? 10 : 14,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 620;

          if (isCompact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (showBackButton) ...[
                      IconButton(
                        tooltip: 'العودة',
                        icon: const Icon(Icons.arrow_back_rounded, size: 20),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                        onPressed: onBack ?? () => Navigator.of(context).maybePop(),
                      ),
                      const SizedBox(width: 6),
                    ],
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: colorScheme.primary.withValues(alpha: 0.15),
                      backgroundImage: ticket.userAvatar != null
                          ? CachedNetworkImageProvider(ticket.userAvatar!)
                          : null,
                      child: ticket.userAvatar == null
                          ? Text(
                              ticket.userName.isNotEmpty
                                  ? ticket.userName[0].toUpperCase()
                                  : 'U',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  ticket.userName,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSurface,
                                    fontSize: 14,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '#${ticket.ticketNumber}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            ticket.subject,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'حذف التذكرة',
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        color: colorScheme.error,
                        size: 20,
                      ),
                      onPressed: () => _confirmDelete(context, ref),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatusDropdown(context, ref, colorScheme),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildPriorityDropdown(context, ref, colorScheme),
                    ),
                  ],
                ),
              ],
            );
          }

          // Full Desktop / Wide Layout
          return Row(
            children: [
              if (showBackButton) ...[
                IconButton(
                  tooltip: 'العودة',
                  icon: const Icon(Icons.arrow_back_rounded, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  onPressed: onBack ?? () => Navigator.of(context).maybePop(),
                ),
                const SizedBox(width: 8),
              ],
              CircleAvatar(
                radius: 20,
                backgroundColor: colorScheme.primary.withValues(alpha: 0.15),
                backgroundImage: ticket.userAvatar != null
                    ? CachedNetworkImageProvider(ticket.userAvatar!)
                    : null,
                child: ticket.userAvatar == null
                    ? Text(
                        ticket.userName.isNotEmpty
                            ? ticket.userName[0].toUpperCase()
                            : 'U',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            ticket.userName,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '#${ticket.ticketNumber}',
                            style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          ticket.userEmail,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      ticket.subject,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 140,
                child: _buildStatusDropdown(context, ref, colorScheme),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 120,
                child: _buildPriorityDropdown(context, ref, colorScheme),
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: 'حذف التذكرة',
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: colorScheme.error,
                  size: 20,
                ),
                onPressed: () => _confirmDelete(context, ref),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatusDropdown(
    BuildContext context,
    WidgetRef ref,
    ColorScheme colorScheme,
  ) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: ticket.status,
          isExpanded: true,
          dropdownColor: colorScheme.surfaceContainer,
          items: [
            DropdownMenuItem(
              value: 'open',
              child: Text(
                'مفتوحة',
                style: TextStyle(fontSize: 12, color: colorScheme.onSurface),
              ),
            ),
            DropdownMenuItem(
              value: 'in_progress',
              child: Text(
                'قيد المعالجة',
                style: TextStyle(fontSize: 12, color: colorScheme.onSurface),
              ),
            ),
            DropdownMenuItem(
              value: 'waiting_user',
              child: Text(
                'بانتظار العميل',
                style: TextStyle(fontSize: 12, color: colorScheme.onSurface),
              ),
            ),
            DropdownMenuItem(
              value: 'resolved',
              child: Text(
                'تم الحل',
                style: TextStyle(fontSize: 12, color: colorScheme.onSurface),
              ),
            ),
            DropdownMenuItem(
              value: 'closed',
              child: Text(
                'مغلقة',
                style: TextStyle(fontSize: 12, color: colorScheme.onSurface),
              ),
            ),
          ],
          onChanged: (val) {
            if (val != null && val != ticket.status) {
              ref.read(supportChatControllerProvider.notifier).updateStatus(val);
            }
          },
        ),
      ),
    );
  }

  Widget _buildPriorityDropdown(
    BuildContext context,
    WidgetRef ref,
    ColorScheme colorScheme,
  ) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: ticket.priority,
          isExpanded: true,
          dropdownColor: colorScheme.surfaceContainer,
          items: [
            DropdownMenuItem(
              value: 'urgent',
              child: Text(
                'عاجلة 🔥',
                style: TextStyle(fontSize: 12, color: colorScheme.onSurface),
              ),
            ),
            DropdownMenuItem(
              value: 'high',
              child: Text(
                'مرتفعة',
                style: TextStyle(fontSize: 12, color: colorScheme.onSurface),
              ),
            ),
            DropdownMenuItem(
              value: 'normal',
              child: Text(
                'عادية',
                style: TextStyle(fontSize: 12, color: colorScheme.onSurface),
              ),
            ),
            DropdownMenuItem(
              value: 'low',
              child: Text(
                'منخفضة',
                style: TextStyle(fontSize: 12, color: colorScheme.onSurface),
              ),
            ),
          ],
          onChanged: (val) {
            if (val != null && val != ticket.priority) {
              ref
                  .read(supportChatControllerProvider.notifier)
                  .updatePriority(val);
            }
          },
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => ConfirmDialog(
        title: 'حذف التذكرة',
        message: 'هل أنت متأكد من حذف التذكرة #${ticket.ticketNumber} نهائياً؟',
        confirmText: 'حذف',
        confirmColor: Theme.of(context).colorScheme.error,
        icon: Icons.delete_forever_rounded,
        onConfirm: () async {
          Navigator.of(ctx).pop();
          final success = await ref
              .read(supportChatControllerProvider.notifier)
              .deleteTicket();
          if (success && context.mounted) {
            onBack != null ? onBack!() : Navigator.of(context).maybePop();
          }
        },
      ),
    );
  }
}

