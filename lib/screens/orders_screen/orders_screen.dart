import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/screens/orders_screen/widgets/build_search_bar.dart';
import 'package:stronger_muscles_dashboard/screens/orders_screen/widgets/build_app_bar.dart';
import 'package:stronger_muscles_dashboard/screens/orders_screen/widgets/build_empty_state.dart';
import 'package:stronger_muscles_dashboard/screens/orders_screen/widgets/build_status_tabs.dart';
import 'package:stronger_muscles_dashboard/screens/widgets/search_bar.dart';
import '../../components/enhanced_error_widget.dart';
import '../../controllers/orders_controller.dart';
import '../../components/index.dart';
import '../../config/responsive.dart';
import 'order_details_screen.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrdersController());
    final responsive = context.responsive;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: buildAppBar( controller, responsive),
      body: Column(
        children: [
          // buildSearchBar( controller),
          Search_Bar(
            hintText: 'ابحث عن منتج بالاسم أو الماركة...',
            padding: responsive.defaultPadding,
            isDark: true,
            controller: controller,
            responsive: responsive,
          ),
          buildStatusTabs(controller),
          const SizedBox(height: 8),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.filteredOrders.isEmpty) {
                return const Center(child: EnhancedLoadingWidget(message: 'جاري تحميل الطلبات...'));
              }

              if (controller.errorMessage.isNotEmpty && controller.filteredOrders.isEmpty) {
                return EnhancedErrorWidget(
                  title: 'حدث خطأ',
                  icon: Icons.error,
                  message: controller.errorMessage.value,
                  onRetry: () => controller.fetchOrders(),
                );
              }

              if (controller.filteredOrders.isEmpty) {
                return buildEmptyState(controller);
              }

              return RefreshIndicator(
                onRefresh: () => controller.fetchOrders(),
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.defaultPadding.left,
                    vertical: 10,
                  ),
                  itemCount: controller.filteredOrders.length,
                  itemBuilder: (context, index) {
                    final order = controller.filteredOrders[index];
                    return AnimatedOrderListTile(
                      order: order,
                      index: index,
                      onTap: () {
                        Get.to(() => OrderDetailsScreen(order: order));
                      },
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
