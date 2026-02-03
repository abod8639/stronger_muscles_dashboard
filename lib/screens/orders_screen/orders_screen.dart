import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/app_colors.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/screens/components/glass_container.dart';
import 'package:stronger_muscles_dashboard/screens/components/my_refreshIndicator.dart';
import 'package:stronger_muscles_dashboard/screens/components/top_section.dart';
import 'package:stronger_muscles_dashboard/screens/orders_screen/widgets/build_stats_section.dart';
import 'package:stronger_muscles_dashboard/screens/orders_screen/widgets/order_list_tile.dart';
import 'package:stronger_muscles_dashboard/screens/orders_screen/widgets/build_empty_state.dart';
import 'package:stronger_muscles_dashboard/screens/components/base_app_bar.dart';
import 'package:stronger_muscles_dashboard/screens/components/horizontal_chips_selector.dart';
import 'package:stronger_muscles_dashboard/screens/components/custom_search_bar.dart';
import '../../controllers/orders_controller.dart';
import '../components/index.dart';
import '../../config/responsive.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _headerController;

  @override
  void initState() {
    super.initState();
    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _headerController.forward();
  }

  @override
  void dispose() {
    _headerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrdersController());
    final responsive = context.responsive;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: BaseAppBar(
        title: 'الطلبات',
        onPressed: controller.fetchOrders,
        icon: Icons.refresh_rounded,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Enhanced Header Section
            _buildEnhancedHeader(controller, responsive),
        
            const SizedBox(height: 16),
        
            // Stats Section (Desktop & Tablet)
            if (responsive.isDesktop || responsive.isTablet)
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.defaultPadding.left,
                ),
                child: GlassContainer(
                  child: buildStatsSection(),
                ),
              ),
        
            if (responsive.isDesktop || responsive.isTablet)
              const SizedBox(height: 16),
        
            // Orders List
            Obx(() {
              if (controller.isLoading.value &&
                  controller.filteredOrders.isEmpty) {
                return _buildLoadingState();
              }
                    
              if (controller.errorMessage.isNotEmpty &&
                  controller.filteredOrders.isEmpty) {
                return _buildErrorState(controller);
              }
                    
              if (controller.filteredOrders.isEmpty) {
                return _buildEmptyState(controller);
              }
                    
              return MyRefreshIndicator(
                onRefresh: () => controller.fetchOrders(),
                child: AnimationLimiter(
                  child: RecentOrdersList(orders: controller.filteredOrders),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedHeader(
      OrdersController controller, ResponsiveLayout responsive) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: responsive.defaultPadding.left,
        vertical: 8,
      ),
      child: Column(
        children: [
          // Title with Counter Badge
          Obx(() {
            final totalCount = controller.filteredOrders.length;
            return Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withOpacity(0.2),
                        AppColors.primary.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    Icons.shopping_bag_outlined,
                    color: AppColors.primary,
                    size: responsive.isMobile ? 24 : 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'إدارة الطلبات',
                        style: TextStyle(
                          fontSize: responsive.isMobile ? 18 : 22,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'عرض وإدارة جميع الطلبات',
                        style: TextStyle(
                          fontSize: responsive.isMobile ? 12 : 13,
                          color: Colors.white.withOpacity(0.5),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                // Animated Counter Badge
                TweenAnimationBuilder<int>(
                  tween: IntTween(begin: 0, end: totalCount),
                  duration: const Duration(milliseconds: 500),
                  builder: (context, value, child) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primary,
                            AppColors.primary.withOpacity(0.7),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            value.toString(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'طلب',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            );
          }),

          const SizedBox(height: 16),

          // Search Bar
          CustomSearchBar(
            hintText: 'ابحث عن الطلبات بالرقم أو اسم العميل...',
            padding: EdgeInsets.zero,
            onSearch: (value) => controller.onSearchChanged(value),
          ),

          const SizedBox(height: 12),

          // Status Filter Chips
          Obx(
            () => HorizontalChipsSelector(
              items: controller.statusItems,
              selectedId: controller.selectedStatusId.value,
              onSelect: (id) => controller.selectedStatusId.value = id,
              showAllOption: true,
              allLabel: 'جميع الطلبات',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.2),
                  AppColors.primary.withOpacity(0.05),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'جاري تحميل الطلبات...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(OrdersController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.red.withOpacity(0.2),
                    Colors.red.withOpacity(0.05),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'حدث خطأ',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => controller.fetchOrders(),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('إعادة المحاولة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(OrdersController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0.02),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.inbox_outlined,
                size: 80,
                color: Colors.white.withOpacity(0.3),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'لا توجد طلبات',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              controller.searchQuery.value.isNotEmpty
                  ? 'لم يتم العثور على نتائج للبحث'
                  : 'لا توجد طلبات حالياً',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
            if (controller.searchQuery.value.isNotEmpty) ...[
              const SizedBox(height: 24),
              TextButton.icon(
                onPressed: () => controller.onSearchChanged(''),
                icon: const Icon(Icons.clear_rounded),
                label: const Text('مسح البحث'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
