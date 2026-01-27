import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:stronger_muscles_dashboard/screens/Dashboard_Screen/widget/error_screen.dart';
import 'package:stronger_muscles_dashboard/screens/Dashboard_Screen/widget/no_data_screen.dart';
import 'package:stronger_muscles_dashboard/screens/widgets/base_app_bar.dart';
import 'package:stronger_muscles_dashboard/screens/widgets/horizontal_chips_selector.dart';
import '../../config/responsive.dart';
import '../../config/theme.dart';
import '../../controllers/dashboard_controller.dart';
import '../../components/index.dart';
import 'widget/dashboard_stats_grid.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final res = context.responsive;

    return Scaffold(
      appBar: BaseAppBar(
        title: 'لوحة التحكم',
        showStatus: true, // الميزة التي أضفناها سابقاً
        onPressed: () => controller.fetchDashboardData(),
      ),
      body: Obx(() {
        if (!controller.isConnected.value && controller.orders.isEmpty) {
          return _buildErrorState();
        }

        if (controller.isLoading.value && controller.orders.isEmpty) {
          return const EnhancedLoadingWidget(
            message: 'جاري تحميل لوحة التحكم...',
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchDashboardData(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderStatus(),

                Obx(
                  () => HorizontalChipsSelector(
                    items: controller.periodItems,
                    selectedId: controller.selectPeriod.value,
                    onSelect: (id) => controller.selectPeriod.value = id,
                    labelKey: 'name',
                    idKey: 'id',
                    showAllOption: false,
                    allLabel: 'الكل',
                  ),
                ),

                SizedBox(height: res.itemSpacing),

                if (controller.orders.isEmpty)
                  _buildNoDataState(res)
                else ...[
                  DashboardStatsGrid(),
                  SizedBox(height: res.itemSpacing * 2),
                  _buildSectionTitle('التحليلات البيانية', res, isDark),
                  _buildChartsSection(res),
                  SizedBox(height: res.itemSpacing * 2),
                  _buildRecentOrdersSection(res),
                  SizedBox(height: res.itemSpacing * 2),
                  if (controller.categories.isNotEmpty)
                    _buildCategoriesSectionWithTitle(res, isDark),
                ],
                SizedBox(height: res.itemSpacing * 3),
              ],
            ),
          ),
        );
      }),
    );
  }

  // --- مكونات الواجهة الصغيرة لتبسيط الكود الرئيسي ---

  Widget _buildHeaderStatus() {
    return ConnectionStatusBar(
      isConnected: controller.isConnected.value,
      errorMessage: controller.errorMessage.value,
      onRetry: () => controller.retryConnection(),
    );
  }

  Widget _buildSectionTitle(String title, var res, bool isDark) {
    return Padding(
      padding: res.defaultPadding,
      child: Text(
        title,
        style: TextStyle(
          fontSize: res.getTitleFontSize() + 1,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : AppColors.textMuted,
        ),
      ),
    );
  }

  Widget _buildChartsSection(var res) {
    return Column(
      children: [
        // تخطيط الرسوم البيانية بشكل متجاوب
        if (res.isDesktop)
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: res.defaultPadding,
                  child: PieChartWidget(
                    showLegend: true,
                    title: 'توزيع حالات الطلبات',
                    data: _getPieChartData(),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: res.defaultPadding,
                  child: BarChartWidget(
                    title: 'إجمالي الطلبات حسب الحالة',
                    groups: _getBarChartGroups(),
                    bottomTitles: const ['معلقة', 'معالجة', 'مرسلة', 'تسليم', 'ملغاة'],
                    maxY: controller.orders.length.toDouble() + 5,
                  ),
                ),
              ),
            ],
          )
        else
          Column(
            children: [
              Padding(
                padding: res.defaultPadding,
                child: PieChartWidget(
                  showLegend: true,
                  title: 'توزيع حالات الطلبات',
                  data: _getPieChartData(),
                ),
              ),
              SizedBox(height: res.itemSpacing),
              Padding(
                padding: res.defaultPadding,
                child: BarChartWidget(
                  title: 'إجمالي الطلبات حسب الحالة',
                  groups: _getBarChartGroups(),
                  bottomTitles: const ['معلقة', 'معالجة', 'مرسلة', 'تسليم', 'ملغاة'],
                  maxY: controller.orders.length.toDouble() + 5,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildRecentOrders(var res) {
    return RecentOrdersList(
      orders: controller.orders.take(5).toList(),
      onSeeAll: () => Get.toNamed('/orders'),
    );
  }

  Widget _buildCategoriesSection(var res) {
    if (controller.categories.isEmpty) return const SizedBox();
    return CategoriesGrid(
      categories: controller.categories,
      onSeeAll: () => Get.toNamed('/categories'),
    );
  }

  Widget _buildCategoriesSectionWithTitle(var res, bool isDark) {
    return Column(
      children: [
        _buildSectionTitle('الفئات', res, isDark),
        _buildCategoriesSection(res),
      ],
    );
  }

  Widget _buildErrorState() {
    return ErrorScreen(
      title: 'فشل الاتصال',
      message: controller.errorMessage.value,
      onRetry: () => controller.retryConnection(),
      icon: Icons.cloud_off_outlined,
    );
  }

  Widget _buildNoDataState(var res) {
    return Padding(
      padding: res.defaultPadding,
      child: const NoDataScreen(
        title: 'لا توجد بيانات',
        message: 'لم نتمكن من جلب أي بيانات حالياً.',
      ),
    );
  }

  // --- دوال مساعدة لاستخراج البيانات الحسابية للرسوم ---

  List<PieChartItemData> _getPieChartData() {
    return [
      PieChartItemData(
        label: 'معلقة',
        value: controller.pendingOrders.value.toDouble(),
        color: AppColors.warning,
      ),
      PieChartItemData(
        label: 'معالجة',
        value: controller.processingOrders.value.toDouble(),
        color: AppColors.info,
      ),
      PieChartItemData(
        label: 'مرسلة',
        value: controller.shippedOrders.value.toDouble(),
        color: AppColors.accent,
      ),
      PieChartItemData(
        label: 'تم التسليم',
        value: controller.deliveredOrders.value.toDouble(),
        color: AppColors.success,
      ),
      PieChartItemData(
        label: 'ملغاة',
        value: controller.cancelledOrders.value.toDouble(),
        color: AppColors.error,
      ),
    ];
  }

  List<BarChartGroupData> _getBarChartGroups() {
    final values = [
      controller.pendingOrders.value,
      controller.processingOrders.value,
      controller.shippedOrders.value,
      controller.deliveredOrders.value,
      controller.cancelledOrders.value,
    ];
    return List.generate(
      values.length,
      (i) => BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: values[i].toDouble(),
            color: _getStatusColor(i),
            width: 16,
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(int index) {
    List<Color> colors = [
      AppColors.warning,
      AppColors.info,
      AppColors.accent,
      AppColors.success,
      AppColors.error,
    ];
    return colors[index];
  }
}
