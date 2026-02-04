import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:stronger_muscles_dashboard/screens/components/enhanced_loading_widget.dart';
import 'package:stronger_muscles_dashboard/screens/components/enhanced_status_chart.dart';
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
  List<FlSpot> generateChartSpots(int count, double maxY,) {
  final controller = Get.find<DashboardController>();

  final random = List.generate(count, (i) {
    final baseValue = (controller.orders.length / 1) * (i + 2);
    final variation = (baseValue * 0.2 * (i % 2 == 0 ? -1 : 2)).toInt();
    return FlSpot(
      i.toDouble(),
      (baseValue + variation).clamp(1, maxY),
    );
  });
  return random;
}

// List<StakingDetail> generateStakingDetails() {
//   return [
//     StakingDetail(
      
//       label: 'Total Staked',
//       value: '10,000',
//       // percentage: '100%',
//       color: Colors.blue,
//     ),
//     StakingDetail(
//       label: 'Available to Stake',
//       value: '5,000',
//       // percentage: '50%',
//       color: Colors.green,
//     ),
//     StakingDetail(
//       label: 'Rewards Earned',
//       value: '1,000',
//       // percentage: '10%',
//       color: Colors.orange,
//     ),
//   ];
// }

List<StatusChartItem> genrateChartItems(){
  return [
    StatusChartItem(
      label: 'Total Staked',
      count: 10000,
      total: 20000,
      color: Colors.blue,
    ),
    StatusChartItem(
      label: 'Available to Stake',
      count: 5000,
      total: 20000,
      color: Colors.green,
    ),
    StatusChartItem(
      label: 'Rewards Earned',
      count: 1000,
      total: 20000,
      color: Colors.orange,
    ),
  ];
}