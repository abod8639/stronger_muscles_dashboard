import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/screens/widgets/build_nav_item.dart';

class NavigationController extends GetxController {
  final selectedIndex = 0.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}

class Sidebar extends StatelessWidget {
  final bool isDrawer;
  const Sidebar({super.key, this.isDrawer = false});

  @override
  Widget build(BuildContext context) {
    final NavigationController controller = Get.find<NavigationController>();

    return Container(
      width: 250,
      height: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F12),
        borderRadius: isDrawer ? null : const BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 40),
          // Logo
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.shopping_cart, color: Colors.black, size: 24),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Stronger',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          // Navigation Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                buildNavItem( controller, 0, Icons.grid_view_outlined, Icons.grid_view_rounded, 'الرئيسية'),
                buildNavItem( controller, 2, Icons.inventory_2_outlined, Icons.inventory_2_rounded, 'المنتجات'),
                buildNavItem( controller, 4, Icons.people_outline, Icons.people_rounded, 'المستخدمون'),
                buildNavItem( controller, 1, Icons.category_outlined, Icons.category_rounded, 'الأقسام'),
                buildNavItem( controller, 3, Icons.shopping_bag_outlined, Icons.shopping_bag_rounded, 'الطلبات'),
                buildNavItem( controller, 5, Icons.settings_outlined, Icons.settings_rounded, 'الإعدادات'),
              ],
            ),
          ),
          // User Profile
          Padding(
            padding: const EdgeInsets.all(24),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=admin'),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Dexter',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Manager',
                          style: TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down, color: Colors.white.withOpacity(0.5)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}
 