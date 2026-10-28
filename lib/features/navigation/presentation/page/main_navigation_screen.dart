import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/build_background.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/drawer.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/enhanced_loading_widget.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/my_bottomnavigationbar.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/sidebar.dart';
import 'package:stronger_muscles_dashboard/features/categories/categories_feature.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/dashboard_feature.dart';
import 'package:stronger_muscles_dashboard/features/navigation/presentation/controllers/navigation_providers.dart';
import 'package:stronger_muscles_dashboard/features/navigation/presentation/widget/navigation_error_fallback.dart';
import 'package:stronger_muscles_dashboard/features/notifications/presentation/pages/notifications_screen.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/pages/orders_page.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/pages/products_screen.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/pages/promos_screen.dart';
import 'package:stronger_muscles_dashboard/features/settings/presentation/page/settings_screen.dart';
import 'package:stronger_muscles_dashboard/features/support/presentation/pages/support_screen.dart';
import 'package:stronger_muscles_dashboard/features/users/presentation/pages/users_page.dart';

class MainNavigationScreen extends ConsumerStatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  ConsumerState<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _buildContent(int activeIndex) {
    const pages = [
      DashboardPage(),
      CategoriesScreen(),
      ProductsScreen(),
      PromosScreen(),
      OrdersPage(),
      UsersPage(),
      NotificationsScreen(),
      SettingsScreen(),
      SupportScreen(),
    ];

    // حصر المؤشر دائماً ضمن نطاق القائمة لمنع أي انهيار للشاشة
    final safeIndex = activeIndex.clamp(0, pages.length - 1);

    return IndexedStack(
      index: safeIndex,
      children: pages,
    );
  }

  @override
  Widget build(BuildContext context) {
    final navAsync = ref.watch(navigationControllerProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return navAsync.when(
      loading: () => const Scaffold(  // final String ip = "localhost";

        body: EnhancedLoadingWidget(
          message: 'جاري تهيئة لوحة التحكم...',
        ),
      ),
      error: (error, stackTrace) => NavigationErrorFallback(
        error: error,
        onRetry: () => ref.read(navigationControllerProvider.notifier).build(),
      ),
      data: (navState) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 900;

            return Scaffold(
              key: _scaffoldKey,
              extendBodyBehindAppBar: isDesktop,
              backgroundColor: colorScheme.surface,
              drawer: isDesktop ? null : myDrawer(),
              body: Stack(
                children: [
                  const AppAmbientBackground(),

                  // التخطيط الرئيسي
                  SafeArea(
                    child: Row(
                      children: [
                        if (isDesktop) const Sidebar(),
                        Expanded(
                          child: isDesktop
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                    top: 10,
                                    bottom: 20,
                                    right: 10,
                                    left: 10,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(32),
                                    child: _buildContent(navState.selectedIndex),
                                  ),
                                )
                              : _buildContent(navState.selectedIndex),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: isDesktop ? null : const MyBottomNavigationBar(),
            );
          },
        );
      },
    );
  }
}
