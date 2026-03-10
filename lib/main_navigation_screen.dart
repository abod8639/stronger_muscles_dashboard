import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/features/categories/page/categories_screen/categories_screen.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/presentation/page/dashboard_screen.dart';
import 'package:stronger_muscles_dashboard/features/navigation/presentation/controllers/navigation_controller.dart';
import 'package:stronger_muscles_dashboard/features/orders/presentation/pages/orders_screen/orders_screen.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/pages/products_screen.dart';
import 'package:stronger_muscles_dashboard/features/users/presentation/page/users_screen.dart';
import 'package:stronger_muscles_dashboard/screens/add_screen/add_screen.dart';
import 'package:stronger_muscles_dashboard/screens/categories_screen/categories_screen.dart';
import 'package:stronger_muscles_dashboard/screens/components/build_background.dart';
import 'package:stronger_muscles_dashboard/screens/components/drawer.dart';
import 'package:stronger_muscles_dashboard/screens/components/my_bottomnavigationbar.dart';
import 'package:stronger_muscles_dashboard/screens/components/sidebar.dart';
import 'package:stronger_muscles_dashboard/screens/dashboard_screen/dashboard_screen.dart';
import 'package:stronger_muscles_dashboard/screens/orders_screen/orders_screen.dart';
import 'package:stronger_muscles_dashboard/screens/products_screen/products_screen.dart';
import 'package:stronger_muscles_dashboard/screens/settings_screen/settings_screen.dart';
import 'package:stronger_muscles_dashboard/screens/users_screen/users_screen.dart';

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
                              DashboardScreen(),
                              CategoriesScreen(),
                              ProductsScreen(),
                              AddScreen(),
                              OrdersScreen(),
                              UsersScreen(),
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
