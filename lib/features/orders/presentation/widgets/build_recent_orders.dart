import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/core/router/app_routes.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/base_data_view.dart';
import 'package:stronger_muscles_dashboard/features/navigation/presentation/controllers/navigation_controller.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/widgets/order_list_tile.dart';

Widget buildRecentOrders(ResponsiveLayout res, List<OrderEntity> items) {
  final navigationController = Get.find<NavigationController>();

  int getCrossAxisCount(ResponsiveLayout responsive) {
    if (responsive.isDesktop) {
      return 2;
    } else {
      return 1;
    }
  }

  return Builder(
    builder: (context) {
      return BaseDataView<OrderEntity>(
        title: 'الطلبات الأخيرة',
        crossAxisCount: getCrossAxisCount(res),
        items:items,
        onSeeAll: () => navigationController.changeIndex(3),
        useListView: res.isTablet,
        showCount: 4,
        mainAxisExtent: 190,
        itemBuilder: (context, order, index) => OrderListTile(
          order: order,
          index: index,
          onTap: () => context.push(AppRoutes.orderDetails, extra: order),
        ),
      );
    },
  );
}
