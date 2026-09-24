import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/enhanced_line_chart.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/glass_container.dart';

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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'اتجاه الطلبات',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Obx(
                    () => Text(
                      controller.ordersChartData.periodSubtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white60,
                      ),
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
              final chartData = controller.ordersChartData;
              return EnhancedLineChartWidget(
                title: '',
                spots: chartData.spots,
                bottomTitles: chartData.bottomTitles,
                bottomTitleInterval: chartData.bottomTitleInterval,
                horizontalInterval: chartData.interval,
                lineColor: Colors.cyan,
                gradientColor: Colors.cyan,
                maxY: chartData.maxY,
              );
            }),
          ),
        ],
      ),
    );
  }
}
