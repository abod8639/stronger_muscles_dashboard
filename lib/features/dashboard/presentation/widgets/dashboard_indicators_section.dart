import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/config/app_colors.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/premium_indicator_card.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/domain/entities/dashboard_stats_entity.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/presentation/controllers/dashboard_providers.dart';
import 'package:stronger_muscles_dashboard/features/orders/orders_feature.dart';

class DashboardIndicatorsSection extends ConsumerWidget {
  const DashboardIndicatorsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final res = context.responsive;
    final bool isSmallScreen = res.isMobile;

    final int crossAxisCount = isSmallScreen
        ? 1
        : (res.screenWidth < 1200 ? 2 : 3);

    final s = ref.watch(dashboardStatsNotifierProvider).value ??
        DashboardStatsEntity.initial();
    final pendingTrend = ref.watch(statusTrendDataProvider(OrderStatus.pending));
    final deliveredTrend =
        ref.watch(statusTrendDataProvider(OrderStatus.delivered));
    final cancelledTrend =
        ref.watch(statusTrendDataProvider(OrderStatus.cancelled));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            'المؤشرات الرئيسية',
            style: TextStyle(
              fontSize: isSmallScreen ? 17 : 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisExtent: isSmallScreen ? 152 : 175,
            crossAxisSpacing: res.itemSpacing * 1.2,
            mainAxisSpacing: res.itemSpacing * 1.2,
          ),
          children: [
            PremiumIndicatorCard(
              title: 'معلقة',
              subtitle: 'Pending Orders',
              value: s.pendingOrders.toString(),
              icon: Icons.hourglass_empty,
              accentColor: AppColorsExtended.purpleDark,
              trend: pendingTrend.trend,
              trendUp: pendingTrend.trendUp,
              chartColor: AppColorsExtended.orangeAccent,
              chartSpots: pendingTrend.spots,
            ),
            PremiumIndicatorCard(
              title: 'المسلمة',
              subtitle: 'Delivered Orders',
              value: s.deliveredOrders.toString(),
              icon: Icons.check_circle,
              accentColor: AppColorsExtended.purpleDark,
              trend: deliveredTrend.trend,
              trendUp: deliveredTrend.trendUp,
              chartColor: AppColorsExtended.greenAccent,
              chartSpots: deliveredTrend.spots,
            ),
            PremiumIndicatorCard(
              title: 'ملغاة',
              subtitle: 'Cancelled Orders',
              value: s.cancelledOrders.toString(),
              icon: Icons.cancel,
              accentColor: AppColorsExtended.purpleDark,
              trend: cancelledTrend.trend,
              trendUp: cancelledTrend.trendUp,
              chartColor: AppColorsExtended.redAccent,
              chartSpots: cancelledTrend.spots,
            ),
          ],
        ),
      ],
    );
  }
}
