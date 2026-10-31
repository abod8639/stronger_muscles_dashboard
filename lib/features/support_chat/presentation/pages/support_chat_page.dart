import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/core/utils/ui_feedback.dart';
import '../../domain/entities/support_chat_ticket_entity.dart';
import '../controllers/support_chat_providers.dart';
import '../widgets/support_chat_bubble.dart';
import '../widgets/support_chat_composer.dart';
import '../widgets/support_chat_header.dart';
import '../widgets/support_customer_context_sidebar.dart';

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
  bool _showScrollToBottom = false;
  bool _showCustomerContext = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
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

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final isScrolledUp = _scrollController.offset > 150;
    if (isScrolledUp != _showScrollToBottom) {
      setState(() => _showScrollToBottom = isScrolledUp);
    }
  }

  @override
  void didUpdateWidget(covariant SupportChatPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.ticketId != null && widget.ticketId != oldWidget.ticketId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ref
            .read(supportChatControllerProvider.notifier)
            .loadTicket(widget.ticketId!, initialTicket: widget.initialTicket);
        _scrollToBottom(immediate: true);
      });
    } else if (widget.initialTicket != null &&
        (oldWidget.initialTicket == null ||
            widget.initialTicket!.id != oldWidget.initialTicket!.id ||
            widget.initialTicket!.messages.length !=
                oldWidget.initialTicket!.messages.length ||
            widget.initialTicket!.status != oldWidget.initialTicket!.status ||
            widget.initialTicket!.priority !=
                oldWidget.initialTicket!.priority ||
            widget.initialTicket!.assignedAdminId !=
                oldWidget.initialTicket!.assignedAdminId)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ref
            .read(supportChatControllerProvider.notifier)
            .syncInitialTicket(widget.initialTicket!);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom({bool immediate = false}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        if (immediate) {
          _scrollController.jumpTo(0.0);
        } else {
          _scrollController.animateTo(
            0.0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
          );
        }
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
        Future.microtask(() {
          if (mounted) {
            ref.read(supportChatControllerProvider.notifier).clearMessages();
          }
        });
      }
    });

    ref.listen(supportChatControllerProvider.select((s) => s.successMessage), (
      previous,
      next,
    ) {
      if (next != null && next.isNotEmpty) {
        AppFeedback.showSuccess(next);
        Future.microtask(() {
          if (mounted) {
            ref.read(supportChatControllerProvider.notifier).clearMessages();
          }
        });
      }
    });

    final activeTicket = ref.watch(
      supportChatControllerProvider.select((s) => s.ticket),
    );
    final isLoading = ref.watch(
      supportChatControllerProvider.select((s) => s.isLoading),
    );

    // Resolve effective ticket: prefer state ticket if loaded, or fallback to initialTicket
    final ticket = (activeTicket != null && activeTicket.messages.isNotEmpty)
        ? activeTicket
        : (widget.initialTicket != null &&
                widget.initialTicket!.messages.isNotEmpty)
            ? widget.initialTicket
            : (activeTicket ?? widget.initialTicket);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    Widget body;
    if (ticket == null && isLoading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (ticket == null) {
      body = _buildEmptyState(context, isDark);
    } else {
      final screenWidth = MediaQuery.of(context).size.width;
      final canShowInline = screenWidth >= 1300;

      void toggleCustomerContext() {
        if (!canShowInline) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (ctx) => Container(
              height: MediaQuery.of(context).size.height * 0.85,
              padding: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SupportCustomerContextSidebar(
                ticket: ticket,
                isDark: isDark,
                onClose: () => Navigator.of(ctx).pop(),
              ),
            ),
          );
        } else {
          setState(() => _showCustomerContext = !_showCustomerContext);
        }
      }

      final chatBox = Container(
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
              onToggleCustomerContext: toggleCustomerContext,
              isCustomerContextVisible: _showCustomerContext && canShowInline,
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

      if (_showCustomerContext && canShowInline) {
        body = Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: chatBox),
            const SizedBox(width: 12),
            SupportCustomerContextSidebar(
              ticket: ticket,
              isDark: isDark,
              onClose: () => setState(() => _showCustomerContext = false),
            ),
          ],
        );
      } else {
        body = chatBox;
      }
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

    return Stack(
      children: [
        ListView.builder(
          key: ValueKey('chat_messages_${ticket.id}'),
          controller: _scrollController,
          reverse: true,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: ticket.messages.length,
          itemBuilder: (context, index) {
            // In reversed list, index 0 is the newest message
            final message = ticket.messages[ticket.messages.length - 1 - index];
            return SupportChatBubble(
              key: ValueKey(
                'msg_${message.id}_${message.createdAt.millisecondsSinceEpoch}_$index',
              ),
              message: message,
              isDark: isDark,
              onRetry: message.isFailed
                  ? () => ref
                      .read(supportChatControllerProvider.notifier)
                      .retryMessage(message)
                  : null,
            );
          },
        ),
        if (_showScrollToBottom)
          Positioned(
            bottom: 14,
            left: 14,
            child: FloatingActionButton.small(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
              onPressed: () => _scrollToBottom(),
              tooltip: 'الانتقال لآخر رسالة',
              child: const Icon(Icons.arrow_downward_rounded, size: 20),
            ),
          ),
      ],
    );
  }
}

