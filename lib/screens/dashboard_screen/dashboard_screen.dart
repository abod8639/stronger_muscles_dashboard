import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:stronger_muscles_dashboard/controllers/categories_controller.dart';
import 'package:stronger_muscles_dashboard/screens/categories_screen/categories_screen.dart';
import 'package:stronger_muscles_dashboard/screens/components/my_refreshIndicator.dart';
import 'package:stronger_muscles_dashboard/screens/dashboard_screen/widget/build_app_bar.dart';
import 'package:stronger_muscles_dashboard/screens/dashboard_screen/widget/build_dashboard_title.dart';
import 'package:stronger_muscles_dashboard/screens/dashboard_screen/widget/build_indicator_card.dart';
import 'package:stronger_muscles_dashboard/screens/dashboard_screen/widget/build_main_chart_card.dart';
import 'package:stronger_muscles_dashboard/screens/dashboard_screen/widget/error_screen.dart';
import 'package:stronger_muscles_dashboard/screens/dashboard_screen/widget/no_data_screen.dart';
import 'package:stronger_muscles_dashboard/screens/components/horizontal_chips_selector.dart';
import 'package:stronger_muscles_dashboard/screens/orders_screen/orders_screen.dart';
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
  final bool isSmallScreen = res.isMobile;

  final int crossAxisCount = isSmallScreen
      ? 1
      : (res.screenWidth < 1200 ? 2 : 3);

  final double childAspectRatio = isSmallScreen
      ? 1.5
      : (res.screenWidth < 1400 ? 1.1 : 1.5);

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
          childAspectRatio: childAspectRatio,
          crossAxisSpacing: res.itemSpacing * 1.5,
          mainAxisSpacing: res.itemSpacing * 1.5,
        ),
        itemCount: 3,
        itemBuilder: (context, index) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 300 + (index * 100)),
            curve: Curves.easeOut,
            child: buildIndicatorCard(index),
          );
        },
      ),
    ],
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

  Widget buildRecentOrders(ResponsiveLayout res ) {
  final controller = Get.find<DashboardController>();
  // final categorController = Get.find<CategoriesController>();

  return Builder(
    builder: (context) {
      return RecentOrdersList(
        orders: controller.orders.take(res.isMobile ? 3 : 6).toList(),
        onSeeAll: () => 
        // showCategoryForm(
        //  context,
        //  categorController,
        //  category: category,
        //  ),
        
         Get.to(OrdersScreen()) ,
      );
    }
  );
}

  Widget buildCategoriesSection(ResponsiveLayout res) {
  final dashboardController = Get.find<DashboardController>();
  final categorController = Get.find<CategoriesController>();


  if (dashboardController.categories.isEmpty) return const SizedBox();
  return Builder(
    builder: (context) {
      return CategoriesGrid(
        categories: dashboardController.categories,
        onSeeAll: () => 
        // Get.to(CategoriesScreen())
        showCategoryForm(
        context,
        categorController,
        category: dashboardController.categories.first ,
        ),
        
      );
    }
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
