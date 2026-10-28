import 'package:go_router/go_router.dart';
import '../../core/router/app_routes.dart';
import 'presentation/pages/login_screen.dart';
import 'presentation/pages/signup_screen.dart';

/// Modular Route Definitions for Authentication Feature.
/// Decouples route declarations from the root router configuration.
abstract class AuthRoutes {
  static final List<RouteBase> routes = [
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.signup,
      name: 'signup',
      builder: (context, state) => const SignupScreen(),
    ),
  ];
}
