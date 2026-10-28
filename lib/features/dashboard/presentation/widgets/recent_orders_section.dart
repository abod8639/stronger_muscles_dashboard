import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/core/router/app_routes.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/base_data_view.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/domain/entities/dashboard_stats_entity.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/presentation/controllers/dashboard_providers.dart';
import 'package:stronger_muscles_dashboard/features/navigation/navigation_feature.dart';
import 'package:stronger_muscles_dashboard/features/orders/orders_feature.dart';

class RecentOrdersSection extends ConsumerWidget {
  const RecentOrdersSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final res = context.responsive;
    final stats = ref.watch(dashboardStatsNotifierProvider).value ??
        DashboardStatsEntity.initial();
    final orders = stats.orders;

    return BaseDataView<OrderEntity>(
      title: 'الطلبات الأخيرة',
      crossAxisCount: res.isDesktop ? 2 : 1,
      items: orders,
      onSeeAll: () =>
          ref.read(navigationControllerProvider.notifier).selectTab(4),
      useListView: res.isTablet,
      showCount: 4,
      mainAxisExtent: 220,
      itemBuilder: (context, order, index) {
        return OrderListTile(
          order: order,
          index: index,
          onTap: () => context.push(AppRoutes.orderDetails, extra: order),
        );
      },
    );
  }
}
