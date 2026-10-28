import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:stronger_muscles_dashboard/core/network/auth_service.dart';
import 'package:stronger_muscles_dashboard/core/router/app_routes.dart';
import 'package:stronger_muscles_dashboard/features/auth/auth_feature.dart';
import 'package:stronger_muscles_dashboard/features/brands/brands_feature.dart';
import 'package:stronger_muscles_dashboard/features/categories/categories_feature.dart';
import 'package:stronger_muscles_dashboard/features/navigation/navigation_feature.dart';
import 'package:stronger_muscles_dashboard/features/notifications/notifications_feature.dart';
import 'package:stronger_muscles_dashboard/features/orders/orders_feature.dart';
import 'package:stronger_muscles_dashboard/features/products/products_feature.dart';
import 'package:stronger_muscles_dashboard/features/promos/promos_feature.dart';
import 'package:stronger_muscles_dashboard/features/settings/settings_feature.dart';
import 'package:stronger_muscles_dashboard/features/theme/theme_feature.dart';
import 'package:stronger_muscles_dashboard/features/support/support_feature.dart';
import 'package:stronger_muscles_dashboard/features/users/users_feature.dart';

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
    ...NotificationsRoutes.routes,
    ...ProductsRoutes.routes,
    ...CategoriesRoutes.routes,
    ...PromosRoutes.routes,
    ...OrdersRoutes.routes,
    ...SettingsRoutes.routes,
    ...ThemeRoutes.routes,
    ...SupportRoutes.routes,
    ...UsersRoutes.routes,
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
