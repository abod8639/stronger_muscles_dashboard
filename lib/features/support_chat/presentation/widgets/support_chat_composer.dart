import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
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
  late final FocusNode _focusNode;
  final List<String> _pendingAttachments = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode(onKeyEvent: _handleKeyEvent);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
      if (HardwareKeyboard.instance.isShiftPressed) {
        return KeyEventResult.ignored; // Shift+Enter inserts newline
      } else {
        _handleSend(); // Enter sends reply
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  Future<void> _pickAttachment() async {
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (picked != null) {
        setState(() {
          _pendingAttachments.add(picked.path);
        });
      }
    } catch (e) {
      debugPrint('Error picking attachment: $e');
    }
  }

  void _handleSend() {
    final text = _textController.text.trim();
    if (text.isEmpty && _pendingAttachments.isEmpty) return;

    final attachments = _pendingAttachments.isNotEmpty
        ? List<String>.from(_pendingAttachments)
        : null;

    _textController.clear();
    setState(() {
      _pendingAttachments.clear();
    });
    widget.onMessageSent();

    ref
        .read(supportChatControllerProvider.notifier)
        .sendReply(
          message: text.isNotEmpty ? text : 'مرفق',
          attachments: attachments,
        );
  }

  void _applyCannedResponse(String template) {
    String resolved = template
        .replaceAll('{{name}}', widget.ticket.userName)
        .replaceAll('{{ticket_number}}', widget.ticket.ticketNumber)
        .replaceAll('{{ticket}}', '#${widget.ticket.ticketNumber}')
        .replaceAll('{{email}}', widget.ticket.userEmail);

    if (widget.ticket.orderNumber != null &&
        widget.ticket.orderNumber!.isNotEmpty) {
      resolved = resolved.replaceAll('{{order}}', '#${widget.ticket.orderNumber}');
    } else {
      resolved = resolved.replaceAll('{{order}}', 'طلبك');
    }

    _textController.text = resolved;
    _textController.selection = TextSelection.collapsed(
      offset: resolved.length,
    );
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
                      onPressed: () => _applyCannedResponse(template),
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

          // ── Pending Attachments Preview ──────────────────────────────────
          if (_pendingAttachments.isNotEmpty) ...[
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _pendingAttachments.map((path) {
                  return Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 8, bottom: 8),
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: colorScheme.outlineVariant),
                          color: colorScheme.surfaceContainerHigh,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: kIsWeb
                            ? Image.network(path, fit: BoxFit.cover)
                            : Image.file(File(path), fit: BoxFit.cover),
                      ),
                      Positioned(
                        top: 2,
                        left: 10,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _pendingAttachments.remove(path);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.black87,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close_rounded,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],

          // ── Text Input & Send Button ───────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                tooltip: 'إرفاق صورة أو مستند',
                icon: Icon(
                  Icons.attach_file_rounded,
                  color: colorScheme.onSurfaceVariant,
                  size: 22,
                ),
                onPressed: _pickAttachment,
              ),
              Expanded(
                child: TextField(
                  controller: _textController,
                  focusNode: _focusNode,
                  maxLines: 4,
                  minLines: 1,
                  decoration: InputDecoration(
                    hintText: isInternalNote
                        ? 'أضف ملاحظة سرية للمشرفين... (Enter للحفظ)'
                        : 'اكتب الرد الرسمي للعميل... (Enter للإرسال، Shift + Enter لسطر جديد)',
                    hintStyle: TextStyle(
                      fontSize: 12.5,
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

