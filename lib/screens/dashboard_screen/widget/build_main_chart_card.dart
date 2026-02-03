import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/screens/components/enhanced_line_chart.dart';
import 'package:stronger_muscles_dashboard/screens/components/glass_container.dart';
import 'package:stronger_muscles_dashboard/config/app_colors.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/controllers/dashboard_controller.dart';
import 'package:stronger_muscles_dashboard/screens/dashboard_screen/dashboard_screen.dart';
import 'package:stronger_muscles_dashboard/screens/dashboard_screen/widget/build_section_title.dart';

Widget buildChartsSection(ResponsiveLayout res) {
  final isSmallScreen = res.isMobile;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      buildSectionTitle('تحليل البيانات', res),
      SizedBox(height: res.itemSpacing),
      if (isSmallScreen)
        Column(children: [buildMainChartCard(res)])
      else
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Expanded(flex: 1, child: buildMainChartCard(res))],
        ),
    ],
  );
}

Widget buildMainChartCard(ResponsiveLayout res) {
  final controller = Get.find<DashboardController>();

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
                Text(
                  'اتجاه الطلبات',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColorsExtended.textPrimary,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'آخر 30 يوم',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColorsExtended.textMuted,
                  ),
                ),
              ],
            ),

            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColorsExtended.cyanAccent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColorsExtended.cyanAccent.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.trending_up,
                color: AppColorsExtended.cyanAccent,
                size: 20,
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        SizedBox(
          height: 400,
          child: EnhancedLineChartWidget(
            title: '',
            spots: generateChartSpots(10, controller.orders.length.toDouble() + 100),
            lineColor: AppColorsExtended.cyanAccent,
            gradientColor: AppColorsExtended.cyanAccent,
            maxY: (controller.orders.length.toDouble() + 100),
          ),
        ),
      ],
    ),
  );
}
