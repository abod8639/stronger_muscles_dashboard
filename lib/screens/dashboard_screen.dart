import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config/theme.dart';
import '../controllers/dashboard_controller.dart';
import '../components/index.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Obx(
        () {
          // عرض شاشة الخطأ إذا كان هناك فشل في الاتصال
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

          // عرض شاشة التحميل
          if (controller.isLoading.value && controller.orders.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // شريط حالة الاتصال
                if (!controller.isConnected.value || controller.errorMessage.value.isNotEmpty)
                  ConnectionStatusBar(
                    isConnected: controller.isConnected.value,
                    errorMessage: controller.errorMessage.value,
                    onRetry: () => controller.retryConnection(),
                  ),

                // الفترة الزمنية
                _buildPeriodSelector(context),

                // بطاقات الإحصائيات الرئيسية
                if (controller.orders.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: NoDataScreen(
                      title: 'لا توجد بيانات',
                      message: 'لم نتمكن من جلب أي بيانات من قاعدة البيانات. تأكد من وجود بيانات متاحة.',
                    ),
                  )
                else
                  _buildStatsCards(context),

                if (controller.orders.isNotEmpty) ...[
                  const SizedBox(height: 24),

                  // الطلبات الأخيرة
                  RecentOrdersList(
                    orders: controller.orders.take(3).toList(),
                    onSeeAll: () {
                      Get.toNamed('/orders');
                    },
                  ),

                  const SizedBox(height: 24),

                  // توزيع حالات الطلبات
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: OrderStatusChart(
                      pending: controller.pendingOrders.value,
                      processing: controller.processingOrders.value,
                      shipped: controller.shippedOrders.value,
                      delivered: controller.deliveredOrders.value,
                      cancelled: controller.cancelledOrders.value,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // التصنيفات
                  if (controller.categories.isNotEmpty)
                    CategoriesGrid(
                      categories: controller.categories,
                      onSeeAll: () {
                        Get.toNamed('/categories');
                      },
                    ),

                  const SizedBox(height: 24),

                  // حالة المخزون
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: StockStatusChart(
                      inStock: controller.productsInStock.value,
                      lowStock: controller.productsLowStock.value,
                      outOfStock: controller.productsOutOfStock.value,
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: const Text(
        'لوحة التحكم',
        style: TextStyle(
          color: AppColors.textDark,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Obx(
            () => Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: controller.isConnected.value
                      ? AppColors.success.withValues(alpha: 0.1)
                      : AppColors.danger.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: controller.isConnected.value
                            ? AppColors.success
                            : AppColors.danger,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      controller.isConnected.value ? 'متصل' : 'غير متصل',
                      style: TextStyle(
                        color: controller.isConnected.value
                            ? AppColors.success
                            : AppColors.danger,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPeriodSelector(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _PeriodButton(
              label: 'هذا الأسبوع',
              value: 'week',
              isSelected: controller.selectedPeriod.value == 'week',
              onTap: () => controller.changePeriod('week'),
            ),
            const SizedBox(width: 8),
            _PeriodButton(
              label: 'هذا الشهر',
              value: 'month',
              isSelected: controller.selectedPeriod.value == 'month',
              onTap: () => controller.changePeriod('month'),
            ),
            const SizedBox(width: 8),
            _PeriodButton(
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DashboardStatCard(
                  title: 'إجمالي الإيرادات',
                  value: '${controller.totalRevenue.value.toStringAsFixed(2)} ر.س',
                  icon: Icons.trending_up,
                  color: AppColors.primary,
                  showTrendIcon: true,
                  isTrendPositive: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DashboardStatCard(
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
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DashboardStatCard(
                  title: 'إجمالي المستخدمين',
                  value: controller.totalUsers.value.toString(),
                  icon: Icons.people_outline,
                  color: AppColors.success,
                  showTrendIcon: true,
                  isTrendPositive: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DashboardStatCard(
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
      ),
    );
  }
}

class _PeriodButton extends StatelessWidget {
  final String label;
  final String value;
  final bool isSelected;
  final VoidCallback onTap;

  const _PeriodButton({
    required this.label,
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          border: isSelected
              ? null
              : Border.all(color: AppColors.backgroundLight),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textDark,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
