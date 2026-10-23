import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/responsive.dart';
import '../controllers/support_controller.dart';
import '../controllers/support_providers.dart';
import '../widgets/support_chat_view.dart';
import '../widgets/support_stats_header.dart';
import '../widgets/support_ticket_card.dart';

class SupportScreen extends ConsumerWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(supportControllerProvider);

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final responsive = context.responsive;
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        final isDesktop = responsive.screenWidth >= 950;

        final hasSelectedTicket = !isDesktop && controller.selectedTicket != null;

        return PopScope(
          canPop: !hasSelectedTicket,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop && hasSelectedTicket) {
              controller.setSelectedTicket(null);
            }
          },
          child: Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            body: SafeArea(
              child: hasSelectedTicket
                  ? const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      child: SupportChatView(),
                    )
                  : Column(
                      children: [
                        _buildHeader(context, controller, isDark),
                        const SupportStatsHeader(),
                        const SizedBox(height: 8),
                        _buildFiltersBar(context, controller, isDark),
                        const SizedBox(height: 10),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: responsive.defaultPadding.left,
                            ),
                            child: Builder(
                              builder: (context) {
                                if (controller.isLoading &&
                                    controller.tickets.isEmpty) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                if (controller.tickets.isEmpty) {
                                  return _buildNoTicketsState(context, isDark);
                                }

                                if (isDesktop) {
                                  return Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 380,
                                        child: _buildTicketsList(
                                            context, controller, isDark),
                                      ),
                                      const SizedBox(width: 14),
                                      const Expanded(
                                        child: SupportChatView(),
                                      ),
                                    ],
                                  );
                                } else {
                                  return _buildTicketsList(
                                      context, controller, isDark);
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(
      BuildContext context, SupportController controller, bool isDark) {
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
            child: Icon(Icons.support_agent_rounded,
                color: colorScheme.primary, size: 24),
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
                    fontSize: responsive.isMobile ? 16 : null,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  responsive.isMobile
                      ? 'متابعة البلاغات والرد الفوري مع العملاء'
                      : 'متابعة البلاغات والرد الفوري مع إشعارات Push وتحديثات Real-time عبر فايربيس',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: responsive.isMobile ? 11 : null,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            tooltip: 'تحديث البيانات',
            style: IconButton.styleFrom(
              backgroundColor: colorScheme.surfaceContainerHigh,
              foregroundColor: colorScheme.onSurface,
              padding: const EdgeInsets.all(10),
            ),
            icon: const Icon(Icons.refresh_rounded, size: 20),
            onPressed: () => controller.fetchTickets(),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersBar(
      BuildContext context, SupportController controller, bool isDark) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final responsive = context.responsive;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: responsive.defaultPadding.left),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: colorScheme.outlineVariant,
                    ),
                  ),
                  child: TextField(
                    onChanged: (val) => controller.onSearchChanged(val),
                    style: TextStyle(
                      fontSize: 13,
                      color: colorScheme.onSurface,
                    ),
                    decoration: InputDecoration(
                      hintText: responsive.isMobile
                          ? 'بحث بالتذاكر أو العميل...'
                          : 'ابحث برقم التذكرة، اسم العميل، البريد، أو الموضوع...',
                      hintStyle: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                      ),
                      prefixIcon: Icon(Icons.search_rounded, size: 18, color: colorScheme.onSurfaceVariant),
                      suffixIcon: controller.searchQuery.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear_rounded, size: 16, color: colorScheme.onSurfaceVariant),
                              onPressed: () => controller.onSearchChanged(''),
                            )
                          : const SizedBox.shrink(),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 11),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                height: 42,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: colorScheme.outlineVariant,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: controller.selectedPriority,
                    dropdownColor: colorScheme.surfaceContainer,
                    icon: Icon(Icons.arrow_drop_down, color: colorScheme.onSurfaceVariant),
                    style: TextStyle(fontSize: 12.5, color: colorScheme.onSurface),
                    items: [
                      DropdownMenuItem(
                          value: 'all', child: Text('جميع الأولويات', style: TextStyle(color: colorScheme.onSurface))),
                      DropdownMenuItem(
                          value: 'urgent', child: Text('عاجلة جداً 🔥', style: TextStyle(color: colorScheme.onSurface))),
                      DropdownMenuItem(
                          value: 'high', child: Text('أولوية مرتفعة', style: TextStyle(color: colorScheme.onSurface))),
                      DropdownMenuItem(
                          value: 'normal', child: Text('أولوية عادية', style: TextStyle(color: colorScheme.onSurface))),
                      DropdownMenuItem(
                          value: 'low', child: Text('منخفضة', style: TextStyle(color: colorScheme.onSurface))),
                    ],
                    onChanged: (val) {
                      if (val != null) controller.updateSelectedPriority(val);
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildStatusChip(context, controller, 'all', 'جميع التذاكر'),
                _buildStatusChip(context, controller, 'open', 'جديدة'),
                _buildStatusChip(context, controller, 'in_progress', 'قيد المعالجة'),
                _buildStatusChip(context, controller, 'waiting_user', 'بانتظار العميل'),
                _buildStatusChip(context, controller, 'resolved', 'تم الحل'),
                _buildStatusChip(context, controller, 'closed', 'مغلقة'),
                const SizedBox(width: 12),
                Container(
                    width: 1,
                    height: 20,
                    color: colorScheme.outlineVariant),
                const SizedBox(width: 12),
                _buildCategoryChip(context, controller, 'all', 'كل الأقسام'),
                _buildCategoryChip(
                    context, controller, 'orders_shipping', 'الطلبات والشحن'),
                _buildCategoryChip(context, controller, 'supplements', 'المكملات'),
                _buildCategoryChip(
                    context, controller, 'payment_refunds', 'المدفوعات'),
                _buildCategoryChip(context, controller, 'complaint', 'شكاوى رسمية'),
                _buildCategoryChip(context, controller, 'technical', 'مشاكل تقنية'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(
      BuildContext context, SupportController controller, String value, String label) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = controller.selectedStatus == value;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: FilterChip(
        label: Text(label, style: TextStyle(fontSize: 11, color: isSelected ? colorScheme.onPrimaryContainer : colorScheme.onSurface)),
        selected: isSelected,
        selectedColor: colorScheme.primaryContainer,
        backgroundColor: colorScheme.surfaceContainerHigh,
        side: BorderSide(color: isSelected ? colorScheme.primary : colorScheme.outlineVariant),
        onSelected: (_) => controller.updateSelectedStatus(value),
      ),
    );
  }

  Widget _buildCategoryChip(
      BuildContext context, SupportController controller, String value, String label) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = controller.selectedCategory == value;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ChoiceChip(
        label: Text(label, style: TextStyle(fontSize: 11, color: isSelected ? colorScheme.onPrimaryContainer : colorScheme.onSurface)),
        selected: isSelected,
        selectedColor: colorScheme.primaryContainer,
        backgroundColor: colorScheme.surfaceContainerHigh,
        side: BorderSide(color: isSelected ? colorScheme.primary : colorScheme.outlineVariant),
        onSelected: (_) => controller.updateSelectedCategory(value),
      ),
    );
  }

  Widget _buildTicketsList(
      BuildContext context, SupportController controller, bool isDark) {
    return ListView.builder(
      itemCount: controller.filteredTickets.length,
      itemBuilder: (context, index) {
        final ticket = controller.filteredTickets[index];
        final isSelected = controller.selectedTicket?.id == ticket.id;

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
          Icon(Icons.inbox_outlined,
              size: 54,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4)),
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
