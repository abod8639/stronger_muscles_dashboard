import 'package:go_router/go_router.dart';
import 'package:stronger_muscles_dashboard/core/router/app_routes.dart';
import 'domain/entities/category_entity.dart';
import 'presentation/page/categories_screen/categories_screen.dart';
import 'presentation/page/category_form_page/category_form_page.dart';

/// Modular GoRouter route definitions for the Categories feature.
class CategoriesRoutes {
  static List<RouteBase> get routes => [
    GoRoute(
      path: AppRoutes.categories,
      name: 'categories',
      builder: (context, state) => const CategoriesScreen(),
    ),
    GoRoute(
      path: AppRoutes.categoryForm,
      name: 'categoryForm',
      builder: (context, state) {
        final category = state.extra as CategoryEntity?;
        return CategoryFormPage(category: category);
      },
    ),
  ];
}
