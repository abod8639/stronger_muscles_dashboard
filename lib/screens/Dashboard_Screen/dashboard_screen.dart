import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/screens/Dashboard_Screen/widget/buildAppBar.dart';
import 'package:stronger_muscles_dashboard/screens/Dashboard_Screen/widget/buildDashboardScreenPeriodSelector.dart';
import 'package:stronger_muscles_dashboard/screens/Dashboard_Screen/widget/buildDashboardScreenStatsCards.dart';
import '../../config/responsive.dart';
import '../../controllers/dashboard_controller.dart';
import '../../components/index.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: buildDashboardScreenAppBar(context, isDark),
      body: Obx(
        () {
          if (!controller.isConnected.value && controller.isLoading.value) {
            return ErrorScreen(
              title: 'فشل الاتصال',
              message: controller.errorMessage.value.isEmpty
                  ? 'لا يمكن الاتصال بقاعدة البيانات. تأكد من اتصالك بالإنترنت والخادم يعمل.'
                  : controller.errorMessage.value,
              onRetry: () => controller.retryConnection(),
              icon: Icons.cloud_off_outlined,
            );
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
                  if (!controller.isConnected.value || controller.errorMessage.value.isNotEmpty)
                    ConnectionStatusBar(
                      isConnected: controller.isConnected.value,
                      errorMessage: controller.errorMessage.value,
                      onRetry: () => controller.retryConnection(),
                    ),

                  buildDashboardScreenPeriodSelector(),

                  if (controller.orders.isEmpty && !controller.isLoading.value)
                    Padding(
                      padding: context.responsive.defaultPadding,
                      child: const NoDataScreen(
                        title: 'لا توجد بيانات',
                        message: 'لم نتمكن من جلب أي بيانات من قاعدة البيانات. تأكد من وجود بيانات متاحة.',
                      ),
                    )
                  else
                    buildDashboardScreenStatsCards(),

                  if (controller.orders.isNotEmpty) ...[
                    SizedBox(height: context.responsive.itemSpacing * 3),
                    RecentOrdersList(
                      orders: controller.orders.take(3).toList(),
                      onSeeAll: () {
                        // Assuming index 3 is Orders in main.dart
                        // In main.dart, Categories is index 1, Products is 2, Orders is 3.
                        // However, we should use a proper navigation method.
                        Get.snackbar('تنبیه', 'سيتم تحويلك لصفحة الطلبات قريباً');
                      },
                    ),
                    SizedBox(height: context.responsive.itemSpacing * 3),
                    Card(
                      margin: EdgeInsets.symmetric(
                        horizontal: context.responsive.defaultPadding.left,
                      ),
                      child: Padding(
                        padding: context.responsive.defaultPadding,
                        child: OrderStatusChart(
                          pending: controller.pendingOrders.value,
                          processing: controller.processingOrders.value,
                          shipped: controller.shippedOrders.value,
                          delivered: controller.deliveredOrders.value,
                          cancelled: controller.cancelledOrders.value,
                        ),
                      ),
                    ),
                    SizedBox(height: context.responsive.itemSpacing * 3),
                    if (controller.categories.isNotEmpty)
                      CategoriesGrid(
                        categories: controller.categories,
                        onSeeAll: () {
                          // Categories is index 1
                        },
                      ),
                    SizedBox(height: context.responsive.itemSpacing * 3),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  
}
