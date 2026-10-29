import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/core/router/app_routes.dart';
import 'package:stronger_muscles_dashboard/core/components/base_data_view.dart';
import 'package:stronger_muscles_dashboard/features/navigation/navigation_feature.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/widgets/order_list_tile.dart';

Widget buildRecentOrders(ResponsiveLayout res, List<OrderEntity> items) {
  int getCrossAxisCount(ResponsiveLayout responsive) {
    if (responsive.isDesktop) {
      return 2;
    } else {
      return 1;
    }
  }

  return Consumer(
    builder: (context, ref, _) {
      return BaseDataView<OrderEntity>(
        title: 'الطلبات الأخيرة',
        crossAxisCount: getCrossAxisCount(res),
        items: items,
        onSeeAll: () {
          ref.read(navigationControllerProvider.notifier).selectTab(3);
        },
        useListView: res.isTablet,
        showCount: 4,
        mainAxisExtent: res.isMobile ? 180 : 200,
        itemBuilder: (context, order, index) => OrderListTile(
          order: order,
          index: index,
          onTap: () => context.push(AppRoutes.orderDetails, extra: order),
        ),
      );
    },
  );
}
