import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/enhanced_line_chart.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/glass_container.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;

class DashboardChartsSection extends GetView<DashboardController> {
  const DashboardChartsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final res = context.responsive;
    final isSmallScreen = res.isMobile;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Text(
            'تحليل البيانات',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        if (isSmallScreen)
          _buildChartCard(res)
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildChartCard(res)),
            ],
          ),
      ],
    );
  }

  Widget _buildChartCard(ResponsiveLayout res) {
    return GlassContainer(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'اتجاه الطلبات',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'آخر 30 يوم',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.cyan.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.cyan.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.trending_up,
                  color: Colors.cyan,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 300,
            child: Obx(() {
              final orderCount = controller.stats.value.orders.length.toDouble();
              final maxY = orderCount + 50;
              return EnhancedLineChartWidget(
                title: '',
                spots: _generateChartSpots(20, maxY, orderCount),
                lineColor: Colors.cyan,
                gradientColor: Colors.cyan,
                maxY: maxY,
              );
            }),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _generateChartSpots(int count, double maxY, double baseValue) {
    final double effectiveMaxY = maxY < 5.0 ? 50.0 : maxY;
    return List.generate(count, (i) {
      double sineValue = math.sin(i * 0.5) * (effectiveMaxY * 0.1);
      double trend = (i / count) * (effectiveMaxY * 0.2);
      double finalY = (baseValue + sineValue + trend);
      return FlSpot(
        i.toDouble(),
        finalY.clamp(0.0, effectiveMaxY),
      );
    });
  }
}
