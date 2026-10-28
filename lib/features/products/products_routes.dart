import 'package:go_router/go_router.dart';
import '../../core/router/app_routes.dart';
import 'domain/entities/product_entity.dart';
import 'presentation/pages/products_screen.dart';
import 'presentation/widgets/product_form_page.dart';

/// Modular navigation routes definition for the Products feature.
class ProductsRoutes {
  static final List<RouteBase> routes = [
    GoRoute(
      path: AppRoutes.products,
      name: 'products',
      builder: (context, state) => const ProductsScreen(),
    ),
    GoRoute(
      path: AppRoutes.productForm,
      name: 'productForm',
      builder: (context, state) {
        final product = state.extra as ProductEntity?;
        return ProductFormPage(product: product);
      },
    ),
  ];
}
