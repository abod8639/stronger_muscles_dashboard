import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:stronger_muscles_dashboard/core/network/auth_service.dart';
import 'package:stronger_muscles_dashboard/core/router/app_routes.dart';
import 'package:stronger_muscles_dashboard/features/auth/auth_feature.dart';
import 'package:stronger_muscles_dashboard/features/brands/brands_feature.dart';
import 'package:stronger_muscles_dashboard/features/categories/categories_feature.dart';
import 'package:stronger_muscles_dashboard/features/navigation/presentation/page/main_navigation_screen.dart';
import 'package:stronger_muscles_dashboard/features/orders/domain/entities/order_entity.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/pages/order_details_screen/order_details_screen.dart';
import 'package:stronger_muscles_dashboard/features/products/domain/entities/product_entity.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/widgets/product_form_page.dart';
import 'package:stronger_muscles_dashboard/features/promos/domain/entities/promo_entity.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/pages/promo_form_screen.dart';

/// المفتاح العام للتنقل في GoRouter
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

/// تكوين GoRouter المركزي للتطبيق مع حماية المسارات (Auth Guards)
final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppRoutes.dashboard,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: AppRoutes.initial,
      redirect: (context, state) => AppRoutes.dashboard,
    ),
    GoRoute(
      path: AppRoutes.dashboard,
      name: 'dashboard',
      builder: (context, state) => const MainNavigationScreen(),
    ),
    ...AuthRoutes.routes,
    ...BrandsRoutes.routes,
    GoRoute(
      path: AppRoutes.productForm,
      name: 'productForm',
      builder: (context, state) {
        final product = state.extra as ProductEntity?;
        return ProductFormPage(product: product);
      },
    ),
    ...CategoriesRoutes.routes,
    GoRoute(
      path: AppRoutes.promoForm,
      name: 'promoForm',
      builder: (context, state) {
        final promo = state.extra as PromoEntity?;
        return PromoFormScreen(promo: promo);
      },
    ),
    GoRoute(
      path: AppRoutes.orderDetails,
      name: 'orderDetails',
      builder: (context, state) {
        final order = state.extra as OrderEntity?;
        if (order == null) {
          return const MainNavigationScreen();
        }
        return OrderDetailsScreen(order: order);
      },
    ),
  ],
  redirect: (BuildContext context, GoRouterState state) {
    final isLoggedIn = AuthService.instance.isLoggedIn();
    final location = state.matchedLocation;
    final isAuthPath =
        location == AppRoutes.login || location == AppRoutes.signup;

    // توجيه المستخدم غير المسجل إلى صفحة تسجيل الدخول
    if (!isLoggedIn && !isAuthPath) {
      return AppRoutes.login;
    }

    // منع المستخدم المسجل من الوصول لصفحة الدخول أو التسجيل
    if (isLoggedIn && isAuthPath) {
      return AppRoutes.dashboard;
    }

    return null;
  },
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('خطأ في المسار')),
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline_rounded, size: 64, color: Colors.redAccent),
          const SizedBox(height: 16),
          Text(
            'الصفحة المطلوبة غير موجودة:\n${state.uri.toString()}',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.go(AppRoutes.dashboard),
            child: const Text('العودة للوحة التحكم'),
          ),
        ],
      ),
    ),
  ),
);

/// موفر Riverpod لـ GoRouter
final routerProvider = Provider<GoRouter>((ref) {
  return appRouter;
});
