import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/app_colors.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/enhanced_loading_widget.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/my_refresh_indicator.dart';
import 'package:stronger_muscles_dashboard/features/auth/presentation/widgets/auth_error_card.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/presentation/controllers/dashboard_binding.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/presentation/controllers/dashboard_providers.dart';
import '../widgets/dashboard_header_status.dart';
import '../widgets/dashboard_period_selector.dart';
import '../widgets/dashboard_indicators_section.dart';
import '../widgets/dashboard_charts_section.dart';
import '../widgets/recent_orders_section.dart';
import '../widgets/categories_summary_section.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // التأكد من توفر DashboardController للأدوات الفرعية المتوافقة مع GetX
    if (!Get.isRegistered<DashboardController>()) {
      DashboardBinding().dependencies();
    }

    final res = context.responsive;
    final dashboardAsync = ref.watch(dashboardStatsNotifierProvider);

    return Scaffold(
      backgroundColor: AppColorsExtended.backgroundColor,
      body: dashboardAsync.when(
        loading: () => const EnhancedLoadingWidget(
          message: 'جاري تحميل لوحة التحكم...',
        ),
        error: (error, stackTrace) {
          if (Get.isRegistered<DashboardController>()) {
            Get.find<DashboardController>().isConnected.value = false;
          }
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 550),
                child: AuthErrorCard(
                  error: error,
                  onRetry: () => ref.read(dashboardStatsNotifierProvider.notifier).refreshDashboard(),
                ),
              ),
            ),
          );
        },
        data: (stats) {
          // مزامنة البيانات مع DashboardController لتغذية جميع الأقسام والرسوم البيانية
          if (Get.isRegistered<DashboardController>()) {
            Get.find<DashboardController>().syncWithRiverpod(stats);
          }

          return MyRefreshIndicator(
            onRefresh: () => ref.read(dashboardStatsNotifierProvider.notifier).refreshDashboard(),
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

                    if (stats.orders.isEmpty && stats.products.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(40.0),
                          child: Text(
                            'لا توجد بيانات متاحة حالياً',
                            style: TextStyle(color: Colors.white60),
                          ),
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
        },
      ),
    );
  }
}
