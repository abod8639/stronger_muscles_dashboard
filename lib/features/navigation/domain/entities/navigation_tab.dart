import 'package:flutter/material.dart';

enum NavigationTab {
  dashboard(0, 'Dashboard', 'الرئيسية', Icons.dashboard_outlined, Icons.dashboard_rounded),
  categories(1, 'Categories', 'التصنيفات', Icons.category_outlined, Icons.category_rounded),
  products(2, 'Products', 'المنتجات', Icons.inventory_2_outlined, Icons.inventory_2_rounded),
  promos(3, 'Ads & Promos', 'العروض والإعلانات', Icons.add_business_outlined, Icons.add_business_rounded),
  orders(4, 'Orders', 'الطلبات', Icons.local_shipping_outlined, Icons.local_shipping_rounded),
  users(5, 'Users', 'المستخدمين', Icons.people_outline, Icons.people_rounded),
  notifications(6, 'Notifications', 'الإشعارات', Icons.notifications_outlined, Icons.notifications_rounded),
  settings(7, 'Settings', 'الإعدادات', Icons.settings_outlined, Icons.settings_rounded),
  support(8, 'Support & Tickets', 'الدعم الفني', Icons.support_agent_outlined, Icons.support_agent_rounded);

  final int tabIndex;
  final String titleEn;
  final String titleAr;
  final IconData icon;
  final IconData activeIcon;

  const NavigationTab(
    this.tabIndex,
    this.titleEn,
    this.titleAr,
    this.icon,
    this.activeIcon,
  );

  static NavigationTab fromIndex(int index) {
    return NavigationTab.values.firstWhere(
      (tab) => tab.tabIndex == index,
      orElse: () => NavigationTab.dashboard,
    );
  }
}
