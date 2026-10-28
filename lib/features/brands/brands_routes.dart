import 'package:go_router/go_router.dart';
import '../../core/router/app_routes.dart';
import 'presentation/pages/brands_page.dart';

/// Modular Route Definitions for Brands Feature.
/// Decouples route declarations from the root router configuration.
abstract class BrandsRoutes {
  static final List<RouteBase> routes = [
    GoRoute(
      path: AppRoutes.brands,
      name: 'brands',
      builder: (context, state) => const BrandsPage(),
    ),
  ];
}
