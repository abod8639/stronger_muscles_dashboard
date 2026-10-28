import 'package:go_router/go_router.dart';
import 'package:stronger_muscles_dashboard/core/router/app_routes.dart';
import 'presentation/pages/support_screen.dart';

/// Modular GoRouter routes declaration for the Support & Complaints feature.
abstract class SupportRoutes {
  static final List<RouteBase> routes = [
    GoRoute(
      path: AppRoutes.support,
      name: 'support',
      builder: (context, state) => const SupportScreen(),
    ),
  ];
}
