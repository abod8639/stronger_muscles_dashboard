import 'package:go_router/go_router.dart';
import '../../core/router/app_routes.dart';
import 'domain/entities/order_entity.dart';
import 'presentation/pages/order_details_screen/order_details_screen.dart';
import 'presentation/pages/orders_page.dart';

/// Modular Route Definitions for Orders Feature.
/// Decouples route declarations from the root router configuration.
abstract class OrdersRoutes {
  static final List<RouteBase> routes = [
    GoRoute(
      path: AppRoutes.orders,
      name: 'orders',
      builder: (context, state) => const OrdersPage(),
    ),
    GoRoute(
      path: AppRoutes.orderDetails,
      name: 'orderDetails',
      builder: (context, state) {
        final order = state.extra as OrderEntity?;
        if (order == null) {
          return const OrdersPage();
        }
        return OrderDetailsScreen(order: order);
      },
    ),
  ];
}
