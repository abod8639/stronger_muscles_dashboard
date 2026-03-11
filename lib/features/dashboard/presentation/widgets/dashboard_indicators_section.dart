import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/app_colors.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/premium_indicator_card.dart';
import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';

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
        : (res.screenWidth < 1400 ? 1.1 : 1.5);

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
                trend: '+5%',
                trendUp: true,
                chartColor: AppColorsExtended.orangeAccent,
                chartSpots: _generateSpots(s.pendingOrders.toDouble()),
              ),
              PremiumIndicatorCard(
                title: 'المسلمة',
                subtitle: 'Delivered Orders',
                value: s.deliveredOrders.toString(),
                icon: Icons.check_circle,
                accentColor: AppColorsExtended.purpleDark,
                trend: '+12%',
                trendUp: true,
                chartColor: AppColorsExtended.greenAccent,
                chartSpots: _generateSpots(s.deliveredOrders.toDouble()),
              ),
              PremiumIndicatorCard(
                title: 'ملغاة',
                subtitle: 'Cancelled Orders',
                value: s.cancelledOrders.toString(),
                icon: Icons.cancel,
                accentColor: AppColorsExtended.purpleDark,
                trend: '-2%',
                trendUp: false,
                chartColor: AppColorsExtended.redAccent,
                chartSpots: _generateSpots(s.cancelledOrders.toDouble()),
              ),
            ],
          );
        }),
      ],
    );
  }

  List<FlSpot> _generateSpots(double baseValue) {
    return List.generate(10, (i) {
      double sineValue = math.sin(i * 0.5) * (baseValue * 0.1 + 2);
      return FlSpot(i.toDouble(), (baseValue + sineValue).clamp(0, 1000000));
    });
  }
}
