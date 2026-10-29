import 'package:go_router/go_router.dart';
import '../../core/router/app_routes.dart';
import 'presentation/pages/users_page.dart';

/// Modular Route Definitions for Users Feature.
/// Decouples route declarations from the root router configuration.
abstract class UsersRoutes {
  static final List<RouteBase> routes = [
    GoRoute(
      path: AppRoutes.users,
      name: 'users',
      builder: (context, state) => const UsersPage(),
    ),
  ];
}
