import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/base_data_view.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:stronger_muscles_dashboard/features/navigation/presentation/controllers/navigation_controller.dart';
import 'package:stronger_muscles_dashboard/features/orders/data/models/order_model.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/pages/order_details_screen/order_details_screen.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/pages/orders_screen/widgets/order_list_tile.dart';

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
        mainAxisExtent: 200,
        itemBuilder: (context, order, index) {
          // Temporarily mapping back to model for the legacy widget
          // In a full refactor, OrderListTile would take OrderEntity
          final orderModel = OrderModel(
            id: order.id,
            userId: order.userId,
            orderDate: order.orderDate,
            status: order.status,
            paymentStatus: order.paymentStatus,
            paymentMethod: order.paymentMethod,
            addressId: order.addressId,
            totalAmount: order.totalAmount,
            subtotal: order.subtotal,
            shippingCost: order.shippingCost,
            discount: order.discount,
            trackingNumber: order.trackingNumber,
            notes: order.notes,
            phoneNumber: order.phoneNumber,
            shippingAddress: order.shippingAddress,
          );

          return OrderListTile(
            order: orderModel,
            index: index,
            onTap: () => Get.to(() => OrderDetailsScreen(order: orderModel)),
          );
        },
      );
    });
  }
}
