import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:stronger_muscles_dashboard/screens/components/enhanced_loading_widget.dart';
import 'package:stronger_muscles_dashboard/screens/components/my_refreshIndicator.dart';
import 'package:stronger_muscles_dashboard/screens/dashboard_screen/widget/build_app_bar.dart';
import 'package:stronger_muscles_dashboard/screens/dashboard_screen/widget/build_categories_section.dart';
import 'package:stronger_muscles_dashboard/screens/dashboard_screen/widget/build_dashboard_title.dart';
import 'package:stronger_muscles_dashboard/screens/dashboard_screen/widget/build_error_state.dart';
import 'package:stronger_muscles_dashboard/screens/dashboard_screen/widget/build_header_status.dart';
import 'package:stronger_muscles_dashboard/screens/dashboard_screen/widget/build_main_chart_card.dart';
import 'package:stronger_muscles_dashboard/screens/dashboard_screen/widget/build_main_indicators_section.dart';
import 'package:stronger_muscles_dashboard/screens/dashboard_screen/widget/build_no_data_state.dart';
import 'package:stronger_muscles_dashboard/screens/dashboard_screen/widget/build_period_selector.dart';
import 'package:stronger_muscles_dashboard/screens/dashboard_screen/widget/build_recent_orders.dart';
import '../../config/responsive.dart';
import '../../config/app_colors.dart';
import '../../controllers/dashboard_controller.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // استخدام Get.find() بدلاً من Get.put() لتجنب إنشاء instances جديدة
    // سيتم التسجيل في main.dart باستخدام Get.lazyPut()
    final res = context.responsive;

    return Scaffold(
      backgroundColor: AppColorsExtended.darkBg.withAlpha(100),
      appBar: buildAppBar(),
      body: Obx(() {
        if (!controller.isConnected.value && controller.orders.isEmpty) {
          return buildErrorState();
        }

        if (controller.isLoading.value && controller.orders.isEmpty) {
          return const EnhancedLoadingWidget(
            message: 'جاري تحميل لوحة التحكم...',
          );
        }

        return MyRefreshIndicator(
          onRefresh: () => controller.fetchDashboardData(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: res.defaultPadding.left,
                vertical: res.defaultPadding.top,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildHeaderStatus(),

                  SizedBox(height: res.itemSpacing * 2),

                  buildDashboardTitle(res),

                  SizedBox(height: res.itemSpacing * 2),

                  buildPeriodSelector(res),

                  SizedBox(height: res.itemSpacing * 3),

                  if (controller.orders.isEmpty)
                    buildNoDataState(res)
                  else ...[
                    buildMainIndicatorsSection(res),

                    SizedBox(height: res.itemSpacing * 3),

                    buildChartsSection(res),

                    SizedBox(height: res.itemSpacing * 3),

                    buildRecentOrders(res),

                    SizedBox(height: res.itemSpacing * 2),

                    buildCategoriesSection(res),

                    SizedBox(height: res.itemSpacing * 2),
                  ],
                  SizedBox(height: res.itemSpacing * 3),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

List<FlSpot> generateChartSpots(int count, double maxY) {
  final controller = Get.find<DashboardController>();
  
  // تأكد أن maxY لا تقل عن قيمة دنيا لتجنب الخطأ
  final double effectiveMaxY = maxY < 5.0 ? 50.0 : maxY;
  final double baseValue = controller.orders.length.toDouble();

  return List.generate(count, (i) {
    // استخدام Math.sin (تأكد من عمل import 'dart:math' as math;)
    double sineValue = math.sin(i * 0.5) * (effectiveMaxY * 0.1);
    double trend = (i / count) * (effectiveMaxY * 1.2);
    
    // حساب القيمة النهائية
    double finalY = (baseValue + sineValue + trend);

    // الحل الآمن: التأكد من أن الحد الأدنى دائماً أصغر من الحد الأقصى
    return FlSpot(
      i.toDouble(), 
      finalY.clamp(0.0, effectiveMaxY) // استخدام 0.0 كحد أدنى أضمن
    );
  });
}