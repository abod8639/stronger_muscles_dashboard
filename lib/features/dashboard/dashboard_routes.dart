import 'package:go_router/go_router.dart';
import 'package:stronger_muscles_dashboard/core/router/app_routes.dart';
import 'presentation/pages/dashboard_page.dart';

/// Modular GoRouter route definitions for the Dashboard feature.
/// Ensures complete route isolation per architectural rule #6.
class DashboardRoutes {
  const DashboardRoutes._();

  static List<RouteBase> get routes => [
        GoRoute(
          path: AppRoutes.dashboard,
          name: 'dashboard',
          builder: (context, state) => const DashboardPage(),
        ),
      ];
}
