import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/screens/components/glass_container.dart';
import 'package:stronger_muscles_dashboard/screens/components/my_refreshIndicator.dart';
import 'package:stronger_muscles_dashboard/screens/components/recent_orders_list.dart';
import 'package:stronger_muscles_dashboard/screens/orders_screen/widgets/build_enhanced_header.dart';
import 'package:stronger_muscles_dashboard/screens/orders_screen/widgets/build_error_state.dart';
import 'package:stronger_muscles_dashboard/screens/orders_screen/widgets/build_loading_state.dart';
import 'package:stronger_muscles_dashboard/screens/orders_screen/widgets/build_stats_section.dart';
import 'package:stronger_muscles_dashboard/screens/components/base_app_bar.dart';
import '../../controllers/orders_controller.dart';
import '../../config/responsive.dart';

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
            buildEnhancedHeader(controller),

            const SizedBox(height: 16),

            // Stats Section (Desktop & Tablet)
            if (responsive.isDesktop || responsive.isTablet)
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.defaultPadding.left,
                ),
                child: GlassContainer(child: buildStatsSection()),
              ),

            if (responsive.isDesktop || responsive.isTablet)
              const SizedBox(height: 16),

            // Orders List
            Obx(() {
              if (controller.isLoading.value &&
                  controller.filteredOrders.isEmpty) {
                return buildLoadingState();
              }

              if (controller.errorMessage.isNotEmpty &&
                  controller.filteredOrders.isEmpty) {
                return buildErrorState(controller);
              }

              if (controller.filteredOrders.isEmpty) {
                return buildEmptyState(controller);
              }

              return MyRefreshIndicator(
                onRefresh: () => controller.fetchOrders(),
                child: RecentOrdersList(orders: controller.filteredOrders),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget buildEmptyState(OrdersController controller) {
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
                style: TextButton.styleFrom(foregroundColor: AppColors.primary),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
