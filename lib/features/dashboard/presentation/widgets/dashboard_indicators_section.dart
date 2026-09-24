import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/app_colors.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/premium_indicator_card.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';

class DashboardIndicatorsSection extends GetView<DashboardController> {
  const DashboardIndicatorsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final res = context.responsive;
    final bool isSmallScreen = res.isMobile;

    final int crossAxisCount = isSmallScreen
        ? 1
        : (res.screenWidth < 1200 ? 2 : 3);

    final double childAspectRatio = isSmallScreen
        ? 1.5
        : (res.screenWidth < 1400 ? 1.1 : 2.1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Text(
            'المؤشرات الرئيسية',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Obx(() {
          final s = controller.stats.value;
          final pendingTrend =
              controller.getStatusTrendData(OrderStatus.pending);
          final deliveredTrend =
              controller.getStatusTrendData(OrderStatus.delivered);
          final cancelledTrend =
              controller.getStatusTrendData(OrderStatus.cancelled);

          return GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: childAspectRatio,
              crossAxisSpacing: res.itemSpacing * 1.5,
              mainAxisSpacing: res.itemSpacing * 1.5,
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
          );
        }),
      ],
    );
  }
}
