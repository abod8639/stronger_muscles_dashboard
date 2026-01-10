import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:stronger_muscles_dashboard/screens/Dashboard_Screen/widget/buildAppBar.dart';
import 'package:stronger_muscles_dashboard/screens/Dashboard_Screen/widget/buildDashboardScreenPeriodSelector.dart';
import 'package:stronger_muscles_dashboard/screens/Dashboard_Screen/widget/buildDashboardScreenStatsCards.dart';
import '../../config/responsive.dart';
import '../../config/theme.dart';
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

                  if (!controller.orders.isNotEmpty) ...[
                    SizedBox(height: context.responsive.itemSpacing * 3),
                    
                    // قسم الإحصائيات والرسوم البيانية
                    Padding(
                      padding: context.responsive.defaultPadding,
                      child: Text(
                        'رسوم بيانية تفصيلية',
                        style: TextStyle(
                          fontSize: context.responsive.getTitleFontSize() + 1,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    SizedBox(height: context.responsive.itemSpacing),
                    
                    // رسم بياني دائري لحالات الطلبات
                    Padding(
                      
                      padding: context.responsive.defaultPadding,
                      child: PieChartWidget(
                        
                        showLegend: true,
                        title: 'توزيع حالات الطلبات',
                        data: [
                          PieChartItemData(
                            
                            label: 'معلقة',
                            value: controller.pendingOrders.value.toDouble(),
                            color: AppColors.pending,
                          ),
                          PieChartItemData(
                            label: 'تحت المعالجة',
                            value: controller.processingOrders.value.toDouble(),
                            color: AppColors.processing,
                          ),
                          PieChartItemData(
                            label: 'مرسلة',
                            value: controller.shippedOrders.value.toDouble(),
                            color: AppColors.shipped,
                          ),
                          PieChartItemData(
                            label: 'تم التسليم',
                            value: controller.deliveredOrders.value.toDouble(),
                            color: AppColors.delivered,
                          ),
                          PieChartItemData(
                            label: 'ملغاة',
                            value: controller.cancelledOrders.value.toDouble(),
                            color: AppColors.cancelled,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: context.responsive.itemSpacing * 3),
                    
                    RecentOrdersList(
                      orders: controller.orders.take(3).toList(),
                      onSeeAll: () {
                        Get.snackbar('تنبیه', 'سيتم تحويلك لصفحة الطلبات قريباً');
                      },
                    ),
                    SizedBox(height: context.responsive.itemSpacing * 3),
                    
                    // رسم بياني بأعمدة لإجمالي الطلبات
                    Padding(
                      padding: context.responsive.defaultPadding,
                      child: BarChartWidget(
                        title: 'إجمالي الطلبات حسب الحالة',
                        groups: [
                          BarChartGroupData(
                            x: 0,
                            barRods: [
                              BarChartRodData(
                                toY: controller.pendingOrders.value.toDouble(),
                                color: AppColors.pending,
                                width: 16,
                              ),
                            ],
                          ),
                          BarChartGroupData(
                            x: 1,
                            barRods: [
                              BarChartRodData(
                                toY: controller.processingOrders.value.toDouble(),
                                color: AppColors.processing,
                                width: 16,
                              ),
                            ],
                          ),
                          BarChartGroupData(
                            x: 2,
                            barRods: [
                              BarChartRodData(
                                toY: controller.shippedOrders.value.toDouble(),
                                color: AppColors.shipped,
                                width: 16,
                              ),
                            ],
                          ),
                          BarChartGroupData(
                            x: 3,
                            barRods: [
                              BarChartRodData(
                                toY: controller.deliveredOrders.value.toDouble(),
                                color: AppColors.delivered,
                                width: 16,
                              ),
                            ],
                          ),
                          BarChartGroupData(
                            x: 4,
                            barRods: [
                              BarChartRodData(
                                toY: controller.cancelledOrders.value.toDouble(),
                                color: AppColors.cancelled,
                                width: 16,
                              ),
                            ],
                          ),
                        ],
                        bottomTitles: const ['معلقة', 'معالجة', 'مرسلة', 'تسليم', 'ملغاة'],
                        maxY: (controller.orders.length / 5).toDouble() + 10,
                      ),
                    ),
                    SizedBox(height: context.responsive.itemSpacing * 3),
                    
                    // رسم بياني خطي لتطور الطلبات
                    Padding(
                      padding: context.responsive.defaultPadding,
                      child: LineChartWidget(
                        title: 'تطور الطلبات',
                        spots: [
                          FlSpot(0, controller.pendingOrders.value.toDouble()),
                          FlSpot(1, (controller.pendingOrders.value + controller.processingOrders.value).toDouble()),
                          FlSpot(2, (controller.pendingOrders.value + controller.processingOrders.value + controller.shippedOrders.value).toDouble()),
                          FlSpot(3, (controller.pendingOrders.value + controller.processingOrders.value + controller.shippedOrders.value + controller.deliveredOrders.value).toDouble()),
                          FlSpot(4, controller.orders.length.toDouble()),
                        ],
                        bottomTitles: const ['البداية', 'المعالجة', 'الشحن', 'التسليم', 'النهاية'],
                        gradientColor: AppColors.primary,
                        maxY: controller.orders.length.toDouble() + 10,
                      ),
                    ),
                    SizedBox(height: context.responsive.itemSpacing * 3),
                    
                    if (controller.categories.isNotEmpty)
                      CategoriesGrid(
                        categories: controller.categories,
                        onSeeAll: () {},
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
