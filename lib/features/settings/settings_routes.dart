import 'package:go_router/go_router.dart';
import 'package:stronger_muscles_dashboard/core/router/app_routes.dart';
import 'presentation/page/settings_screen.dart';

/// Modular routes for the Settings feature module.
abstract class SettingsRoutes {
  static final List<RouteBase> routes = [
    GoRoute(
      path: AppRoutes.settings,
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ];
}
