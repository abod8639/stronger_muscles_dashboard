import 'package:go_router/go_router.dart';
import 'package:stronger_muscles_dashboard/core/router/app_routes.dart';
import 'presentation/page/main_navigation_screen.dart';

/// Modular GoRouter route definitions for the Navigation feature shell.
/// Strictly encapsulates route configuration per architectural rule #6.
class NavigationRoutes {
  const NavigationRoutes._();

  static List<RouteBase> get routes => [
    GoRoute(
      path: AppRoutes.dashboard,
      name: 'dashboard',
      builder: (context, state) => const MainNavigationScreen(),
    ),
  ];
}
