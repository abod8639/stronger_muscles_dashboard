import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/base_data_view.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:stronger_muscles_dashboard/features/navigation/presentation/controllers/navigation_controller.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/pages/order_details_screen/order_details_screen.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/widgets/order_list_tile.dart';

class RecentOrdersSection extends GetView<DashboardController> {
  const RecentOrdersSection({super.key});

  @override
  Widget build(BuildContext context) {
    final res = context.responsive;
    final navigationController = Get.find<NavigationController>();

    return Obx(() {
      final orders = controller.stats.value.orders;
      
      return BaseDataView<OrderEntity>(
        title: 'الطلبات الأخيرة',
        crossAxisCount: res.isDesktop ? 2 : 1,
        items: orders,
        onSeeAll: () => navigationController.changeIndex(4), // Orders index
        useListView: res.isTablet,
        showCount: 4,
        mainAxisExtent: 200, // Adjusted for new design
        itemBuilder: (context, order, index) {
          return OrderListTile(
            order: order,
            index: index,
            onTap: () => Get.to(() => OrderDetailsScreen(order: order)),
          );
        },
      );
    });
  }
}
