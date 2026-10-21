import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/build_background.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/drawer.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/enhanced_loading_widget.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/my_bottomnavigationbar.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/sidebar.dart';
import 'package:stronger_muscles_dashboard/features/categories/presentation/page/categories_screen/categories_screen.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:stronger_muscles_dashboard/features/navigation/presentation/controllers/main_navigation_binding.dart';
import 'package:stronger_muscles_dashboard/features/navigation/presentation/controllers/navigation_controller.dart';
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
  @override
  void initState() {
    super.initState();
    // ضمان تسجيل NavigationController والـ Bindings التابعة لجميع التبويبات
    if (!Get.isRegistered<NavigationController>()) {
      MainNavigationBinding().dependencies();
    }
  }

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
    final controller = Get.isRegistered<NavigationController>()
        ? Get.find<NavigationController>()
        : Get.put<NavigationController>(NavigationController(), permanent: true);

    return navAsync.when(
      loading: () => const Scaffold(
        body: EnhancedLoadingWidget(
          message: 'جاري تهيئة لوحة التحكم...',
        ),
      ),
      error: (error, stackTrace) => NavigationErrorFallback(
        error: error,
        onRetry: () => ref.read(navigationControllerProvider.notifier).build(),
      ),
      data: (navState) {
        // مزامنة المؤشر مع GetX لضمان تحديث الشريط السفلي والقائمة الجانبية
        if (controller.selectedIndex.value != navState.selectedIndex) {
          controller.selectedIndex.value = navState.selectedIndex;
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 900;

            return Scaffold(
              key: controller.scaffoldKey,
              extendBodyBehindAppBar: isDesktop,
              backgroundColor: colorScheme.surface,
              drawer: isDesktop ? null : myDrawer(),
              body: Stack(
                children: [
                  const AppAmbientBackground(),

                  // التخطيط الرئيسي
                  Row(
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
                                  child: Obx(
                                    () => _buildContent(controller.selectedIndex.value),
                                  ),
                                ),
                              )
                            : Obx(
                                () => _buildContent(controller.selectedIndex.value),
                              ),
                      ),
                    ],
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
