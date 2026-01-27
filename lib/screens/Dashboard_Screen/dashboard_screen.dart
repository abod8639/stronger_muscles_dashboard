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
        showStatus: true,
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
            child: Padding(
              padding: res.defaultPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderStatus(),
                  SizedBox(height: res.itemSpacing * 1.5),

                  // فترة المراقبة
                  _buildPeriodSelector(res),
                  SizedBox(height: res.itemSpacing * 2),

                  if (controller.orders.isEmpty)
                    _buildNoDataState(res)
                  else ...[
                    // البطاقات العلوية (Top Assets)
                    _buildTopAssetsSection(res, isDark),
                    SizedBox(height: res.itemSpacing * 2),

                    // الشبكة الرئيسية للإحصائيات والرسوم
                    _buildMainGrid(res, isDark),
                    SizedBox(height: res.itemSpacing * 2),

                    // الطلبات الأخيرة والفئات
                    _buildBottomSection(res),
                  ],
                  SizedBox(height: res.itemSpacing * 2),
                ],
              ),
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

  Widget _buildPeriodSelector(ResponsiveLayout res) {
    return Obx(
      () => HorizontalChipsSelector(
        items: controller.periodItems,
        selectedId: controller.selectPeriod.value,
        onSelect: (id) => controller.selectPeriod.value = id,
        labelKey: 'name',
        idKey: 'id',
        showAllOption: false,
        allLabel: 'الكل',
      ),
    );
  }

  Widget _buildSectionTitle(String title, ResponsiveLayout res, bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: res.defaultPadding.left,
        vertical: res.itemSpacing,
      ),
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

  Widget _buildTopAssetsSection(ResponsiveLayout res, bool isDark) {
    final assetCards = [
      {
        'title': 'معلقة',
        'value': controller.pendingOrders.value,
        'icon': Icons.hourglass_empty,
        'color': AppColors.warning,
      },
      {
        'title': 'معالجة',
        'value': controller.processingOrders.value,
        'icon': Icons.hourglass_bottom,
        'color': AppColors.info,
      },
      {
        'title': 'مرسلة',
        'value': controller.shippedOrders.value,
        'icon': Icons.local_shipping,
        'color': AppColors.accent,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('أفضل الطلبات', res, isDark),
        SizedBox(
          height: 200,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              // crossAxisCount: res.isMobile ? 1 : (res.isDesktop ? 1 : 2),
              crossAxisCount: 1,
              childAspectRatio: res.isMobile ? 1.5 : (res.isTablet ? 1 : 1),
              crossAxisSpacing: res.itemSpacing,
              mainAxisSpacing: res.itemSpacing,
            ),
            itemCount: assetCards.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final card = assetCards[index];
              return _buildAssetCard(
                title: card['title'] as String,
                value: card['value'] as int,
                icon: card['icon'] as IconData,
                color: card['color'] as Color,
                res: res,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAssetCard({
    required String title,
    required int value,
    required IconData icon,
    required Color color,
    required ResponsiveLayout res,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.1),
            color.withValues(alpha: 0.05),
          ],
        ),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      padding: EdgeInsets.all(res.itemSpacing),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(res.itemSpacing * 0.75),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              Icon(Icons.open_in_new, size: 16, color: color.withValues(alpha: 0.6)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: res.getTitleFontSize() - 2,
                  color: Colors.grey,
                ),
              ),
              Text(
                '$value',
                style: TextStyle(
                  fontSize: res.getTitleFontSize() + 4,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainGrid(ResponsiveLayout res, bool isDark) {
    return Column(
      children: [
        // الصف الأول: الإحصائيات
        DashboardStatsGrid(),
        SizedBox(height: res.itemSpacing * 2),

        // الصف الثاني: الرسوم البيانية
        LayoutBuilder(
          builder: (context, constraints) {
            final isSmallScreen = res.isMobile;
            return Column(
              children: [
                // الرسم البياني الدائري والبيانات جنباً إلى جنب أو متراصة
                if (isSmallScreen)
                  Column(
                    children: [
                      PieChartWidget(
                        showLegend: true,
                        title: 'توزيع حالات الطلبات',
                        data: _getPieChartData(),
                      ),
                      SizedBox(height: res.itemSpacing * 2),
                      BarChartWidget(
                        title: 'إجمالي الطلبات حسب الحالة',
                        groups: _getBarChartGroups(),
                        bottomTitles: const ['معلقة', 'معالجة', 'مرسلة', 'تسليم', 'ملغاة'],
                        maxY: controller.orders.length.toDouble() + 5,
                      ),
                    ],
                  )
                else
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: PieChartWidget(
                          showLegend: true,
                          title: 'توزيع حالات الطلبات',
                          data: _getPieChartData(),
                        ),
                      ),
                      SizedBox(width: res.itemSpacing * 2),
                      Expanded(
                        flex: 1,
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
          },
        ),
      ],
    );
  }

  Widget _buildBottomSection(ResponsiveLayout res) {
    return Column(
      children: [
        _buildRecentOrders(res),
        SizedBox(height: res.itemSpacing * 2),
        _buildCategoriesSection(res),
      ],
    );
  }

  Widget _buildRecentOrders(ResponsiveLayout res) {
    return RecentOrdersList(
      orders: controller.orders.take(5).toList(),
      onSeeAll: () => Get.toNamed('/orders'),
    );
  }

  Widget _buildCategoriesSection(ResponsiveLayout res) {
    if (controller.categories.isEmpty) return const SizedBox();
    return CategoriesGrid(
      categories: controller.categories,
      onSeeAll: () => Get.toNamed('/categories'),
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

  Widget _buildNoDataState(ResponsiveLayout res) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: res.defaultPadding.left,
      ),
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
