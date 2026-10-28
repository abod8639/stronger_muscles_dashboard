import 'package:go_router/go_router.dart';
import 'package:stronger_muscles_dashboard/core/router/app_routes.dart';
import 'domain/entities/promo_entity.dart';
import 'presentation/pages/promo_form_screen.dart';
import 'presentation/pages/promos_screen.dart';

/// Modular routes for the Promos feature.
/// Encapsulates all promo-related navigation paths according to Clean Architecture.
abstract class PromosRoutes {
  static final List<RouteBase> routes = [
    GoRoute(
      path: AppRoutes.promos,
      name: 'promos',
      builder: (context, state) => const PromosScreen(),
    ),
    GoRoute(
      path: AppRoutes.promoForm,
      name: 'promoForm',
      builder: (context, state) {
        final promo = state.extra as PromoEntity?;
        return PromoFormScreen(promo: promo);
      },
    ),
  ];
}
