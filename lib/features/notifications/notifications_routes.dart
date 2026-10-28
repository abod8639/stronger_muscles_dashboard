import 'package:go_router/go_router.dart';
import '../../core/router/app_routes.dart';
import 'presentation/pages/notifications_screen.dart';

/// Modular Route Definitions for Notifications Feature.
/// Decouples route declarations from the root router configuration.
abstract class NotificationsRoutes {
  static final List<RouteBase> routes = [
    GoRoute(
      path: AppRoutes.notifications,
      name: 'notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
  ];
}
