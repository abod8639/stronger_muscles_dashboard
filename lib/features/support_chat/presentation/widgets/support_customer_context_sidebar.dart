import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:stronger_muscles_dashboard/core/router/app_routes.dart';
import 'package:stronger_muscles_dashboard/core/utils/ui_feedback.dart';
import '../../domain/entities/support_chat_ticket_entity.dart';

/// Customer 360° Context Sidebar widget.
/// Provides customer identity, associated e-commerce order details, LTV metrics, and quick action shortcuts.
class SupportCustomerContextSidebar extends StatelessWidget {
  final SupportChatTicketEntity ticket;
  final bool isDark;
  final VoidCallback? onClose;

  const SupportCustomerContextSidebar({
    super.key,
    required this.ticket,
    required this.isDark,
    this.onClose,
  });

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    AppFeedback.showSuccess('تم نسخ $label بنجاح: $text');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final createdStr = DateFormat('yyyy/MM/dd • h:mm a').format(ticket.createdAt);

    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          // ── Header Bar ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Icon(
                  Icons.person_pin_rounded,
                  color: colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'سياق العميل (Customer 360°)',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                if (onClose != null)
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 18),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                    onPressed: onClose,
                  ),
              ],
            ),
          ),
          Divider(height: 1, color: colorScheme.outlineVariant),

          // ── Scrollable Body ─────────────────────────────────────────
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(14),
              children: [
                // 1. Customer Identity Card
                _buildCustomerCard(context, colorScheme, theme),
                const SizedBox(height: 12),

                // 2. Associated E-Commerce Order Card
                _buildOrderCard(context, colorScheme, theme),
                const SizedBox(height: 12),

                // 3. Ticket Details & Timeline
                _buildTicketDetailsCard(context, colorScheme, theme, createdStr),
                const SizedBox(height: 12),

                // 4. Quick Action Shortcuts
                _buildQuickActionsCard(context, colorScheme, theme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerCard(
    BuildContext context,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
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
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 10),
          Text(
            ticket.userName,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              ticket.userId != null ? 'عميل مسجل #${ticket.userId}' : 'عميل زائر',
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Email Row
          if (ticket.userEmail.isNotEmpty)
            _buildInfoRow(
              context,
              icon: Icons.email_outlined,
              label: 'البريد',
              value: ticket.userEmail,
              onCopy: () => _copyToClipboard(context, ticket.userEmail, 'البريد الإلكتروني'),
            ),

          // Phone Row
          if (ticket.userPhone != null && ticket.userPhone!.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildInfoRow(
              context,
              icon: Icons.phone_outlined,
              label: 'الهاتف',
              value: ticket.userPhone!,
              onCopy: () => _copyToClipboard(context, ticket.userPhone!, 'رقم الهاتف'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOrderCard(
    BuildContext context,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    final hasOrder = ticket.orderNumber != null && ticket.orderNumber!.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: hasOrder
            ? colorScheme.primary.withValues(alpha: isDark ? 0.08 : 0.04)
            : colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: hasOrder
              ? colorScheme.primary.withValues(alpha: 0.3)
              : colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                size: 16,
                color: hasOrder ? colorScheme.primary : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(
                'الطلب المرتبط بالشكوى',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (hasOrder) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'رقم الطلب:',
                  style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
                ),
                GestureDetector(
                  onTap: () => _copyToClipboard(context, ticket.orderNumber!, 'رقم الطلب'),
                  child: Row(
                    children: [
                      Text(
                        '#${ticket.orderNumber}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.copy_rounded, size: 12, color: colorScheme.primary),
                    ],
                  ),
                ),
              ],
            ),
            if (ticket.orderTotal != null) ...[
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'قيمة الطلب:',
                    style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
                  ),
                  Text(
                    '${ticket.orderTotal!.toStringAsFixed(2)} ر.س',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 32,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  side: BorderSide(color: colorScheme.primary),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.open_in_new_rounded, size: 14),
                label: const Text('عرض الطلب بالمتجر', style: TextStyle(fontSize: 11)),
                onPressed: () {
                  context.push(AppRoutes.orders);
                },
              ),
            ),
          ] else ...[
            Text(
              'لم يتم ربط هذه التذكرة بطلب شراء محدد.',
              style: TextStyle(
                fontSize: 11,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTicketDetailsCard(
    BuildContext context,
    ColorScheme colorScheme,
    ThemeData theme,
    String createdStr,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.receipt_long_rounded, size: 16, color: colorScheme.primary),
              const SizedBox(width: 6),
              Text(
                'بيانات البلاغ والتذكرة',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildDetailTile('رقم التذكرة', '#${ticket.ticketNumber}', colorScheme),
          _buildDetailTile('القسم', ticket.category, colorScheme),
          _buildDetailTile('الأولوية', ticket.priorityArabic, colorScheme),
          _buildDetailTile('الحالة الحالية', ticket.statusArabic, colorScheme),
          _buildDetailTile('المشرف المسؤول', ticket.assignedAdminName ?? 'غير معين', colorScheme),
          _buildDetailTile('تاريخ الإنشاء', createdStr, colorScheme),
          _buildDetailTile('إجمالي الرسائل', '${ticket.messagesCount} رسالة', colorScheme),
        ],
      ),
    );
  }

  Widget _buildDetailTile(String label, String value, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 10.5, color: colorScheme.onSurfaceVariant),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsCard(
    BuildContext context,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'إجراءات سريعة للمشرف',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          _buildActionButton(
            context,
            icon: Icons.copy_rounded,
            title: 'نسخ ملخص التذكرة',
            onTap: () {
              final summary = '''
تذكرة: #${ticket.ticketNumber}
العميل: ${ticket.userName} (${ticket.userEmail})
الموضوع: ${ticket.subject}
الحالة: ${ticket.statusArabic}
الطلب: ${ticket.orderNumber ?? 'لا يوجد'}
''';
              _copyToClipboard(context, summary, 'ملخص التذكرة');
            },
          ),
          const SizedBox(height: 6),
          _buildActionButton(
            context,
            icon: Icons.people_outline_rounded,
            title: 'عرض ملف العميل في النظام',
            onTap: () {
              context.push(AppRoutes.users);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onCopy,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 14, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 11, color: colorScheme.onSurface),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        IconButton(
          icon: Icon(Icons.copy_rounded, size: 13, color: colorScheme.primary),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
          tooltip: 'نسخ $label',
          onPressed: onCopy,
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, size: 15, color: colorScheme.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            Icon(
              Icons.chevron_left_rounded,
              size: 16,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

