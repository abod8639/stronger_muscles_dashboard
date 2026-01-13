import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/screens/widgets/drawer.dart';
import 'package:stronger_muscles_dashboard/screens/widgets/sidebar.dart';
import 'config/theme.dart';
import 'screens/index.dart';

void main() {
  runApp(const StrongerMusclesDashboard());
}

class StrongerMusclesDashboard extends StatelessWidget {
  const StrongerMusclesDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'لوحة تحكم Stronger Muscles',
      theme: AppTheme.getLightTheme(),
      darkTheme: AppTheme.getDarkTheme(),
      themeMode: ThemeMode.dark,
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize NavigationController
    final controller = Get.put(NavigationController());

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 900;

        return Scaffold(
          backgroundColor: const Color(0xFF0F0F12), // Match sidebar background
          drawer: isDesktop ? null : myDrawer(),
          body: Row(
            children: [
              if (isDesktop) const Sidebar(),
              Expanded(
                child: Padding(
                  padding: isDesktop 
                      ? const EdgeInsets.only(top: 20, right: 20, bottom: 20) 
                      : EdgeInsets.zero,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDesktop 
                          ? (Theme.of(context).brightness == Brightness.dark 
                              ? const Color(0xFF1E1E26) 
                              : Colors.white)
                          : Colors.transparent,
                      borderRadius: isDesktop ? BorderRadius.circular(32) : null,
                    ),
                    child: ClipRRect(
                      borderRadius: isDesktop ? BorderRadius.circular(32) : BorderRadius.zero,
                      child: Obx(() => IndexedStack(
                        index: controller.selectedIndex.value,
                        children: const [
                          DashboardScreen(),
                          CategoriesScreen(),
                          ProductsScreen(),
                          OrdersScreen(),
                          UsersScreen(),
                          SettingsScreen(),
                        ],
                      )),
                    ),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: isDesktop ? null : Obx(() => BottomNavigationBar(
            currentIndex: controller.selectedIndex.value,
            type: BottomNavigationBarType.fixed,
            onTap: controller.changeIndex,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_outlined),
                activeIcon: Icon(Icons.dashboard),
                label: 'الرئيسية',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.category_outlined),
                activeIcon: Icon(Icons.category),
                label: 'الأقسام',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.inventory_2_outlined),
                activeIcon: Icon(Icons.inventory_2),
                label: 'المنتجات',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag_outlined),
                activeIcon: Icon(Icons.shopping_bag),
                label: 'الطلبات',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people_outline),
                activeIcon: Icon(Icons.people),
                label: 'المستخدمون',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                activeIcon: Icon(Icons.settings),
                label: 'الإعدادات',
              ),
            ],
          )),
        );
      },
    );
  }
}
