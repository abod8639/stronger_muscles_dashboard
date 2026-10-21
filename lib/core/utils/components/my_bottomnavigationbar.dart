import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/features/navigation/presentation/controllers/navigation_controller.dart';

class MyBottomNavigationBar extends StatelessWidget {
  const MyBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NavigationController>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Obx(() {
      final selectedScreen = controller.selectedIndex.value;

      // تكييف التحديد في الشريط السفلي:
      // 0: الرئيسية (0)
      // 1: الطلبات (4)
      // 2: المنتجات (2)
      // 3: الإشعارات (6)
      // 4: المزيد (باقي الشاشات: 1، 3، 5، 7، 8)
      int barIndex;
      switch (selectedScreen) {
        case 0:
          barIndex = 0;
          break;
        case 4:
          barIndex = 1;
          break;
        case 2:
          barIndex = 2;
          break;
        case 6:
          barIndex = 3;
          break;
        default:
          barIndex = 4;
      }

      return Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.4)
                  : Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: barIndex,
          elevation: 3,
          height: 68,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          onDestinationSelected: (index) {
            switch (index) {
              case 0:
                controller.changeIndex(0); // الرئيسية
                break;
              case 1:
                controller.changeIndex(4); // الطلبات
                break;
              case 2:
                controller.changeIndex(2); // المنتجات
                break;
              case 3:
                controller.changeIndex(6); // الإشعارات
                break;
              case 4:
                controller.openDrawer(); // فتح القائمة الجانبية (المزيد)
                break;
            }
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard_rounded),
              label: 'الرئيسية',
            ),
            NavigationDestination(
              icon: Icon(Icons.local_shipping_outlined),
              selectedIcon: Icon(Icons.local_shipping_rounded),
              label: 'الطلبات',
            ),
            NavigationDestination(
              icon: Icon(Icons.inventory_2_outlined),
              selectedIcon: Icon(Icons.inventory_2_rounded),
              label: 'المنتجات',
            ),
            NavigationDestination(
              icon: Icon(Icons.notifications_outlined),
              selectedIcon: Icon(Icons.notifications_rounded),
              label: 'الإشعارات',
            ),
            NavigationDestination(
              icon: Icon(Icons.menu_rounded),
              selectedIcon: Icon(Icons.menu_open_rounded),
              label: 'المزيد',
            ),
          ],
        ),
      );
    });
  }
}

