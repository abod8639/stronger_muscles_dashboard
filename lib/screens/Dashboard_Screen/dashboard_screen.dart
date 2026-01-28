import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
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
      appBar: _buildAppBar(),
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
                    _buildHeaderStatus(),
                    SizedBox(height: res.itemSpacing * 2),

                    // عنوان رئيسي جذاب
                    _buildDashboardTitle(res),
                    SizedBox(height: res.itemSpacing * 2),

                    // فترة المراقبة
                    _buildPeriodSelector(res),
                    SizedBox(height: res.itemSpacing * 3),

                    if (controller.orders.isEmpty)
                      _buildNoDataState(res)
                    else ...[
                      // البطاقات الرئيسية للمؤشرات
                      _buildMainIndicatorsSection(res),
                      SizedBox(height: res.itemSpacing * 3),

                      // الرسوم البيانية
                      _buildChartsSection(res),
                      SizedBox(height: res.itemSpacing * 3),

                      // الطلبات الأخيرة والفئات
                      _buildBottomSection(res),
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
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColorsExtended.purpleAccent,
                  AppColorsExtended.cyanAccent,
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.dashboard, size: 20),
          ),
          const SizedBox(width: 12),
          const Text(
            'لوحة التحكم',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 20,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
      backgroundColor: AppColorsExtended.cardBg,
      elevation: 0,
      centerTitle: false,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColorsExtended.surfaceDark,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColorsExtended.borderColor,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.refresh,
                    color: AppColorsExtended.cyanAccent,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => controller.fetchDashboardData(),
                    child: Text(
                      'تحديث',
                      style: TextStyle(
                        color: AppColorsExtended.cyanAccent,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDashboardTitle(ResponsiveLayout res) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'مرحباً بك مجدداً! 👋',
          style: TextStyle(
            fontSize: res.getTitleFontSize() + 2,
            fontWeight: FontWeight.w900,
            color: AppColorsExtended.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'إليك ملخص أداء عملك اليوم',
          style: TextStyle(
            fontSize: 14,
            color: AppColorsExtended.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
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

  Widget _buildSectionTitle(String title, ResponsiveLayout res) {
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

  Widget _buildMainIndicatorsSection(ResponsiveLayout res) {
    final isSmallScreen = res.isMobile;
    final crossAxisCount = isSmallScreen ? 1 : (res.isTablet ? 2 : 3);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('المؤشرات الرئيسية', res),
        SizedBox(height: res.itemSpacing),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: isSmallScreen ? 1.35 : 1.25,
            crossAxisSpacing: res.itemSpacing * 1.8,
            mainAxisSpacing: res.itemSpacing * 1.8,
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            return _buildIndicatorCard(index);
          },
        ),
      ],
    );
  }

  Widget _buildIndicatorCard(int index) {
    final indicators = [
      {
        'title': 'معلقة',
        'subtitle': 'Pending Orders',
        'value': controller.pendingOrders.value.toString(),
        'color': AppColorsExtended.purpleDark,
        'icon': Icons.hourglass_empty,
        'trend': '${5 + index * 2}%',
        'isUp': true,
      },
      {
        'title': 'معالجة',
        'subtitle': 'Processing Orders',
        'value': controller.processingOrders.value.toString(),
        'color': AppColorsExtended.purpleDark,
        'icon': Icons.hourglass_bottom,
        'trend': '${3 + index * 1}%',
        'isUp': true,
      },
      {
        'title': 'مرسلة',
        'subtitle': 'Shipped Orders',
        'value': controller.shippedOrders.value.toString(),
        'color': AppColorsExtended.purpleDark,
        'icon': Icons.local_shipping,
        'trend': '${8 + index}%',
        'isUp': true,
      },
      {
        'title': 'مسلمة',
        'subtitle': 'Delivered Orders',
        'value': controller.deliveredOrders.value.toString(),
        'color': AppColorsExtended.purpleDark,
        'icon': Icons.check_circle,
        'trend': '${12 + index}%',
        'isUp': true,
      },
      {
        'title': 'ملغاة',
        'subtitle': 'Cancelled Orders',
        'value': controller.cancelledOrders.value.toString(),
        'color': AppColorsExtended.purpleDark,
        'icon': Icons.cancel,
        'trend': '${2 - index}%',
        'isUp': false,
      },
      {
        'title': 'إجمالي',
        'subtitle': 'Total Orders',
        'value': controller.orders.length.toString(),
        'color': AppColorsExtended.purpleDark,
        'icon': Icons.dashboard,
        'trend': '${15 + index * 3}%',
        'isUp': true,
      },
    ];

    if (index >= indicators.length) return const SizedBox();

    final indicator = indicators[index];
    final chartSpots = _generateChartSpots();

    return PremiumIndicatorCard(
      title: indicator['title'] as String,
      subtitle: indicator['subtitle'] as String,
      value: indicator['value'] as String,
      icon: indicator['icon'] as IconData,
      accentColor: indicator['color'] as Color,
      trend: indicator['trend'] as String,
      trendUp: indicator['isUp'] as bool,
      chartSpots: chartSpots,
    );
  }

  Widget _buildChartsSection(ResponsiveLayout res) {
    final isSmallScreen = res.isMobile;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('تحليل البيانات', res),
        SizedBox(height: res.itemSpacing),
        if (isSmallScreen)
          Column(
            children: [
              _buildMainChartCard(res),
              SizedBox(height: res.itemSpacing * 2.5),
              _buildDetailedCard(res),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 1, child: _buildMainChartCard(res)),
              SizedBox(width: res.itemSpacing * 2.5),
              Expanded(flex: 1, child: _buildDetailedCard(res)),
            ],
          ),
      ],
    );
  }

  Widget _buildMainChartCard(ResponsiveLayout res) {
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

  Widget _buildDetailedCard(ResponsiveLayout res) {
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
      padding: EdgeInsets.symmetric(horizontal: res.defaultPadding.left),
      child: const NoDataScreen(
        title: 'لا توجد بيانات',
        message: 'لم نتمكن من جلب أي بيانات حالياً.',
      ),
    );
  }

