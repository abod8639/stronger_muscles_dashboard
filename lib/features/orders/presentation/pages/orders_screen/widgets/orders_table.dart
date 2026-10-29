import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:stronger_muscles_dashboard/core/components/custom_search_bar.dart';
import 'package:stronger_muscles_dashboard/core/components/divided_column.dart';
import 'package:stronger_muscles_dashboard/core/components/generic_empty_state.dart';
import 'package:stronger_muscles_dashboard/core/components/horizontal_chips_selector.dart';
import 'package:stronger_muscles_dashboard/core/components/pagination_bar.dart';
import 'package:stronger_muscles_dashboard/core/components/price_text.dart';
import 'package:stronger_muscles_dashboard/core/components/soft_surface.dart';
import 'package:stronger_muscles_dashboard/core/router/app_routes.dart';
import 'package:stronger_muscles_dashboard/core/theme/responsive.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/controllers/orders_providers.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/widgets/order_list_tile.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/widgets/order_status_ui.dart';
import 'package:stronger_muscles_dashboard/features/settings/settings_feature.dart';

/// قائمة الطلبات: بحث + تصفية بالحالة + جدول (حاسوب) أو بطاقات (هاتف/لوحي) + ترقيم صفحات
class OrdersTable extends ConsumerWidget {
  const OrdersTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(paginatedOrdersProvider);
    final totalFiltered = ref.watch(filteredOrdersProvider).length;
    final currentPage = ref.watch(ordersCurrentPageProvider);
    final totalPages = ref.watch(ordersTotalPagesProvider);
    final itemsPerPage = ref.watch(ordersItemsPerPageProvider);
    final selectedStatus = ref.watch(ordersSelectedStatusProvider);
    final colorScheme = Theme.of(context).colorScheme;

    final Widget body;
    if (orders.isEmpty) {
      body = const GenericEmptyState(
        title: 'لا توجد طلبات',
        message: 'لا توجد طلبات تطابق البحث أو التصفية الحالية',
        icon: Icons.receipt_long_outlined,
      );
    } else if (context.isDesktop) {
      body = _OrdersDataTable(orders: orders);
    } else {
      body = _OrdersCardList(orders: orders);
    }

    return SoftSurface(
      child: ClipRRect(
        borderRadius: AppDesignTokens.radiusLarge,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: AppDesignTokens.space4),
              child: CustomSearchBar(
                hintText: 'ابحث برقم الطلب أو اسم العميل...',
                padding: context.responsive.defaultPadding,
                onSearch: (value) {
                  ref.read(ordersSearchQueryProvider.notifier).setQuery(value);
                  ref.read(ordersCurrentPageProvider.notifier).setPage(1);
                },
              ),
            ),
            HorizontalChipsSelector(
              items: OrderStatus.values,
              selectedId: selectedStatus,
              allLabel: 'كل الطلبات',
              labelBuilder: (status) => (status as OrderStatus).label,
              idBuilder: (status) => (status as OrderStatus).name,
              onSelect: (id) {
                ref.read(ordersSelectedStatusProvider.notifier).setStatus(id);
                ref.read(ordersCurrentPageProvider.notifier).setPage(1);
              },
            ),
            const SizedBox(height: AppDesignTokens.space8),
            Divider(height: 1, color: colorScheme.outlineVariant),
            body,
            Divider(height: 1, color: colorScheme.outlineVariant),
            PaginationBar(
              currentPage: currentPage,
              totalPages: totalPages,
              itemsPerPage: itemsPerPage,
              totalCount: totalFiltered,
              currentCount: orders.length,
              onPageChanged: ref
                  .read(ordersCurrentPageProvider.notifier)
                  .setPage,
            ),
          ],
        ),
      ),
    );
  }
}

void _openOrder(BuildContext context, OrderEntity order) =>
    context.push(AppRoutes.orderDetails, extra: order);

/// الهاتف والجهاز اللوحي: بطاقات طلبات
class _OrdersCardList extends StatelessWidget {
  final List<OrderEntity> orders;

  const _OrdersCardList({required this.orders});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(responsive.defaultPadding.left),
      itemCount: orders.length,
      separatorBuilder: (_, _) => SizedBox(height: responsive.itemSpacing),
      itemBuilder: (context, index) => OrderListTile(
        key: ValueKey(orders[index].id),
        order: orders[index],
        index: index,
        onTap: () => _openOrder(context, orders[index]),
      ),
    );
  }
}

/// الحاسوب: جدول بأعمدة ثابتة النسب
class _OrdersDataTable extends ConsumerWidget {
  final List<OrderEntity> orders;

  const _OrdersDataTable({required this.orders});

  static const _columns = [
    ('رقم الطلب', 3),
    ('العميل', 3),
    ('التاريخ', 2),
    ('الإجمالي', 2),
    ('الحالة', 2),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currency = ref.watch(storeCurrencyProvider);
    final dateFormat = DateFormat('yyyy/MM/dd');

    return Column(
      children: [
        Container(
          color: colorScheme.surfaceContainerHigh.withValues(alpha: 0.4),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDesignTokens.space24,
            vertical: AppDesignTokens.space14,
          ),
          child: Row(
            children: [
              for (final (label, flex) in _columns)
                Expanded(
                  flex: flex,
                  child: Text(
                    label,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const SizedBox(width: 24),
            ],
          ),
        ),
        DividedColumn(
          children: [
            for (final order in orders)
              InkWell(
                key: ValueKey(order.id),
                onTap: () => _openOrder(context, order),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDesignTokens.space24,
                    vertical: AppDesignTokens.space14,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          '#${order.id}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(flex: 3, child: _CustomerCell(order: order)),
                      Expanded(
                        flex: 2,
                        child: Text(
                          dateFormat.format(order.orderDate),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: PriceText(
                          amount: order.totalAmount,
                          currency: currency,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: OrderStatusBadge(status: order.status),
                        ),
                      ),
                      SizedBox(
                        width: 24,
                        child: Icon(
                          Icons.chevron_left_rounded,
                          size: 20,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _CustomerCell extends StatelessWidget {
  final OrderEntity order;

  const _CustomerCell({required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final initial = order.userName.isNotEmpty
        ? order.userName[0].toUpperCase()
        : 'U';

    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: colorScheme.primaryContainer,
          foregroundImage: order.userPhoto != null
              ? NetworkImage(order.userPhoto!)
              : null,
          child: Text(
            initial,
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: AppDesignTokens.space10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                order.userName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                order.userEmail,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
