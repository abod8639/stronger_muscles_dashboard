import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/controllers/dashboard_controller.dart';
import 'package:stronger_muscles_dashboard/controllers/navigation_controller.dart';
import 'package:stronger_muscles_dashboard/models/order_model.dart';
import 'package:stronger_muscles_dashboard/screens/components/base_data_view.dart';
import 'package:stronger_muscles_dashboard/screens/order_details_screen/order_details_screen.dart';
import 'package:stronger_muscles_dashboard/screens/orders_screen/widgets/order_list_tile.dart';

Widget buildRecentOrders(ResponsiveLayout res) {
  final dashboardController = Get.find<DashboardController>();
  final navigationController = Get.put(NavigationController());

  return Builder(
    builder: (context) {
      return BaseDataView<OrderModel>(
  title: 'الطلبات الأخيرة',
  items: dashboardController.orders,
  onSeeAll: () => navigationController.changeIndex(3),
  // هنا نطبق منطق "التابلت" الذي كان في كودك القديم
  useListView: res.isTablet, 
  mainAxisExtent: 190,
  itemBuilder: (context, order, index) => OrderListTile(
    order: order,
    index: index,
    onTap: () => 
    Get.to(() => OrderDetailsScreen(order: order)),
  ),
);
    },
  );
}
