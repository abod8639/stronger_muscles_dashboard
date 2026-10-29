import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/core/components/base_app_bar.dart';
import 'package:stronger_muscles_dashboard/core/components/enhanced_error_widget.dart';
import 'package:stronger_muscles_dashboard/core/components/enhanced_loading_widget.dart';
import 'package:stronger_muscles_dashboard/core/components/generic_empty_state.dart';
import 'package:stronger_muscles_dashboard/core/components/my_refresh_indicator.dart';
import 'package:stronger_muscles_dashboard/core/theme/responsive.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/presentation/controllers/dashboard_providers.dart';
import '../widgets/categories_summary_section.dart';
import '../widgets/dashboard_charts_section.dart';
import '../widgets/dashboard_indicators_section.dart';
import '../widgets/dashboard_period_selector.dart';
import '../widgets/recent_orders_section.dart';

/// شاشة لوحة التحكم: المؤشرات، الرسم البياني، آخر الطلبات، والتصنيفات
class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  /// أقصى عرض للمحتوى على الشاشات العريضة
  static const double _maxContentWidth = 1400;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final res = context.responsive;
    final dashboardAsync = ref.watch(dashboardStatsNotifierProvider);
    Future<void> refresh() =>
        ref.read(dashboardStatsNotifierProvider.notifier).refreshDashboard();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: BaseAppBar(title: 'لوحة التحكم', onPressed: refresh),
      body: dashboardAsync.when(
        loading: () =>
            const EnhancedLoadingWidget(message: 'جاري تحميل لوحة التحكم...'),
        error: (error, _) => EnhancedErrorWidget.fromError(
          error,
          fallbackTitle: 'خطأ في تحميل البيانات',
          onRetry: refresh,
        ),
        data: (stats) {
          final hasAnyData =
              stats.totalOrders > 0 ||
              stats.totalProducts > 0 ||
              stats.totalUsers > 0 ||
              stats.orders.isNotEmpty ||
              stats.products.isNotEmpty ||
              stats.categories.isNotEmpty;
          final sectionGap = SizedBox(height: res.itemSpacing * 2.5);

          return MyRefreshIndicator(
            onRefresh: refresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: res.defaultPadding,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: _maxContentWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const DashboardPeriodSelector(),
                      SizedBox(height: res.itemSpacing),
                      const DashboardIndicatorsSection(),
                      sectionGap,
                      if (!hasAnyData)
                        const GenericEmptyState(
                          title: 'لا توجد بيانات',
                          message: 'لا توجد بيانات متاحة حالياً',
                          icon: Icons.insights_outlined,
                        )
                      else ...[
                        const DashboardChartsSection(),
                        sectionGap,
                        const RecentOrdersSection(),
                        sectionGap,
                        const CategoriesSummarySection(),
                      ],
                      sectionGap,
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
