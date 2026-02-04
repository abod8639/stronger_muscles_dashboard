import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/screens/components/glass_container.dart';
import 'package:stronger_muscles_dashboard/screens/components/my_refreshIndicator.dart';
import 'package:stronger_muscles_dashboard/screens/dashboard_screen/widget/build_recent_orders.dart';
import 'package:stronger_muscles_dashboard/screens/components/generic_empty_state.dart';
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

class _OrdersScreenState extends State<OrdersScreen> with SingleTickerProviderStateMixin {
  final controller = Get.put(OrdersController());

  @override
  Widget build(BuildContext context) {
    final res = context.responsive;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: BaseAppBar(
        title: 'إدارة الطلبات',
        onPressed: controller.fetchOrders,
        icon: Icons.refresh_rounded,
      ),
      body: MyRefreshIndicator(
        onRefresh: controller.fetchOrders,
        child: Column(
          children: [
            // 1. الجزء الثابت: الهيدر والإحصائيات
            _buildFixedHeader(res),

            // 2. الجزء المتغير: القائمة وحالاتها
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.filteredOrders.isEmpty) {
                  return buildLoadingState();
                }

                if (controller.errorMessage.isNotEmpty && controller.filteredOrders.isEmpty) {
                  return buildErrorState(controller);
                }

                if (controller.filteredOrders.isEmpty) {
                  return _buildEmptyState();
                }

                // استخدام ListView أو ScrollView واحد فقط لتجنب تعارض الـ Scrolling
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(bottom: res.defaultPadding.bottom),
                  child: buildRecentOrders(res),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFixedHeader(ResponsiveLayout res) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildEnhancedHeader(controller),
        if (res.isDesktop || res.isTablet) ...[
          const SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: res.defaultPadding.left),
            child: GlassContainer(
              padding: const EdgeInsets.all(16),
              child: buildStatsSection(),
            ),
          ),
        ],
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildEmptyState() {
    final isSearching = controller.searchQuery.value.isNotEmpty;
    return GenericEmptyState(
      title: isSearching ? 'لا توجد نتائج للبحث' : 'قائمة الطلبات فارغة',
      message: isSearching 
          ? 'تأكد من كتابة رقم الطلب أو اسم العميل بشكل صحيح' 
          : 'ستظهر الطلبات الجديدة هنا فور وصولها',
      icon: isSearching ? Icons.search_off_rounded : Icons.inbox_outlined,
      onAction: isSearching ? () => controller.onSearchChanged('') : null,
      actionLabel: isSearching ? 'مسح البحث' : null,
    );
  }
}