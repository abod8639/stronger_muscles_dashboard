import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:stronger_muscles_dashboard/core/theme/responsive.dart';
import '../../../../core/utils/ui_feedback.dart';
import '../../domain/entities/support_message_entity.dart';
import '../../domain/entities/support_ticket_entity.dart';
import '../controllers/support_controller.dart';
import '../controllers/support_providers.dart';

/// Presentation widget rendering the active support ticket conversation thread,
/// message history, internal notes, canned responses, and reply composer.
class SupportChatView extends ConsumerStatefulWidget {
  const SupportChatView({super.key});

  @override
  ConsumerState<SupportChatView> createState() => _SupportChatViewState();
}

class _SupportChatViewState extends ConsumerState<SupportChatView> {
  final TextEditingController _replyController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _replyController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(supportControllerProvider.select((s) => s.errorMessage),
        (previous, next) {
      if (next != null && next.isNotEmpty) {
        AppFeedback.showError(next);
        ref.read(supportControllerProvider.notifier).clearMessages();
      }
    });

    ref.listen(supportControllerProvider.select((s) => s.successMessage),
        (previous, next) {
      if (next != null && next.isNotEmpty) {
        AppFeedback.showSuccess(next);
        ref.read(supportControllerProvider.notifier).clearMessages();
      }
    });

    final ticket =
        ref.watch(supportControllerProvider.select((s) => s.selectedTicket));
    final isLoadingDetail =
        ref.watch(supportControllerProvider.select((s) => s.isLoadingDetail));
    final isSendingReply =
        ref.watch(supportControllerProvider.select((s) => s.isSendingReply));
    final isInternalNote =
        ref.watch(supportControllerProvider.select((s) => s.isInternalNote));
    final replyStatus =
        ref.watch(supportControllerProvider.select((s) => s.replyStatus));

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    if (ticket == null) {
      return _buildEmptyState(context, isDark);
    }

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: isDark ? 0.3 : 0.08),
            offset: const Offset(0, 4),
            blurRadius: 14,
          ),
        ],
      ),
      child: Column(
        children: [
          // ── 1. Top Ticket Header & Toolbar ───────────────────────────────
          _buildTopHeader(context, ticket, isDark),
          Divider(height: 1, color: colorScheme.outlineVariant),

          // ── 2. Messages List Thread ──────────────────────────────────────
          Expanded(
            child: isLoadingDetail
                ? const Center(child: CircularProgressIndicator())
                : _buildMessagesList(context, ticket, isDark),
          ),
          Divider(height: 1, color: colorScheme.outlineVariant),

          // ── 3. Canned Responses & Reply Composer ─────────────────────────
          _buildReplyComposer(
            context,
            ticket,
            isDark,
            isSendingReply: isSendingReply,
            isInternalNote: isInternalNote,
            replyStatus: replyStatus,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.surfaceContainerHigh,
            ),
            child: Icon(
              Icons.mark_chat_read_outlined,
              size: 56,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'اختر تذكرة للبدء في المراسلة وحل الشكوى',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'يمكنك متابعة المحادثة المباشرة مع العميل وتحديث حالة الطلب وإرسال إشعارات فورية',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTopHeader(
    BuildContext context,
    SupportTicketEntity ticket,
    bool isDark,
  ) {
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
                    if (!context.isDesktop) ...[
                      IconButton(
                        tooltip: 'العودة للتذاكر',
                        icon: const Icon(Icons.arrow_back_rounded, size: 20),
                        padding: EdgeInsets.zero,
                        constraints:
                            const BoxConstraints(minWidth: 32, minHeight: 32),
                        onPressed: () => ref
                            .read(supportControllerProvider.notifier)
                            .setSelectedTicket(null),
                      ),
                      const SizedBox(width: 6),
                    ],
                    CircleAvatar(
                      radius: 18,
                      backgroundColor:
                          colorScheme.primary.withValues(alpha: 0.15),
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
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  ticket.ticketNumber,
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${ticket.userEmail} ${ticket.userPhone != null ? '• ${ticket.userPhone}' : ''}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 11,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'حذف التذكرة',
                      icon: Icon(Icons.delete_outline_rounded,
                          color: colorScheme.error, size: 20),
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints(minWidth: 32, minHeight: 32),
                      onPressed: () => _confirmDeleteTicket(context, ticket),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 38,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
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
                                  child: Text('جديدة',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: colorScheme.onSurface))),
                              DropdownMenuItem(
                                  value: 'in_progress',
                                  child: Text('قيد المعالجة',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: colorScheme.onSurface))),
                              DropdownMenuItem(
                                  value: 'waiting_user',
                                  child: Text('بانتظار العميل',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: colorScheme.onSurface))),
                              DropdownMenuItem(
                                  value: 'resolved',
                                  child: Text('تم الحل',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: colorScheme.onSurface))),
                              DropdownMenuItem(
                                  value: 'closed',
                                  child: Text('مغلقة',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: colorScheme.onSurface))),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                ref
                                    .read(supportControllerProvider.notifier)
                                    .updateTicketStatus(val);
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: 38,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
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
                                  child: Text('عاجلة 🔥',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: colorScheme.onSurface))),
                              DropdownMenuItem(
                                  value: 'high',
                                  child: Text('مرتفعة',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: colorScheme.onSurface))),
                              DropdownMenuItem(
                                  value: 'normal',
                                  child: Text('عادية',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: colorScheme.onSurface))),
                              DropdownMenuItem(
                                  value: 'low',
                                  child: Text('منخفضة',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: colorScheme.onSurface))),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                ref
                                    .read(supportControllerProvider.notifier)
                                    .updateTicketPriority(val);
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }

          return Row(
            children: [
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
                        Text(
                          ticket.userName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            ticket.ticketNumber,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${ticket.userEmail} ${ticket.userPhone != null ? '• ${ticket.userPhone}' : ''}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
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
                    dropdownColor: colorScheme.surfaceContainer,
                    items: [
                      DropdownMenuItem(
                          value: 'open',
                          child: Text('جديدة',
                              style: TextStyle(color: colorScheme.onSurface))),
                      DropdownMenuItem(
                          value: 'in_progress',
                          child: Text('قيد المعالجة',
                              style: TextStyle(color: colorScheme.onSurface))),
                      DropdownMenuItem(
                          value: 'waiting_user',
                          child: Text('بانتظار رد العميل',
                              style: TextStyle(color: colorScheme.onSurface))),
                      DropdownMenuItem(
                          value: 'resolved',
                          child: Text('تم الحل',
                              style: TextStyle(color: colorScheme.onSurface))),
                      DropdownMenuItem(
                          value: 'closed',
                          child: Text('مغلقة',
                              style: TextStyle(color: colorScheme.onSurface))),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        ref
                            .read(supportControllerProvider.notifier)
                            .updateTicketStatus(val);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
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
                    dropdownColor: colorScheme.surfaceContainer,
                    items: [
                      DropdownMenuItem(
                          value: 'urgent',
                          child: Text('عاجلة جداً 🔥',
                              style: TextStyle(color: colorScheme.onSurface))),
                      DropdownMenuItem(
                          value: 'high',
                          child: Text('أولوية مرتفعة',
                              style: TextStyle(color: colorScheme.onSurface))),
                      DropdownMenuItem(
                          value: 'normal',
                          child: Text('أولوية عادية',
                              style: TextStyle(color: colorScheme.onSurface))),
                      DropdownMenuItem(
                          value: 'low',
                          child: Text('منخفضة',
                              style: TextStyle(color: colorScheme.onSurface))),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        ref
                            .read(supportControllerProvider.notifier)
                            .updateTicketPriority(val);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: 'حذف التذكرة',
                icon: Icon(Icons.delete_outline_rounded,
                    color: colorScheme.error, size: 20),
                onPressed: () => _confirmDeleteTicket(context, ticket),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMessagesList(
    BuildContext context,
    SupportTicketEntity ticket,
    bool isDark,
  ) {
    if (ticket.messages.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.chat_bubble_outline_rounded,
                  size: 42,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant
                      .withValues(alpha: 0.4)),
              const SizedBox(height: 10),
              Text(
                'لا توجد رسائل سابقة في هذه التذكرة',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: ticket.messages.length,
      itemBuilder: (context, index) {
        final message = ticket.messages[index];
        return _buildMessageBubble(context, message, isDark);
      },
    );
  }

  Widget _buildMessageBubble(
    BuildContext context,
    SupportMessageEntity message,
    bool isDark,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final timeStr = DateFormat('MM/dd • h:mm a').format(message.createdAt);

    if (message.isInternalNote) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.amber.withValues(alpha: isDark ? 0.12 : 0.2),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.amber.shade700.withValues(alpha: 0.4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lock_rounded, size: 14, color: Colors.amber.shade800),
                const SizedBox(width: 6),
                Text(
                  'ملاحظة داخلية للمشرفين',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade900,
                  ),
                ),
                const Spacer(),
                Text(
                  timeStr,
                  style: TextStyle(
                    fontSize: 10,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              message.message,
              style: TextStyle(fontSize: 13, color: colorScheme.onSurface),
            ),
          ],
        ),
      );
    }

    final isUser = message.isUser;
    final isMobile = context.isMobile;

    return Align(
      alignment: isUser ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        constraints: BoxConstraints(
          maxWidth:
              MediaQuery.of(context).size.width * (isMobile ? 0.82 : 0.50),
        ),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color:
              isUser ? colorScheme.surfaceContainerHigh : colorScheme.primary,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isUser ? 2 : 18),
            bottomRight: Radius.circular(isUser ? 18 : 2),
          ),
          border: isUser ? Border.all(color: colorScheme.outlineVariant) : null,
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.08),
              offset: const Offset(2, 3),
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isUser) ...[
                  Icon(Icons.support_agent_rounded,
                      size: 14, color: colorScheme.onPrimary),
                  const SizedBox(width: 4),
                  Text(
                    message.senderName,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ] else ...[
                  Icon(Icons.person_rounded,
                      size: 14,
                      color: colorScheme.onSurface.withValues(alpha: 0.7)),
                  const SizedBox(width: 4),
                  Text(
                    message.senderName,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 6),
            Text(
              message.message,
              style: TextStyle(
                fontSize: 13.5,
                color: isUser ? colorScheme.onSurface : colorScheme.onPrimary,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              timeStr,
              style: TextStyle(
                fontSize: 10,
                color: isUser
                    ? colorScheme.onSurface.withValues(alpha: 0.6)
                    : colorScheme.onPrimary.withValues(alpha: 0.75),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReplyComposer(
    BuildContext context,
    SupportTicketEntity ticket,
    bool isDark, {
    required bool isSendingReply,
    required bool isInternalNote,
    required String replyStatus,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isMobile = context.isMobile;

    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius:
            const BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Icon(Icons.auto_awesome_rounded,
                    size: 15, color: colorScheme.primary),
                const SizedBox(width: 6),
                Text(
                  'ردود جاهزة وسريعة:',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: 8),
                ...SupportNotifier.cannedResponses.map((template) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ActionChip(
                      backgroundColor: colorScheme.surfaceContainerHigh,
                      side: BorderSide(color: colorScheme.outlineVariant),
                      label: Text(
                        template.length > 35
                            ? '${template.substring(0, 35)}...'
                            : template,
                        style: TextStyle(
                            fontSize: 11, color: colorScheme.onSurface),
                      ),
                      onPressed: () {
                        _replyController.text = template;
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 10),
          LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 620;
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.spaceBetween,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      ChoiceChip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.send_rounded, size: 14),
                            const SizedBox(width: 4),
                            Text(isCompact
                                ? 'رد للعميل'
                                : 'رد رسمي للعميل (إشعار FCM)'),
                          ],
                        ),
                        selected: !isInternalNote,
                        selectedColor:
                            colorScheme.primary.withValues(alpha: 0.15),
                        onSelected: (val) {
                          if (val) {
                            ref
                                .read(supportControllerProvider.notifier)
                                .setInternalNote(false);
                          }
                        },
                      ),
                      ChoiceChip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.lock_outline_rounded,
                                size: 14, color: colorScheme.primary),
                            const SizedBox(width: 4),
                            Text(isCompact
                                ? 'ملاحظة داخلية'
                                : 'ملاحظة داخلية للمشرفين فقط'),
                          ],
                        ),
                        selected: isInternalNote,
                        selectedColor:
                            colorScheme.primary.withValues(alpha: 0.15),
                        onSelected: (val) {
                          if (val) {
                            ref
                                .read(supportControllerProvider.notifier)
                                .setInternalNote(true);
                          }
                        },
                      ),
                    ],
                  ),
                  if (!isInternalNote)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: colorScheme.outlineVariant),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'تغيير الحالة: ',
                            style: TextStyle(
                                fontSize: 11.5, color: colorScheme.onSurface),
                          ),
                          DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: replyStatus,
                              isDense: true,
                              dropdownColor: colorScheme.surfaceContainer,
                              items: const [
                                DropdownMenuItem(
                                    value: 'waiting_user',
                                    child: Text('بانتظار رد العميل')),
                                DropdownMenuItem(
                                    value: 'in_progress',
                                    child: Text('قيد المعالجة')),
                                DropdownMenuItem(
                                    value: 'resolved',
                                    child: Text('تم الحل بنجاح')),
                              ],
                              onChanged: (val) {
                                if (val != null) {
                                  ref
                                      .read(supportControllerProvider.notifier)
                                      .setReplyStatus(val);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: colorScheme.outlineVariant,
                    ),
                  ),
                  child: TextField(
                    controller: _replyController,
                    minLines: 1,
                    maxLines: 4,
                    style: TextStyle(
                      fontSize: 13.5,
                      color: colorScheme.onSurface,
                    ),
                    decoration: InputDecoration(
                      hintText: isInternalNote
                          ? (isMobile
                              ? 'اكتب ملاحظتك الداخلية هنا...'
                              : 'اكتب ملاحظتك الداخلية هنا (ستكون مرئية لفرق الدعم فقط)...')
                          : (isMobile
                              ? 'اكتب ردك للعميل...'
                              : 'اكتب ردك للعميل (سيتم إرسال إشعار فوري عبر فايربيس على جواله)...'),
                      hintStyle: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 14 : 20,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                onPressed: isSendingReply
                    ? null
                    : () async {
                        final text = _replyController.text;
                        final success = await ref
                            .read(supportControllerProvider.notifier)
                            .sendReply(text);
                        if (success) {
                          _replyController.clear();
                        }
                      },
                child: isSendingReply
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorScheme.onPrimary,
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isInternalNote
                                ? Icons.lock_rounded
                                : Icons.send_rounded,
                            size: 18,
                            color: colorScheme.onPrimary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isInternalNote ? 'حفظ' : 'إرسال',
                            style: TextStyle(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDeleteTicket(
    BuildContext context,
    SupportTicketEntity ticket,
  ) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف التذكرة'),
        content: Text(
            'هل أنت متأكد من حذف التذكرة #${ticket.ticketNumber} نهائياً؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text('حذف', style: TextStyle(color: colorScheme.error)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      ref.read(supportControllerProvider.notifier).deleteTicket(ticket.id);
    }
  }
}
