import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/core/utils/ui_feedback.dart';
import '../../domain/entities/support_chat_ticket_entity.dart';
import '../controllers/support_chat_providers.dart';
import '../widgets/support_chat_bubble.dart';
import '../widgets/support_chat_composer.dart';
import '../widgets/support_chat_header.dart';

/// Clean Architecture Presentation Page for the Support Chat conversation feature.
/// Can be used as a standalone screen via GoRouter or embedded within split-screen layouts.
class SupportChatPage extends ConsumerStatefulWidget {
  final int? ticketId;
  final SupportChatTicketEntity? initialTicket;
  final bool isEmbedded;
  final VoidCallback? onBack;

  const SupportChatPage({
    super.key,
    this.ticketId,
    this.initialTicket,
    this.isEmbedded = false,
    this.onBack,
  });

  @override
  ConsumerState<SupportChatPage> createState() => _SupportChatPageState();
}

class _SupportChatPageState extends ConsumerState<SupportChatPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.ticketId != null) {
        ref
            .read(supportChatControllerProvider.notifier)
            .loadTicket(widget.ticketId!, initialTicket: widget.initialTicket);
      } else if (widget.initialTicket != null) {
        ref
            .read(supportChatControllerProvider.notifier)
            .setTicket(widget.initialTicket);
      }
    });
  }

  @override
  void didUpdateWidget(covariant SupportChatPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.ticketId != null && widget.ticketId != oldWidget.ticketId) {
      ref
          .read(supportChatControllerProvider.notifier)
          .loadTicket(widget.ticketId!, initialTicket: widget.initialTicket);
      _scrollToBottom();
    }
  }

  @override
  void dispose() {
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
    ref.listen(supportChatControllerProvider.select((s) => s.errorMessage), (
      previous,
      next,
    ) {
      if (next != null && next.isNotEmpty) {
        AppFeedback.showError(next);
        ref.read(supportChatControllerProvider.notifier).clearMessages();
      }
    });

    ref.listen(supportChatControllerProvider.select((s) => s.successMessage), (
      previous,
      next,
    ) {
      if (next != null && next.isNotEmpty) {
        AppFeedback.showSuccess(next);
        ref.read(supportChatControllerProvider.notifier).clearMessages();
      }
    });

    final ticket = ref.watch(
      supportChatControllerProvider.select((s) => s.ticket),
    );
    final isLoading = ref.watch(
      supportChatControllerProvider.select((s) => s.isLoading),
    );

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    Widget body;
    if (ticket == null && isLoading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (ticket == null) {
      body = _buildEmptyState(context, isDark);
    } else {
      body = Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: widget.isEmbedded
              ? BorderRadius.circular(24)
              : BorderRadius.zero,
          border: widget.isEmbedded
              ? Border.all(color: colorScheme.outlineVariant, width: 1)
              : null,
          boxShadow: widget.isEmbedded
              ? [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(
                      alpha: isDark ? 0.3 : 0.08,
                    ),
                    offset: const Offset(0, 4),
                    blurRadius: 14,
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            // ── 1. Top Ticket Header & Toolbar ───────────────────────────────
            SupportChatHeader(
              ticket: ticket,
              isDark: isDark,
              showBackButton: !widget.isEmbedded || widget.onBack != null,
              onBack: widget.onBack,
            ),
            Divider(height: 1, color: colorScheme.outlineVariant),

            // ── 2. Conversation Messages Thread ──────────────────────────────
            Expanded(
              child: isLoading && ticket.messages.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : _buildMessagesList(context, ticket, isDark),
            ),
            Divider(height: 1, color: colorScheme.outlineVariant),

            // ── 3. Reply Composer & Fast Canned Responses ────────────────────
            SupportChatComposer(
              ticket: ticket,
              isDark: isDark,
              onMessageSent: _scrollToBottom,
            ),
          ],
        ),
      );
    }

    if (widget.isEmbedded) {
      return body;
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(child: body),
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

  Widget _buildMessagesList(
    BuildContext context,
    SupportChatTicketEntity ticket,
    bool isDark,
  ) {
    if (ticket.messages.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.chat_bubble_outline_rounded,
                size: 42,
                color: Theme.of(
                  context,
                ).colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
              ),
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
      key: ValueKey('chat_messages_${ticket.id}'),
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: ticket.messages.length,
      itemBuilder: (context, index) {
        final message = ticket.messages[index];
        return SupportChatBubble(message: message, isDark: isDark);
      },
    );
  }
}

