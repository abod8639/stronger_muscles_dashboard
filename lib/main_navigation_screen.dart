import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/build_background.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/drawer.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/my_bottomnavigationbar.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/sidebar.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/pages/promos_screen.dart';
import 'package:stronger_muscles_dashboard/features/categories/presentation/page/categories_screen/categories_screen.dart';
import 'package:stronger_muscles_dashboard/features/navigation/presentation/controllers/navigation_controller.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/pages/orders_page.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/pages/products_screen.dart';
import 'package:stronger_muscles_dashboard/features/settings/presentation/page/settings_screen.dart';
import 'package:stronger_muscles_dashboard/features/users/presentation/pages/users_page.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/presentation/pages/dashboard_page.dart';

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NavigationController>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 900;

        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: AppColors.backgroundDark,
          drawer: isDesktop ? null : myDrawer(),
          body: Stack(
            children: [
              buildBackground(),

              // Main Layout
              Row(
                children: [
                  if (isDesktop) const Sidebar(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        bottom: 20,
                        right: 10,
                        left: 10,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: Obx(
                          () => IndexedStack(
                            index: controller.selectedIndex.value,
                            children: const [
                              DashboardPage(),
                              CategoriesScreen(),
                              ProductsScreen(),
                              PromosScreen(),
                              OrdersPage(),

                              UsersPage(),
                              SettingsScreen(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          bottomNavigationBar: isDesktop ? null : MyBottomNavigationBar(),
        );
      },
    );
  }
}
