import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/screens/Dashboard_Screen/widget/buildAppBar.dart';
import '../../config/theme.dart';
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

                  _buildPeriodSelector(context, isDark),

                  if (controller.orders.isEmpty && !controller.isLoading.value)
                    Padding(
                      padding: context.responsive.defaultPadding,
                      child: const NoDataScreen(
                        title: 'لا توجد بيانات',
                        message: 'لم نتمكن من جلب أي بيانات من قاعدة البيانات. تأكد من وجود بيانات متاحة.',
                      ),
                    )
                  else
                    _buildStatsCards(context),

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
  Widget _buildPeriodSelector(BuildContext context, bool isDark) {
    final responsive = context.responsive;
    final spacing = responsive.itemSpacing;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.defaultPadding.left,
        vertical: responsive.defaultPadding.top / 2,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            PeriodButton(
              label: 'هذا الأسبوع',
              value: 'week',
              isSelected: controller.selectedPeriod.value == 'week',
              onTap: () => controller.changePeriod('week'),
            ),
            SizedBox(width: spacing),
            PeriodButton(
              label: 'هذا الشهر',
              value: 'month',
              isSelected: controller.selectedPeriod.value == 'month',
              onTap: () => controller.changePeriod('month'),
            ),
            SizedBox(width: spacing),
            PeriodButton(
              label: 'هذا العام',
              value: 'year',
              isSelected: controller.selectedPeriod.value == 'year',
              onTap: () => controller.changePeriod('year'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCards(BuildContext context) {
    final responsive = context.responsive;
    final spacing = responsive.itemSpacing;
    final isMobile = responsive.isMobile;
    final isTablet = responsive.isTablet;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.defaultPadding.left,
      ),
      child: isMobile
          ? Column(
              children: [
                // صف أول
                Row(
                  children: [
                    Expanded(
                      child: AnimatedStatCard(
                        title: 'إجمالي الإيرادات',
                        value: '${controller.totalRevenue.value.toStringAsFixed(2)} ر.س',
                        icon: Icons.trending_up,
                        color: AppColors.primary,
                        showTrendIcon: true,
                        isTrendPositive: true,
                      ),
                    ),
                    SizedBox(width: spacing),
                    Expanded(
                      child: AnimatedStatCard(
                        title: 'إجمالي الطلبات',
                        value: controller.totalOrders.value.toString(),
                        icon: Icons.shopping_bag_outlined,
                        color: AppColors.secondary,
                        showTrendIcon: true,
                        isTrendPositive: false,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: spacing),
                // صف ثاني
                Row(
                  children: [
                    Expanded(
                      child: AnimatedStatCard(
                        title: 'إجمالي المستخدمين',
                        value: controller.totalUsers.value.toString(),
                        icon: Icons.people_outline,
                        color: AppColors.success,
                        showTrendIcon: true,
                        isTrendPositive: true,
                      ),
                    ),
                    SizedBox(width: spacing),
                    Expanded(
                      child: AnimatedStatCard(
                        title: 'إجمالي المنتجات',
                        value: controller.totalProducts.value.toString(),
                        icon: Icons.inventory_2_outlined,
                        color: AppColors.warning,
                        showTrendIcon: false,
                      ),
                    ),
                  ],
                ),
              ],
            )
          : isTablet
              ? Column(
                  children: [
                    // صف أول - 3 كارتات
                    Row(
                      children: [
                        Expanded(
                          child: AnimatedStatCard(
                            title: 'إجمالي الإيرادات',
                            value: '${controller.totalRevenue.value.toStringAsFixed(2)} ر.س',
                            icon: Icons.trending_up,
                            color: AppColors.primary,
                            showTrendIcon: true,
                            isTrendPositive: true,
                          ),
                        ),
                        SizedBox(width: spacing),
                        Expanded(
                          child: AnimatedStatCard(
                            title: 'إجمالي الطلبات',
                            value: controller.totalOrders.value.toString(),
                            icon: Icons.shopping_bag_outlined,
                            color: AppColors.secondary,
                            showTrendIcon: true,
                            isTrendPositive: false,
                          ),
                        ),
                        SizedBox(width: spacing),
                        Expanded(
                          child: AnimatedStatCard(
                            title: 'إجمالي المستخدمين',
                            value: controller.totalUsers.value.toString(),
                            icon: Icons.people_outline,
                            color: AppColors.success,
                            showTrendIcon: true,
                            isTrendPositive: true,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: spacing),
                    // صف ثاني - كارت واحد
                    Row(
                      children: [
                        Expanded(
                          child: AnimatedStatCard(
                            title: 'إجمالي المنتجات',
                            value: controller.totalProducts.value.toString(),
                            icon: Icons.inventory_2_outlined,
                            color: AppColors.warning,
                            showTrendIcon: false,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : // سطح المكتب - 4 كارتات في صف واحد
              Row(
                  children: [
                    Expanded(
                      child: AnimatedStatCard(
                        title: 'إجمالي الإيرادات',
                        value: '${controller.totalRevenue.value.toStringAsFixed(2)} ر.س',
                        icon: Icons.trending_up,
                        color: AppColors.primary,
                        showTrendIcon: true,
                        isTrendPositive: true,
                      ),
                    ),
                    SizedBox(width: spacing),
                    Expanded(
                      child: AnimatedStatCard(
                        title: 'إجمالي الطلبات',
                        value: controller.totalOrders.value.toString(),
                        icon: Icons.shopping_bag_outlined,
                        color: AppColors.secondary,
                        showTrendIcon: true,
                        isTrendPositive: false,
                      ),
                    ),
                    SizedBox(width: spacing),
                    Expanded(
                      child: AnimatedStatCard(
                        title: 'إجمالي المستخدمين',
                        value: controller.totalUsers.value.toString(),
                        icon: Icons.people_outline,
                        color: AppColors.success,
                        showTrendIcon: true,
                        isTrendPositive: true,
                      ),
                    ),
                    SizedBox(width: spacing),
                    Expanded(
                      child: AnimatedStatCard(
                        title: 'إجمالي المنتجات',
                        value: controller.totalProducts.value.toString(),
                        icon: Icons.inventory_2_outlined,
                        color: AppColors.warning,
                        showTrendIcon: false,
                      ),
                    ),
                  ],
                ),
    );
  }
}

class PeriodButton extends StatelessWidget {
  final String label;
  final String value;
  final bool isSelected;
  final VoidCallback onTap;

  const PeriodButton({
    required this.label,
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final responsive = context.responsive;
    final padding = responsive.defaultPadding;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: padding.left,
          vertical: padding.top / 2,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          border: isSelected
              ? null
              : Border.all(color: isDark ? Colors.grey.shade800 : AppColors.backgroundLight),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : (isDark ? Colors.grey.shade400 : AppColors.textDark),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
