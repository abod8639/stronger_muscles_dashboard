import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/responsive.dart';
import '../controllers/support_controller.dart';
import '../widgets/support_chat_view.dart';
import '../widgets/support_stats_header.dart';
import '../widgets/support_ticket_card.dart';

class SupportScreen extends GetView<SupportController> {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isDesktop = responsive.screenWidth >= 950;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Title & Search Bar ───────────────────────────────────────
            _buildHeader(context, isDark),

            // ── KPI Stats Header ─────────────────────────────────────────────
            const SupportStatsHeader(),
            const SizedBox(height: 8),

            // ── Filters & Category Bar ───────────────────────────────────────
            _buildFiltersBar(context, isDark),
            const SizedBox(height: 10),

            // ── Main Content: Split Master-Detail or Responsive ──────────────
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.defaultPadding.left,
                ),
                child: Obx(() {
                  if (controller.isLoading.value && controller.tickets.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.tickets.isEmpty) {
                    return _buildNoTicketsState(context, isDark);
                  }

                  if (isDesktop) {
                    // Desktop Master-Detail split
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Pane: Tickets List
                        SizedBox(
                          width: 380,
                          child: _buildTicketsList(context, isDark),
                        ),
                        const SizedBox(width: 14),

                        // Right Pane: Chat & Resolution Workspace
                        const Expanded(
                          child: SupportChatView(),
                        ),
                      ],
                    );
                  } else {
                    // Mobile / Tablet Navigation
                    if (controller.selectedTicket.value != null) {
                      return Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton.icon(
                              onPressed: () => controller.selectedTicket.value = null,
                              icon: const Icon(Icons.arrow_back_rounded, size: 18),
                              label: const Text('العودة لقائمة التذاكر'),
                            ),
                          ),
                          const Expanded(child: SupportChatView()),
                        ],
                      );
                    }
                    return _buildTicketsList(context, isDark);
                  }
                }),
              ),
            ),
            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final responsive = context.responsive;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        responsive.defaultPadding.left,
        14,
        responsive.defaultPadding.right,
        10,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.primary.withValues(alpha: 0.12),
            ),
            child: Icon(Icons.support_agent_rounded, color: colorScheme.primary, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'الدعم الفني والشكاوى ومراسلة العملاء',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  'متابعة البلاغات والرد الفوري مع إشعارات Push وتحديثات Real-time عبر فايربيس',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Refresh Button
          IconButton(
            tooltip: 'تحديث البيانات',
            style: IconButton.styleFrom(
              backgroundColor: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
              padding: const EdgeInsets.all(10),
            ),
            icon: const Icon(Icons.refresh_rounded, size: 20),
            onPressed: () => controller.fetchTickets(),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersBar(BuildContext context, bool isDark) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final responsive = context.responsive;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: responsive.defaultPadding.left),
      child: Column(
        children: [
          // Search + Priority Filter row
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  decoration: BoxDecoration(
                    color: isDark ? colorScheme.surfaceContainer : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isDark ? Colors.white12 : Colors.black12,
                    ),
                  ),
                  child: TextField(
                    onChanged: (val) => controller.searchQuery.value = val,
                    style: TextStyle(fontSize: 13, color: isDark ? Colors.white : Colors.black87),
                    decoration: InputDecoration(
                      hintText: 'ابحث برقم التذكرة، اسم العميل، البريد، أو الموضوع...',
                      hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
                      prefixIcon: const Icon(Icons.search_rounded, size: 18),
                      suffixIcon: Obx(() {
                        if (controller.searchQuery.value.isNotEmpty) {
                          return IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 16),
                            onPressed: () => controller.searchQuery.value = '',
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Priority Filter Dropdown
              Container(
                height: 42,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: isDark ? colorScheme.surfaceContainer : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark ? Colors.white12 : Colors.black12,
                  ),
                ),
                child: Obx(() => DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: controller.selectedPriority.value,
                        dropdownColor: isDark ? colorScheme.surfaceContainer : Colors.white,
                        items: const [
                          DropdownMenuItem(value: 'all', child: Text('جميع الأولويات')),
                          DropdownMenuItem(value: 'urgent', child: Text('عاجلة جداً 🔥')),
                          DropdownMenuItem(value: 'high', child: Text('أولوية مرتفعة')),
                          DropdownMenuItem(value: 'normal', child: Text('أولوية عادية')),
                          DropdownMenuItem(value: 'low', child: Text('منخفضة')),
                        ],
                        onChanged: (val) {
                          if (val != null) controller.selectedPriority.value = val;
                        },
                      ),
                    )),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Status & Category Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildStatusChip('all', 'جميع التذاكر'),
                _buildStatusChip('open', 'جديدة'),
                _buildStatusChip('in_progress', 'قيد المعالجة'),
                _buildStatusChip('waiting_user', 'بانتظار العميل'),
                _buildStatusChip('resolved', 'تم الحل'),
                _buildStatusChip('closed', 'مغلقة'),
                const SizedBox(width: 12),
                Container(width: 1, height: 20, color: Colors.grey.withValues(alpha: 0.3)),
                const SizedBox(width: 12),
                _buildCategoryChip('all', 'كل الأقسام'),
                _buildCategoryChip('orders_shipping', 'الطلبات والشحن'),
                _buildCategoryChip('supplements', 'المكملات'),
                _buildCategoryChip('payment_refunds', 'المدفوعات'),
                _buildCategoryChip('complaint', 'شكاوى رسمية'),
                _buildCategoryChip('technical', 'مشاكل تقنية'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String value, String label) {
    return Obx(() {
      final isSelected = controller.selectedStatus.value == value;
      return Padding(
        padding: const EdgeInsets.only(right: 6),
        child: FilterChip(
          label: Text(label, style: const TextStyle(fontSize: 11)),
          selected: isSelected,
          onSelected: (_) => controller.selectedStatus.value = value,
        ),
      );
    });
  }

  Widget _buildCategoryChip(String value, String label) {
    return Obx(() {
      final isSelected = controller.selectedCategory.value == value;
      return Padding(
        padding: const EdgeInsets.only(right: 6),
        child: ChoiceChip(
          label: Text(label, style: const TextStyle(fontSize: 11)),
          selected: isSelected,
          onSelected: (_) => controller.selectedCategory.value = value,
        ),
      );
    });
  }

  Widget _buildTicketsList(BuildContext context, bool isDark) {
    return ListView.builder(
      itemCount: controller.filteredTickets.length,
      itemBuilder: (context, index) {
        final ticket = controller.filteredTickets[index];
        final isSelected = controller.selectedTicket.value?.id == ticket.id;

        return SupportTicketCard(
          ticket: ticket,
          isSelected: isSelected,
          onTap: () => controller.selectTicket(ticket),
        );
      },
    );
  }

  Widget _buildNoTicketsState(BuildContext context, bool isDark) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox_outlined, size: 54, color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4)),
          const SizedBox(height: 12),
          Text(
            'لا توجد تذاكر تطابق هذا الفلتر',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'جرب تغيير خيارات البحث أو تصفية الحالة لعرض التذاكر',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
