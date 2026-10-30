import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/core/theme/responsive.dart';
import '../../domain/entities/support_chat_ticket_entity.dart';
import '../controllers/support_chat_providers.dart';

class SupportChatComposer extends ConsumerStatefulWidget {
  final SupportChatTicketEntity ticket;
  final bool isDark;
  final VoidCallback onMessageSent;

  const SupportChatComposer({
    super.key,
    required this.ticket,
    required this.isDark,
    required this.onMessageSent,
  });

  @override
  ConsumerState<SupportChatComposer> createState() =>
      _SupportChatComposerState();
}

class _SupportChatComposerState extends ConsumerState<SupportChatComposer> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    _textController.clear();
    widget.onMessageSent();

    ref
        .read(supportChatControllerProvider.notifier)
        .sendReply(message: text)
        .then((success) {
          if (!success && mounted) {
            _textController.text = text; // restore on failure
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isMobile = context.isMobile;

    final isInternalNote = ref.watch(
      supportChatControllerProvider.select((s) => s.isInternalNote),
    );
    final replyStatus = ref.watch(
      supportChatControllerProvider.select((s) => s.replyStatus),
    );
    final cannedResponses = ref.watch(
      supportChatControllerProvider.select((s) => s.cannedResponses),
    );

    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Quick Canned Responses Scroll Bar ──────────────────────────────
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Icon(
                  Icons.auto_awesome_rounded,
                  size: 15,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  'ردود سريعة:',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: 8),
                ...cannedResponses.map((template) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ActionChip(
                      backgroundColor: colorScheme.surfaceContainerHigh,
                      side: BorderSide(color: colorScheme.outlineVariant),
                      label: Text(
                        template.length > 32
                            ? '${template.substring(0, 32)}...'
                            : template,
                        style: TextStyle(
                          fontSize: 11,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      onPressed: () {
                        _textController.text = template;
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // ── Type Selector (Reply vs Internal Note) & Status Transition ─────
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
                            Text(
                              isCompact
                                  ? 'رد للعميل'
                                  : 'رد رسمي للعميل (إشعار FCM)',
                            ),
                          ],
                        ),
                        selected: !isInternalNote,
                        selectedColor: colorScheme.primary.withValues(
                          alpha: 0.15,
                        ),
                        onSelected: (_) {
                          if (isInternalNote) {
                            ref
                                .read(supportChatControllerProvider.notifier)
                                .toggleInternalNote();
                          }
                        },
                      ),
                      ChoiceChip(
                        label: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.lock_rounded, size: 14),
                            SizedBox(width: 4),
                            Text('ملاحظة داخلية'),
                          ],
                        ),
                        selected: isInternalNote,
                        selectedColor: Colors.amber.withValues(alpha: 0.25),
                        onSelected: (_) {
                          if (!isInternalNote) {
                            ref
                                .read(supportChatControllerProvider.notifier)
                                .toggleInternalNote();
                          }
                        },
                      ),
                    ],
                  ),
                  if (!isInternalNote)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'تغيير الحالة مع الرد:',
                          style: TextStyle(
                            fontSize: 11,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          height: 32,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: colorScheme.outlineVariant,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String?>(
                              value: replyStatus,
                              hint: Text(
                                'إبقاء الحالية',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: null,
                                  child: Text('إبقاء الحالية'),
                                ),
                                DropdownMenuItem(
                                  value: 'waiting_user',
                                  child: Text('بانتظار العميل'),
                                ),
                                DropdownMenuItem(
                                  value: 'resolved',
                                  child: Text('تم الحل'),
                                ),
                                DropdownMenuItem(
                                  value: 'closed',
                                  child: Text('إغلاق التذكرة'),
                                ),
                              ],
                              onChanged: (val) {
                                ref
                                    .read(
                                      supportChatControllerProvider.notifier,
                                    )
                                    .setReplyStatus(val);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 10),

          // ── Text Input & Send Button ───────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  maxLines: 4,
                  minLines: 1,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _handleSend(),
                  decoration: InputDecoration(
                    hintText: isInternalNote
                        ? 'أضف ملاحظة سرية مرئية لفريق الإشراف فقط...'
                        : 'اكتب الرد الرسمي للعميل هنا...',
                    hintStyle: TextStyle(
                      fontSize: 13,
                      color: colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.6,
                      ),
                    ),
                    filled: true,
                    fillColor: isInternalNote
                        ? Colors.amber.withValues(alpha: 0.08)
                        : colorScheme.surfaceContainerHighest,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: isInternalNote
                            ? Colors.amber.shade600
                            : colorScheme.outlineVariant,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: isInternalNote
                            ? Colors.amber.shade600
                            : colorScheme.outlineVariant,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: isInternalNote
                            ? Colors.amber.shade800
                            : colorScheme.primary,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _handleSend,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isInternalNote
                      ? Colors.amber.shade800
                      : colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Row(
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
}

