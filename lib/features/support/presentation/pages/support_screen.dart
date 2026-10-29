import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/core/theme/responsive.dart';
import '../controllers/support_providers.dart';
import '../widgets/support_chat_view.dart';
import '../widgets/support_stats_header.dart';
import '../widgets/support_ticket_card.dart';

/// Clean Architecture Presentation Page for Support & Complaints module.
/// Supports responsive split layout on Desktop and Master-Detail navigation on Mobile/Tablet.
class SupportScreen extends ConsumerStatefulWidget {
  const SupportScreen({super.key});

  @override
  ConsumerState<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends ConsumerState<SupportScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    final initialQuery = ref.read(supportControllerProvider).searchQuery;
    _searchController = TextEditingController(text: initialQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isDesktop = responsive.screenWidth >= 950;

    final hasSelectedTicket =
        !isDesktop &&
        ref.watch(
          supportControllerProvider.select((s) => s.selectedTicket != null),
        );

    return PopScope(
      canPop: !hasSelectedTicket,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && hasSelectedTicket) {
          ref.read(supportControllerProvider.notifier).setSelectedTicket(null);
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
                    _buildHeader(context, isDark),
                    const SupportStatsHeader(),
                    const SizedBox(height: 8),
                    _buildFiltersBar(context, isDark),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: responsive.defaultPadding.left,
                        ),
                        child: Consumer(
                          builder: (context, ref, _) {
                            final isLoading = ref.watch(
                              supportControllerProvider.select(
                                (s) => s.isLoading && s.tickets.isEmpty,
                              ),
                            );
                            final tickets = ref.watch(
                              supportControllerProvider.select(
                                (s) => s.tickets,
                              ),
                            );

                            if (isLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (tickets.isEmpty) {
                              return _buildNoTicketsState(context, isDark);
                            }

                            if (isDesktop) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 380,
                                    child: _buildTicketsList(context, isDark),
                                  ),
                                  const SizedBox(width: 14),
                                  const Expanded(child: SupportChatView()),
                                ],
                              );
                            } else {
                              return _buildTicketsList(context, isDark);
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
            child: Icon(
              Icons.support_agent_rounded,
              color: colorScheme.primary,
              size: 24,
            ),
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
            onPressed: () =>
                ref.read(supportControllerProvider.notifier).fetchTickets(),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersBar(BuildContext context, bool isDark) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final responsive = context.responsive;

    final selectedPriority = ref.watch(
      supportControllerProvider.select((s) => s.selectedPriority),
    );
    final searchQuery = ref.watch(
      supportControllerProvider.select((s) => s.searchQuery),
    );

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
                    border: Border.all(color: colorScheme.outlineVariant),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => ref
                        .read(supportControllerProvider.notifier)
                        .onSearchChanged(val),
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
                        color: colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.7,
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        size: 18,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      suffixIcon: searchQuery.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.clear_rounded,
                                size: 16,
                                color: colorScheme.onSurfaceVariant,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                ref
                                    .read(supportControllerProvider.notifier)
                                    .onSearchChanged('');
                              },
                            )
                          : const SizedBox.shrink(),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 11,
                      ),
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
                  border: Border.all(color: colorScheme.outlineVariant),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedPriority,
                    dropdownColor: colorScheme.surfaceContainer,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    style: TextStyle(
                      fontSize: 12.5,
                      color: colorScheme.onSurface,
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'all',
                        child: Text(
                          'جميع الأولويات',
                          style: TextStyle(color: colorScheme.onSurface),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'urgent',
                        child: Text(
                          'عاجلة جداً 🔥',
                          style: TextStyle(color: colorScheme.onSurface),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'high',
                        child: Text(
                          'أولوية مرتفعة',
                          style: TextStyle(color: colorScheme.onSurface),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'normal',
                        child: Text(
                          'أولوية عادية',
                          style: TextStyle(color: colorScheme.onSurface),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'low',
                        child: Text(
                          'منخفضة',
                          style: TextStyle(color: colorScheme.onSurface),
                        ),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        ref
                            .read(supportControllerProvider.notifier)
                            .updateSelectedPriority(val);
                      }
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
                _buildStatusChip(context, 'all', 'جميع التذاكر'),
                _buildStatusChip(context, 'open', 'جديدة'),
                _buildStatusChip(context, 'in_progress', 'قيد المعالجة'),
                _buildStatusChip(context, 'waiting_user', 'بانتظار العميل'),
                _buildStatusChip(context, 'resolved', 'تم الحل'),
                _buildStatusChip(context, 'closed', 'مغلقة'),
                const SizedBox(width: 12),
                Container(
                  width: 1,
                  height: 20,
                  color: colorScheme.outlineVariant,
                ),
                const SizedBox(width: 12),
                _buildCategoryChip(context, 'all', 'كل الأقسام'),
                _buildCategoryChip(
                  context,
                  'orders_shipping',
                  'الطلبات والشحن',
                ),
                _buildCategoryChip(context, 'supplements', 'المكملات'),
                _buildCategoryChip(context, 'payment_refunds', 'المدفوعات'),
                _buildCategoryChip(context, 'complaint', 'شكاوى رسمية'),
                _buildCategoryChip(context, 'technical', 'مشاكل تقنية'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, String value, String label) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final selectedStatus = ref.watch(
      supportControllerProvider.select((s) => s.selectedStatus),
    );
    final isSelected = selectedStatus == value;

    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isSelected
                ? colorScheme.onPrimaryContainer
                : colorScheme.onSurface,
          ),
        ),
        selected: isSelected,
        selectedColor: colorScheme.primaryContainer,
        backgroundColor: colorScheme.surfaceContainerHigh,
        side: BorderSide(
          color: isSelected ? colorScheme.primary : colorScheme.outlineVariant,
        ),
        onSelected: (_) => ref
            .read(supportControllerProvider.notifier)
            .updateSelectedStatus(value),
      ),
    );
  }

  Widget _buildCategoryChip(BuildContext context, String value, String label) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final selectedCategory = ref.watch(
      supportControllerProvider.select((s) => s.selectedCategory),
    );
    final isSelected = selectedCategory == value;

    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ChoiceChip(
        label: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isSelected
                ? colorScheme.onPrimaryContainer
                : colorScheme.onSurface,
          ),
        ),
        selected: isSelected,
        selectedColor: colorScheme.primaryContainer,
        backgroundColor: colorScheme.surfaceContainerHigh,
        side: BorderSide(
          color: isSelected ? colorScheme.primary : colorScheme.outlineVariant,
        ),
        onSelected: (_) => ref
            .read(supportControllerProvider.notifier)
            .updateSelectedCategory(value),
      ),
    );
  }

  Widget _buildTicketsList(BuildContext context, bool isDark) {
    final filteredTickets = ref.watch(
      supportControllerProvider.select((s) => s.filteredTickets),
    );
    final selectedTicketId = ref.watch(
      supportControllerProvider.select((s) => s.selectedTicket?.id),
    );

    return ListView.builder(
      itemCount: filteredTickets.length,
      itemBuilder: (context, index) {
        final ticket = filteredTickets[index];
        final isSelected = selectedTicketId == ticket.id;

        return SupportTicketCard(
          ticket: ticket,
          isSelected: isSelected,
          onTap: () =>
              ref.read(supportControllerProvider.notifier).selectTicket(ticket),
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
          Icon(
            Icons.inbox_outlined,
            size: 54,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
          ),
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
