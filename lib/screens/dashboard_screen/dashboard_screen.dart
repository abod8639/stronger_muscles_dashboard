import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:stronger_muscles_dashboard/screens/components/my_refreshIndicator.dart';
import 'package:stronger_muscles_dashboard/screens/dashboard_screen/widget/build_app_bar.dart';
import 'package:stronger_muscles_dashboard/screens/dashboard_screen/widget/build_bottom_section.dart';
import 'package:stronger_muscles_dashboard/screens/dashboard_screen/widget/build_dashboard_title.dart';
import 'package:stronger_muscles_dashboard/screens/dashboard_screen/widget/build_header_status.dart';
import 'package:stronger_muscles_dashboard/screens/dashboard_screen/widget/build_main_chart_card.dart';
import 'package:stronger_muscles_dashboard/screens/dashboard_screen/widget/build_main_indicators_section.dart';
import 'package:stronger_muscles_dashboard/screens/dashboard_screen/widget/build_period_selector.dart';
import 'package:stronger_muscles_dashboard/screens/dashboard_screen/widget/error_screen.dart';
import 'package:stronger_muscles_dashboard/screens/dashboard_screen/widget/no_data_screen.dart';
import '../../config/responsive.dart';
import '../../config/app_colors.dart';
import '../../controllers/dashboard_controller.dart';
import '../components/index.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());
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

                    buildBottomSection(res),
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

  Widget buildErrorState() {
  final controller = Get.find<DashboardController>();

  return ErrorScreen(
    title: 'فشل الاتصال',
    message: controller.errorMessage.value,
    onRetry: () => controller.retryConnection(),
    icon: Icons.cloud_off_outlined,
  );
}

  Widget buildNoDataState(ResponsiveLayout res) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: res.defaultPadding.left),
    child: const NoDataScreen(
      title: 'لا توجد بيانات',
      message: 'لم نتمكن من جلب أي بيانات حالياً.',
    ),
  );
}

  List<FlSpot> generateChartSpots() {
  final controller = Get.find<DashboardController>();

  final random = List.generate(15, (i) {
    final baseValue = (controller.orders.length / 1) * (i + 1);
    final variation = (baseValue * 0.1 * (i % 2 == 0 ? -1 : 1)).toInt();
    return FlSpot(
      i.toDouble(),
      (baseValue + variation).clamp(1, double.infinity),
    );
  });
  return random;
}
