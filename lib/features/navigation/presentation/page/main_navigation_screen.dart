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
import 'package:stronger_muscles_dashboard/features/notifications/notifications_feature.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/pages/orders_page.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/pages/products_screen.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/pages/promos_screen.dart';
import 'package:stronger_muscles_dashboard/features/settings/presentation/page/settings_screen.dart';
import 'package:stronger_muscles_dashboard/features/support/presentation/pages/support_screen.dart';
import 'package:stronger_muscles_dashboard/features/users/presentation/pages/users_page.dart';

/// Dumb presentation root container for app-wide shell navigation.
/// Adheres to:
/// - Zero business or data calculation logic inside UI
/// - Safe tab clamping to prevent index-out-of-bounds crashes
/// - Selective state listening via Riverpod
class MainNavigationScreen extends ConsumerStatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  ConsumerState<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static const List<Widget> _pages = [
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

  Widget _buildContent(int activeIndex) {
    final safeIndex = activeIndex.clamp(0, _pages.length - 1);
    return IndexedStack(
      index: safeIndex,
      children: _pages,
    );
  }

  @override
  Widget build(BuildContext context) {
    final navAsync = ref.watch(navigationControllerProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return navAsync.when(
      loading: () => const Scaffold(
        body: EnhancedLoadingWidget(
          message: 'جاري تهيئة لوحة التحكم...',
        ),
      ),
      error: (error, stackTrace) => NavigationErrorFallback(
        error: error,
        onRetry: () => ref.invalidate(navigationControllerProvider),
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
              bottomNavigationBar:
                  isDesktop ? null : const MyBottomNavigationBar(),
            );
          },
        );
      },
    );
  }
}
