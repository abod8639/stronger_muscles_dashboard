import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/core/components/premium_indicator_card.dart';
import 'package:stronger_muscles_dashboard/core/components/responsive_stats_grid.dart';
import 'package:stronger_muscles_dashboard/core/components/section_header.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/domain/entities/dashboard_stats_entity.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/presentation/controllers/dashboard_providers.dart';
import 'package:stronger_muscles_dashboard/features/orders/orders_feature.dart';

/// مؤشرات حالات الطلب الرئيسية مع منحنى الاتجاه لكل حالة
class DashboardIndicatorsSection extends ConsumerWidget {
  const DashboardIndicatorsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats =
        ref.watch(dashboardStatsNotifierProvider).value ??
        DashboardStatsEntity.initial();

    final counts = {
      OrderStatus.pending: stats.pendingOrders,
      OrderStatus.delivered: stats.deliveredOrders,
      OrderStatus.cancelled: stats.cancelledOrders,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'المؤشرات الرئيسية'),
        ResponsiveStatsGrid(
          mobileHeight: 152,
          mainAxisExtent: 175,
          cards: [
            for (final MapEntry(key: status, value: count) in counts.entries)
              _StatusIndicatorCard(status: status, count: count),
          ],
        ),
      ],
    );
  }
}

class _StatusIndicatorCard extends ConsumerWidget {
  final OrderStatus status;
  final int count;

  const _StatusIndicatorCard({required this.status, required this.count});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trend = ref.watch(statusTrendDataProvider(status));
    return PremiumIndicatorCard(
      title: status.label,
      value: count.toString(),
      icon: status.icon,
      accentColor: status.color,
      trend: trend.trend,
      trendUp: trend.trendUp,
      chartSpots: trend.spots,
    );
  }
}
