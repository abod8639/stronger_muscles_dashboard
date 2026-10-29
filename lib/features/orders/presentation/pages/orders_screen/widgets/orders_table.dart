import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:stronger_muscles_dashboard/core/router/app_routes.dart';
import 'package:stronger_muscles_dashboard/core/components/custom_search_bar.dart';
import 'package:stronger_muscles_dashboard/core/components/glass_container.dart';
import 'package:stronger_muscles_dashboard/core/components/status_badge.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/controllers/orders_providers.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';
import 'package:stronger_muscles_dashboard/core/theme/responsive.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/widgets/build_recent_orders.dart';

class OrdersTable extends ConsumerWidget {
  const OrdersTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paginatedOrders = ref.watch(paginatedOrdersProvider);
    final totalFiltered = ref.watch(filteredOrdersProvider).length;
    final currentPage = ref.watch(ordersCurrentPageProvider);
    final totalPages = ref.watch(ordersTotalPagesProvider);
    final selectedStatus = ref.watch(ordersSelectedStatusProvider);
    final itemsPerPage = ref.watch(ordersItemsPerPageProvider);
    final responsive = context.responsive;

    return GlassContainer(
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(20),
      child: Column(
        children: [
          _buildTableHeader(context, ref, responsive, selectedStatus),

          responsive.isDesktop
              ? _buildTableContent(paginatedOrders, responsive)
              : buildRecentOrders(responsive, paginatedOrders),

          _buildTableFooter(
            ref: ref,
            responsive: responsive,
            currentPage: currentPage,
            totalPages: totalPages,
            itemsPerPage: itemsPerPage,
            totalCount: totalFiltered,
            currentCount: paginatedOrders.length,
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(
    BuildContext context,
    WidgetRef ref,
    ResponsiveLayout responsive,
    String selectedStatus,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh.withValues(alpha: 0.25),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(
          bottom: BorderSide(color: colorScheme.outlineVariant, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (!responsive.isMobile) ...[
                Text(
                  "Orders Management",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                    letterSpacing: 0.3,
                  ),
                ),
                if (responsive.isDesktop) const Spacer(),
              ],
              const SizedBox(width: 20),
              Expanded(
                child: CustomSearchBar(
                  onSearch: (value) {
                    ref.read(ordersSearchQueryProvider.notifier).setQuery(value);
                    ref.read(ordersCurrentPageProvider.notifier).setPage(1);
                  },
                  hintText: "    Search orders...",
                ),
              ),
            ],
          ),

          SizedBox(
            height: 42,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _buildTab(context, ref, 'all', 'All Orders', selectedStatus),
                  _buildTab(context, ref, 'pending', 'Pending', selectedStatus),
                  _buildTab(context, ref, 'processing', 'Processing', selectedStatus),
                  _buildTab(context, ref, 'shipped', 'Shipped', selectedStatus),
                  _buildTab(context, ref, 'delivered', 'Delivered', selectedStatus),
                  _buildTab(context, ref, 'cancelled', 'Cancelled', selectedStatus),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(
    BuildContext context,
    WidgetRef ref,
    String id,
    String label,
    String selectedStatus,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = selectedStatus == id;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        onSelected: (_) {
          ref.read(ordersSelectedStatusProvider.notifier).setStatus(id);
          ref.read(ordersCurrentPageProvider.notifier).setPage(1);
        },
        label: Text(label),
        labelStyle: theme.textTheme.labelMedium?.copyWith(
          color: isSelected
              ? colorScheme.onPrimary
              : colorScheme.onSurfaceVariant,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        ),
        backgroundColor: colorScheme.surfaceContainerLow,
        selectedColor: colorScheme.primary,
        showCheckmark: false,
        side: BorderSide(
          color: isSelected ? colorScheme.primary : colorScheme.outlineVariant,
          width: 1.0,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      ),
    );
  }

  Widget _buildTableContent(
    List<OrderEntity> orders,
    ResponsiveLayout responsive,
  ) {
    Widget content = Column(
      children: [
        // Column Headers
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
          color: Colors.white.withValues(alpha: 0.02),
          child: Row(
            children: [
              _buildColumnHeader('ORDER ID', flex: 3),
              _buildColumnHeader('CUSTOMER', flex: 2),
              _buildColumnHeader('DATE', flex: 2),
              _buildColumnHeader('TOTAL AMOUNT', flex: 2),
              _buildColumnHeader('STATUS', flex: 2),
            ],
          ),
        ),

        // Rows
        ...List.generate(orders.length, (index) {
          return _buildOrderRow(
            orders[index],
            isLast: index == orders.length - 1,
          );
        }),

        if (orders.isEmpty)
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Text(
              'No orders found',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
            ),
          ),
      ],
    );

    if (responsive.isMobile || responsive.isTablet) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: 800, // Minimum width for the table to remain readable
          child: content,
        ),
      );
    }

    return content;
  }

  Widget _buildColumnHeader(
    String label, {
    int flex = 1,
    TextAlign textAlign = TextAlign.start,
  }) {
    return Expanded(
      flex: flex,
      child: Text(
        label,
        textAlign: textAlign,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.3),
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildOrderRow(OrderEntity order, {bool isLast = false}) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    return Builder(
      builder: (context) {
        bool isMobile = MediaQuery.of(context).size.width < 600;
        return InkWell(
          onTap: () => context.push(AppRoutes.orderDetails, extra: order),
          hoverColor: Colors.white.withValues(alpha: 0.02),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16 : 24,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withValues(alpha: 0.05),
                  width: 1,
                ),
              ),
            ),
            child: isMobile
                ? _buildMobileLayout(order, dateFormat)
                : _buildDesktopLayout(order, dateFormat),
          ),
        );
      },
    );
  }

  Widget _buildDesktopLayout(OrderEntity order, DateFormat dateFormat) {
    return Row(
      children: [
        Expanded(flex: 3, child: _buildOrderId(order)),
        Expanded(flex: 2, child: _buildCustomerInfo(order)),
        Expanded(flex: 2, child: _buildDate(order, dateFormat)),
        Expanded(flex: 2, child: _buildPrice(order)),
        Expanded(flex: 1, child: OrderStatusBadge(status: order.status)),
        Expanded(flex: 1, child: _buildActionBtn(order)),
      ],
    );
  }

  Widget _buildMobileLayout(OrderEntity order, DateFormat dateFormat) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildCustomerInfo(order),
            OrderStatusBadge(status: order.status),
          ],
        ),
        const SizedBox(height: 12),
        Divider(color: Colors.white.withValues(alpha: 0.05), thickness: 1),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOrderId(order),
                const SizedBox(height: 4),
                _buildDate(order, dateFormat),
              ],
            ),
            _buildPrice(order),
          ],
        ),
      ],
    );
  }

  Widget _buildOrderId(OrderEntity order) {
    return Text(
      '#ORD-${order.id.toString().padLeft(4, '0')}',
      style: const TextStyle(
        color: AppColors.accent,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
    );
  }

  Widget _buildCustomerInfo(OrderEntity order) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildAvatar(order),
        const SizedBox(width: 10),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order.userName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                order.userEmail,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.3),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDate(OrderEntity order, DateFormat dateFormat) {
    return Text(
      dateFormat.format(order.orderDate),
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.5),
        fontSize: 12,
      ),
    );
  }

  Widget _buildPrice(OrderEntity order) {
    return Text(
      '${order.totalAmount.toStringAsFixed(2)} L.E ',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Widget _buildActionBtn(OrderEntity order) {
    return const Align(
      alignment: Alignment.centerRight,
      child: Icon(Icons.chevron_right_rounded, size: 20, color: Colors.white24),
    );
  }

  Widget _buildAvatar(OrderEntity order) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.4),
            AppColors.primary.withValues(alpha: 0.1),
          ],
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Center(
        child: order.userPhoto != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(order.userPhoto!, fit: BoxFit.cover),
              )
            : Text(
                order.userName.isNotEmpty
                    ? order.userName[0].toUpperCase()
                    : 'U',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildTableFooter({
    required WidgetRef ref,
    required ResponsiveLayout responsive,
    required int currentPage,
    required int totalPages,
    required int itemsPerPage,
    required int totalCount,
    required int currentCount,
  }) {
    final start = totalCount == 0 ? 0 : (currentPage - 1) * itemsPerPage + 1;
    final end = (start + currentCount - 1).clamp(0, totalCount);

    Widget statsText = Text(
      'Showing $start to $end of $totalCount entries',
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.4),
        fontSize: 12,
      ),
    );

    Widget paginationControls = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildNavButton(
          icon: Icons.chevron_left_rounded,
          onPressed: currentPage > 1
              ? () => ref.read(ordersCurrentPageProvider.notifier).previousPage()
              : null,
        ),
        const SizedBox(width: 12),
        ..._buildPageNumbers(ref, currentPage, totalPages),
        const SizedBox(width: 12),
        _buildNavButton(
          icon: Icons.chevron_right_rounded,
          onPressed: currentPage < totalPages
              ? () => ref
                  .read(ordersCurrentPageProvider.notifier)
                  .nextPage(totalPages)
              : null,
        ),
      ],
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        ),
      ),
      child: responsive.isMobile
          ? Column(
              children: [
                statsText,
                const SizedBox(height: 16),
                paginationControls,
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [statsText, paginationControls],
            ),
    );
  }

  List<Widget> _buildPageNumbers(WidgetRef ref, int currentPage, int totalPages) {
    List<Widget> pages = [];
    for (int i = 1; i <= totalPages; i++) {
      if (totalPages > 5) {
        if (i != 1 &&
            i != totalPages &&
            (i < currentPage - 1 || i > currentPage + 1)) {
          if (i == 2 || i == totalPages - 1) {
            pages.add(
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  '...',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.2)),
                ),
              ),
            );
          }
          continue;
        }
      }
      pages.add(_buildPageButton(ref, i, currentPage));
    }
    return pages;
  }

  Widget _buildPageButton(WidgetRef ref, int pageNum, int currentPage) {
    final isSelected = currentPage == pageNum;
    return GestureDetector(
      onTap: () => ref.read(ordersCurrentPageProvider.notifier).setPage(pageNum),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 3),
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : Colors.white.withValues(alpha: 0.1),
          ),
        ),
        child: Text(
          '$pageNum',
          style: TextStyle(
            color: isSelected
                ? Colors.black
                : Colors.white.withValues(alpha: 0.6),
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton({required IconData icon, VoidCallback? onPressed}) {
    bool isDisabled = onPressed == null;
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: isDisabled ? 0.02 : 0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.white.withValues(alpha: isDisabled ? 0.02 : 0.1),
          ),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isDisabled
              ? Colors.white10
              : Colors.white.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}
