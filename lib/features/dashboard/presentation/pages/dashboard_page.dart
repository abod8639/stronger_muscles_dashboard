import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/core/theme/app_colors.dart';
import 'package:stronger_muscles_dashboard/core/theme/responsive.dart';
import 'package:stronger_muscles_dashboard/core/error/failures.dart';
import 'package:stronger_muscles_dashboard/core/components/enhanced_error_widget.dart';
import 'package:stronger_muscles_dashboard/core/components/enhanced_loading_widget.dart';
import 'package:stronger_muscles_dashboard/core/components/my_refresh_indicator.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/presentation/controllers/dashboard_providers.dart';
import '../widgets/categories_summary_section.dart';
import '../widgets/dashboard_charts_section.dart';
import '../widgets/dashboard_header_status.dart';
import '../widgets/dashboard_indicators_section.dart';
import '../widgets/dashboard_period_selector.dart';
import '../widgets/recent_orders_section.dart';

/// Dumb presentation widget for the Dashboard screen.
/// Adheres to:
/// - Zero business or data calculation logic inside UI
/// - No cross-feature private imports (uses core EnhancedErrorWidget)
/// - Selective state listening via Riverpod
class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final res = context.responsive;
    final dashboardAsync = ref.watch(dashboardStatsNotifierProvider);

    return Scaffold(
      backgroundColor: AppColorsExtended.backgroundColor,
      body: dashboardAsync.when(
        loading: () => const EnhancedLoadingWidget(
          message: 'جاري تحميل لوحة التحكم...',
        ),
        error: (error, stackTrace) {
          final errorMessage = error is Failure ? error.toMessage() : error.toString();
          return EnhancedErrorWidget(
            title: 'خطأ في تحميل البيانات',
            message: errorMessage,
            onRetry: () => ref
                .read(dashboardStatsNotifierProvider.notifier)
                .refreshDashboard(),
          );
        },
        data: (stats) {
          final hasAnyData = stats.totalOrders > 0 ||
              stats.totalProducts > 0 ||
              stats.totalUsers > 0 ||
              stats.orders.isNotEmpty ||
              stats.products.isNotEmpty ||
              stats.categories.isNotEmpty;

          return MyRefreshIndicator(
            onRefresh: () => ref
                .read(dashboardStatsNotifierProvider.notifier)
                .refreshDashboard(),
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
                    SizedBox(height: res.itemSpacing),
                    const DashboardPeriodSelector(),
                    SizedBox(height: res.itemSpacing),
                    const DashboardIndicatorsSection(),
                    SizedBox(height: res.itemSpacing * 3),
                    if (!hasAnyData)
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
