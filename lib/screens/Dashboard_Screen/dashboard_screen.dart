import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:stronger_muscles_dashboard/models/indicators_model.dart';
import 'package:stronger_muscles_dashboard/screens/Dashboard_Screen/widget/build_app_bar.dart';
import 'package:stronger_muscles_dashboard/screens/Dashboard_Screen/widget/build_dashboard_title.dart';
import 'package:stronger_muscles_dashboard/screens/Dashboard_Screen/widget/error_screen.dart';
import 'package:stronger_muscles_dashboard/screens/Dashboard_Screen/widget/no_data_screen.dart';
import 'package:stronger_muscles_dashboard/screens/widgets/horizontal_chips_selector.dart';
import '../../config/responsive.dart';
import '../../config/app_colors.dart';
import '../../controllers/dashboard_controller.dart';
import '../../components/index.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());
    final res = context.responsive;

    return Scaffold(
      backgroundColor: AppColorsExtended.darkBg,
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

        return RefreshIndicator(
          backgroundColor: AppColorsExtended.cardBg,
          color: AppColorsExtended.cyanAccent,
          onRefresh: () => controller.fetchDashboardData(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColorsExtended.darkBg,
                    AppColorsExtended.surfaceDark.withValues(alpha: 0.2),
                  ],
                ),
              ),
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

                    // عنوان رئيسي جذاب
                    buildDashboardTitle(res),
                    SizedBox(height: res.itemSpacing * 2),

                    // فترة المراقبة
                    buildPeriodSelector(res),
                    SizedBox(height: res.itemSpacing * 3),

                    if (controller.orders.isEmpty)
                      buildNoDataState(res)
                    else ...[
                      // البطاقات الرئيسية للمؤشرات
                      buildMainIndicatorsSection(res),
                      SizedBox(height: res.itemSpacing * 3),

                      // الرسوم البيانية
                      buildChartsSection(res),
                      SizedBox(height: res.itemSpacing * 3),

                      // الطلبات الأخيرة والفئات
                      buildBottomSection(res),
                    ],
                    SizedBox(height: res.itemSpacing * 3),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}


  Widget buildHeaderStatus() {
    final controller = Get.find<DashboardController>();
    return ConnectionStatusBar(
      isConnected: controller.isConnected.value,
      errorMessage: controller.errorMessage.value,
      onRetry: () => controller.retryConnection(),
    );
  }

  Widget buildPeriodSelector(ResponsiveLayout res) {
        final controller = Get.find<DashboardController>();

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

  Widget buildSectionTitle(String title, ResponsiveLayout res) {
    return Padding(
      padding: EdgeInsets.only(bottom: res.itemSpacing),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              color: AppColorsExtended.cyanAccent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: res.getTitleFontSize(),
              fontWeight: FontWeight.bold,
              color: AppColorsExtended.textPrimary,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMainIndicatorsSection(ResponsiveLayout res) {
    final isSmallScreen = res.isMobile;
    final crossAxisCount = isSmallScreen ? 1 : (res.isTablet ? 2 : 3);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle('المؤشرات الرئيسية', res),
        SizedBox(height: res.itemSpacing),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: isSmallScreen ? 1.5 : 1.25,
            crossAxisSpacing: res.itemSpacing * 1.8,
            mainAxisSpacing: res.itemSpacing * 1.8,
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            return buildIndicatorCard(index);
          },
        ),
      ],
    );
  }

// indicators models


  Widget buildIndicatorCard(int index) {
        final controller = Get.find<DashboardController>();

    final List<IndicatorsModel> indicators = [
      IndicatorsModel(
        title: 'معلقة',
        subtitle: 'Pending Orders',
        value: controller.pendingOrders.value.toString(),
        color: AppColorsExtended.purpleDark,
        icon: Icons.hourglass_empty,
        trend: '${5 + index * 2}%',
        isUp: true,
        chartColor: AppColorsExtended.redAccent,
      ),
      IndicatorsModel(
        title: 'معالجة',
        subtitle: 'Processing Orders',
        value: controller.processingOrders.value.toString(),
        color: AppColorsExtended.purpleDark,
        icon: Icons.hourglass_bottom,
        trend: '${3 + index * 1}%',
        isUp: true,
        chartColor: AppColorsExtended.purpleAccent,
      ),
      IndicatorsModel(
        title: 'مرسلة',
        subtitle: 'Shipped Orders',
        value: controller.shippedOrders.value.toString(),
        color: AppColorsExtended.purpleDark,
        icon: Icons.local_shipping,
        trend: '${8 + index}%',
        isUp: true,
        chartColor: AppColorsExtended.purpleAccent,
      ),
      IndicatorsModel(
        title: ' المسلمة',
        subtitle: 'Delivered Orders',
        value: controller.deliveredOrders.value.toString(),
        color: AppColorsExtended.purpleDark,
        icon: Icons.check_circle,
        trend: '${12 + index}%',
        isUp: true,
        chartColor: AppColorsExtended.purpleAccent,
      ),
      IndicatorsModel(
        title: 'ملغاة',
        subtitle: 'Cancelled Orders',
        value: controller.cancelledOrders.value.toString(),
        color: AppColorsExtended.purpleDark,
        icon: Icons.cancel,
        trend: '${2 - index}%',
        isUp: false,
        chartColor: AppColorsExtended.purpleAccent,
      ),
      IndicatorsModel(
        title: 'إجمالي',
        subtitle: 'Total Orders',
        value: controller.orders.length.toString(),
        color: AppColorsExtended.purpleDark,
        icon: Icons.dashboard,
        trend: '${15 + index * 3}%',
        isUp: true,
        chartColor: AppColorsExtended.purpleAccent,
      ),
    ];

    if (index >= indicators.length) return const SizedBox();

    final indicator = indicators[index];
    final chartSpots = _generateChartSpots();

    return PremiumIndicatorCard(
      title: indicator.title,
      subtitle: indicator.subtitle,
      value: indicator.value,
      icon: indicator.icon,
      accentColor: indicator.color,
      trend: indicator.trend,
      trendUp: indicator.isUp,
      chartSpots: chartSpots,
      chartColor: indicator.chartColor,
    );
  }

  Widget buildChartsSection(ResponsiveLayout res) {
    final isSmallScreen = res.isMobile;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle('تحليل البيانات', res),
        SizedBox(height: res.itemSpacing),
        if (isSmallScreen)
          Column(
            children: [
              buildMainChartCard(res),
              SizedBox(height: res.itemSpacing * 2.5),
              buildDetailedCard(res),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 1, child: buildMainChartCard(res)),
              SizedBox(width: res.itemSpacing * 2.5),
              Expanded(flex: 1, child: buildDetailedCard(res)),
            ],
          ),
      ],
    );
  }

  Widget buildMainChartCard(ResponsiveLayout res) {
        final controller = Get.find<DashboardController>();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColorsExtended.surfaceDark.withValues(alpha: 0.3),
            AppColorsExtended.surfaceDark.withValues(alpha: 0.05),
          ],
        ),
        border: Border.all(color: AppColorsExtended.borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
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
            height: 280,
            child: EnhancedLineChartWidget(
              title: '',
              spots: _generateChartSpots(),
              lineColor: AppColorsExtended.cyanAccent,
              gradientColor: AppColorsExtended.cyanAccent,
              maxY: (controller.orders.length.toDouble() + 10),
            ),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _generateChartSpots() {
        final controller = Get.find<DashboardController>();

    final random = List.generate(30, (i) {
      final baseValue = (controller.orders.length / 30) * (i + 1);
      final variation = (baseValue * 0.3 * (i % 3 == 0 ? -1 : 1)).toInt();
      return FlSpot(
        i.toDouble(),
        (baseValue + variation).clamp(0, double.infinity),
      );
    });
    return random;
  }

  Widget buildDetailedCard(ResponsiveLayout res) {
        final controller = Get.find<DashboardController>();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColorsExtended.purpleAccent.withValues(alpha: 0.08),
            AppColorsExtended.purpleAccent.withValues(alpha: 0.02),
          ],
        ),
        border: Border.all(
          color: AppColorsExtended.purpleAccent.withValues(alpha: 0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColorsExtended.purpleAccent.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: DetailedStakingCard(
        title: 'ملخص الأداء',
        subtitle: 'إحصائيات سريعة',
        mainValue: '${controller.orders.length}',
        mainLabel: 'إجمالي الطلبات',
        icon: Icons.analytics_outlined,
        accentColor: AppColorsExtended.purpleAccent,
        details: [
          StakingDetail(
            label: 'معدل الإنجاز',
            value: controller.orders.isEmpty
                ? '0%'
                : '${((controller.deliveredOrders.value / controller.orders.length) * 100).toStringAsFixed(1)}%',
            color: AppColorsExtended.greenAccent,
          ),
          StakingDetail(
            label: 'معدل الإلغاء',
            value: controller.orders.isEmpty
                ? '0%'
                : '${((controller.cancelledOrders.value / controller.orders.length) * 100).toStringAsFixed(1)}%',
            color: AppColorsExtended.redAccent,
          ),
          StakingDetail(
            label: 'قيد المعالجة',
            value: controller.processingOrders.value.toString(),
            color: AppColorsExtended.orangeAccent,
          ),
          StakingDetail(
            label: 'المعلقة',
            value: controller.pendingOrders.value.toString(),
            color: AppColorsExtended.cyanAccent,
          ),
        ],
      ),
    );
  }

  Widget buildBottomSection(ResponsiveLayout res) {
    return Column(
      children: [
        buildRecentOrders(res),
        SizedBox(height: res.itemSpacing * 2),
        buildCategoriesSection(res),
      ],
    );
  }

  Widget buildRecentOrders(ResponsiveLayout res) {
        final controller = Get.find<DashboardController>();

    return RecentOrdersList(
      orders: controller.orders.take(5).toList(),
      onSeeAll: () => Get.toNamed('/orders'),
    );
  }

  Widget buildCategoriesSection(ResponsiveLayout res) {
        final controller = Get.find<DashboardController>();

    if (controller.categories.isEmpty) return const SizedBox();
    return CategoriesGrid(
      categories: controller.categories,
      onSeeAll: () => Get.toNamed('/categories'),
    );
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

