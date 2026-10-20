import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/support_message_entity.dart';
import '../../domain/entities/support_ticket_entity.dart';
import '../controllers/support_controller.dart';

class SupportChatView extends GetView<SupportController> {
  const SupportChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Obx(() {
      final ticket = controller.selectedTicket.value;

      if (ticket == null) {
        return _buildEmptyState(context, isDark);
      }

      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    Color.lerp(colorScheme.surfaceContainer, Colors.white, 0.02)!,
                    Color.lerp(colorScheme.surfaceContainer, Colors.black, 0.08)!,
                  ]
                : [
                    Colors.white,
                    Color.lerp(colorScheme.surfaceContainer, Colors.black, 0.02)!,
                  ],
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.5)
                  : const Color(0xFFA3B1C6).withValues(alpha: 0.3),
              offset: const Offset(4, 5),
              blurRadius: 14,
            ),
          ],
          border: Border.all(
            color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white.withValues(alpha: 0.8),
            width: 1.2,
          ),
        ),
        child: Column(
          children: [
            // ── 1. Top Ticket Header & Toolbar ───────────────────────────────
            _buildTopHeader(context, ticket, isDark),
            const Divider(height: 1),

            // ── 2. Messages List Thread ──────────────────────────────────────
            Expanded(
              child: controller.isLoadingDetail.value
                  ? const Center(child: CircularProgressIndicator())
                  : _buildMessagesList(context, ticket, isDark),
            ),
            const Divider(height: 1),

            // ── 3. Canned Responses & Reply Composer ─────────────────────────
            _buildReplyComposer(context, ticket, isDark),
          ],
        ),
      );
    });
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
              color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.04),
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

  Widget _buildTopHeader(BuildContext context, SupportTicketEntity ticket, bool isDark) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? Colors.black.withValues(alpha: 0.15) : Colors.grey.withValues(alpha: 0.04),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: colorScheme.primary.withValues(alpha: 0.15),
                backgroundImage: ticket.userAvatar != null
                    ? CachedNetworkImageProvider(ticket.userAvatar!)
                    : null,
                child: ticket.userAvatar == null
                    ? Text(
                        ticket.userName.isNotEmpty ? ticket.userName[0].toUpperCase() : 'U',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 14),
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
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.1),
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

              // Status Dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? Colors.white12 : Colors.black12,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: ticket.status,
                    dropdownColor: isDark ? colorScheme.surfaceContainer : Colors.white,
                    items: const [
                      DropdownMenuItem(value: 'open', child: Text('تذكرة جديدة')),
                      DropdownMenuItem(value: 'in_progress', child: Text('قيد المعالجة')),
                      DropdownMenuItem(value: 'waiting_user', child: Text('بانتظار العميل')),
                      DropdownMenuItem(value: 'resolved', child: Text('تم الحل بنجاح')),
                      DropdownMenuItem(value: 'closed', child: Text('مغلقة')),
                    ],
                    onChanged: (val) {
                      if (val != null) controller.updateTicketStatus(val);
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Priority Dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? Colors.white12 : Colors.black12,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: ticket.priority,
                    dropdownColor: isDark ? colorScheme.surfaceContainer : Colors.white,
                    items: const [
                      DropdownMenuItem(value: 'urgent', child: Text('عاجلة جداً 🔥')),
                      DropdownMenuItem(value: 'high', child: Text('أولوية مرتفعة')),
                      DropdownMenuItem(value: 'normal', child: Text('أولوية عادية')),
                      DropdownMenuItem(value: 'low', child: Text('منخفضة')),
                    ],
                    onChanged: (val) {
                      if (val != null) controller.updateTicketPriority(val);
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Delete button
              IconButton(
                tooltip: 'حذف التذكرة',
                icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                onPressed: () async {
                  final confirmed = await Get.dialog<bool>(
                    AlertDialog(
                      title: const Text('حذف التذكرة'),
                      content: Text('هل أنت متأكد من حذف التذكرة #${ticket.ticketNumber} نهائياً؟'),
                      actions: [
                        TextButton(onPressed: () => Get.back(result: false), child: const Text('إلغاء')),
                        TextButton(
                          onPressed: () => Get.back(result: true),
                          child: const Text('حذف', style: TextStyle(color: Colors.redAccent)),
                        ),
                      ],
                    ),
                  );

                  if (confirmed == true) {
                    controller.deleteTicket(ticket.id);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Subject & Order Link row
          Row(
            children: [
              Expanded(
                child: Text(
                  'الموضوع: ${ticket.subject}',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              if (ticket.orderNumber != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.teal.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.teal.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.shopping_bag_outlined, size: 14, color: Colors.teal),
                      const SizedBox(width: 4),
                      Text(
                        'طلب مرتبط: #${ticket.orderNumber}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList(BuildContext context, SupportTicketEntity ticket, bool isDark) {
    if (ticket.messages.isEmpty) {
      return const Center(child: Text('لا توجد رسائل في هذه التذكرة'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: ticket.messages.length,
      itemBuilder: (context, index) {
        final message = ticket.messages[index];
        return _buildMessageBubble(context, message, isDark);
      },
    );
  }

  Widget _buildMessageBubble(BuildContext context, SupportMessageEntity message, bool isDark) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final timeStr = DateFormat('yyyy/MM/dd • h:mm a').format(message.createdAt);

    if (message.isInternalNote) {
      // Internal Note Bubble (Yellow/Amber Alert style)
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF332A15) : const Color(0xFFFFFBEB),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.amber.withValues(alpha: 0.4),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.lock_rounded, size: 15, color: Colors.amber),
                const SizedBox(width: 6),
                Text(
                  'ملاحظة داخلية للمشرفين (مخفية عن العميل) • بواسطة ${message.senderName}',
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
                const Spacer(),
                Text(
                  timeStr,
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark ? Colors.amber[200] : Colors.amber[900],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              message.message,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      );
    }

    final isUser = message.isUser;

    return Align(
      alignment: isUser ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.45,
        ),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isUser ? 2 : 18),
            bottomRight: Radius.circular(isUser ? 18 : 2),
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isUser
                ? (isDark
                    ? [const Color(0xFF262626), const Color(0xFF1E1E1E)]
                    : [const Color(0xFFF3F4F6), const Color(0xFFE5E7EB)])
                : [
                    colorScheme.primary,
                    Color.lerp(colorScheme.primary, Colors.black, 0.2)!,
                  ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              offset: const Offset(2, 3),
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: isUser ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isUser) ...[
                  const Icon(Icons.support_agent_rounded, size: 14, color: Colors.white),
                  const SizedBox(width: 4),
                  Text(
                    message.senderName,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ] else ...[
                  const Icon(Icons.person_rounded, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    message.senderName,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.grey[300] : Colors.grey[800],
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
                color: isUser
                    ? (isDark ? Colors.white : Colors.black87)
                    : Colors.white,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              timeStr,
              style: TextStyle(
                fontSize: 10,
                color: isUser
                    ? (isDark ? Colors.grey[400] : Colors.grey[600])
                    : Colors.white.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReplyComposer(BuildContext context, SupportTicketEntity ticket, bool isDark) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.black.withValues(alpha: 0.15) : Colors.grey.withValues(alpha: 0.03),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Canned Responses Quick Chips ───────────────────────────────────
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const Icon(Icons.auto_awesome_rounded, size: 15, color: Colors.amber),
                const SizedBox(width: 6),
                Text(
                  'ردود جاهزة وسريعة:',
                  style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                ...controller.cannedResponses.map((template) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ActionChip(
                      label: Text(
                        template.length > 35 ? '${template.substring(0, 35)}...' : template,
                        style: const TextStyle(fontSize: 11),
                      ),
                      onPressed: () => controller.insertCannedResponse(template),
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // ── Toggle: Reply vs Internal Note ─────────────────────────────────
          Row(
            children: [
              Obx(() => ChoiceChip(
                    label: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.send_rounded, size: 14),
                        SizedBox(width: 4),
                        Text('رد رسمي للعميل (إشعار FCM)'),
                      ],
                    ),
                    selected: !controller.isInternalNote.value,
                    selectedColor: colorScheme.primary.withValues(alpha: 0.15),
                    onSelected: (val) {
                      if (val) controller.isInternalNote.value = false;
                    },
                  )),
              const SizedBox(width: 8),
              Obx(() => ChoiceChip(
                    label: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.lock_outline_rounded, size: 14, color: Colors.amber),
                        SizedBox(width: 4),
                        Text('ملاحظة داخلية للمشرفين فقط'),
                      ],
                    ),
                    selected: controller.isInternalNote.value,
                    selectedColor: Colors.amber.withValues(alpha: 0.18),
                    onSelected: (val) {
                      if (val) controller.isInternalNote.value = true;
                    },
                  )),
              const Spacer(),
              Obx(() {
                if (controller.isInternalNote.value) return const SizedBox.shrink();
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('تغيير الحالة عند الإرسال: ', style: TextStyle(fontSize: 11.5)),
                    DropdownButton<String>(
                      value: controller.replyStatus.value,
                      isDense: true,
                      dropdownColor: isDark ? colorScheme.surfaceContainer : Colors.white,
                      items: const [
                        DropdownMenuItem(value: 'waiting_user', child: Text('بانتظار رد العميل')),
                        DropdownMenuItem(value: 'in_progress', child: Text('قيد المعالجة')),
                        DropdownMenuItem(value: 'resolved', child: Text('تم الحل بنجاح')),
                      ],
                      onChanged: (val) {
                        if (val != null) controller.replyStatus.value = val;
                      },
                    ),
                  ],
                );
              }),
            ],
          ),
          const SizedBox(height: 10),

          // ── Textarea & Send Button ─────────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? colorScheme.surfaceContainer : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? Colors.white12 : Colors.black12,
                    ),
                  ),
                  child: TextField(
                    controller: controller.replyController,
                    minLines: 2,
                    maxLines: 5,
                    style: TextStyle(
                      fontSize: 13.5,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    decoration: InputDecoration(
                      hintText: controller.isInternalNote.value
                          ? 'اكتب ملاحظتك الداخلية هنا (ستكون مرئية لفرق الدعم فقط)...'
                          : 'اكتب ردك للعميل (سيتم إرسال إشعار فوري عبر فايربيس على جواله)...',
                      hintStyle: const TextStyle(fontSize: 12.5, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Obx(() => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: controller.isInternalNote.value
                          ? Colors.amber[800]
                          : colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 3,
                    ),
                    onPressed: controller.isSendingReply.value ? null : () => controller.sendReply(),
                    child: controller.isSendingReply.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                controller.isInternalNote.value
                                    ? Icons.lock_rounded
                                    : Icons.send_rounded,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(controller.isInternalNote.value ? 'حفظ الملاحظة' : 'إرسال الرد'),
                            ],
                          ),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
