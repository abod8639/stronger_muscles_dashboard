import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/app_colors.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/enhanced_loading_widget.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/my_refreshIndicator.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/presentation/controllers/dashboard_controller.dart';
import '../widgets/dashboard_header_status.dart';
import '../widgets/dashboard_period_selector.dart';
import '../widgets/dashboard_indicators_section.dart';
import '../widgets/dashboard_charts_section.dart';
import '../widgets/recent_orders_section.dart';
import '../widgets/categories_summary_section.dart';

class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final res = context.responsive;

    return Scaffold(
      backgroundColor: AppColorsExtended.backgroundColor,
      body: Obx(() {
        if (!controller.isConnected.value && controller.stats.value.orders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 60, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value.isNotEmpty 
                    ? controller.errorMessage.value 
                    : 'لا يمكن الاتصال بالخادم',
                  style: const TextStyle(color: Colors.white70),
                ),
                TextButton(
                  onPressed: () => controller.retryConnection(),
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }

        if (controller.isLoading.value && controller.stats.value.orders.isEmpty) {
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
                  const DashboardHeaderStatus(),

                  SizedBox(height: res.itemSpacing * 1),

                  const DashboardPeriodSelector(),

                  SizedBox(height: res.itemSpacing * 1),

                  if (controller.stats.value.orders.isEmpty && !controller.isLoading.value)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Text('لا توجد بيانات متاحة حالياً', style: TextStyle(color: Colors.white60)),
                      ),
                    )
                  else ...[
                    const DashboardIndicatorsSection(),

                    SizedBox(height: res.itemSpacing * 3),

                    const DashboardChartsSection(),

                    SizedBox(height: res.itemSpacing * 3),

                    const RecentOrdersSection(),

                    SizedBox(height: res.itemSpacing * 2),

                    const CategoriesSummarySection(),

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
