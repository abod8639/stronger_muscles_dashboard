/// 100% Pure Dart Domain Entity representing navigation tabs.
/// Strictly decoupled from Flutter UI framework and third-party SDKs.
enum NavigationTab {
  dashboard(0, 'Dashboard', 'الرئيسية'),
  categories(1, 'Categories', 'التصنيفات'),
  products(2, 'Products', 'المنتجات'),
  promos(3, 'Ads & Promos', 'العروض والإعلانات'),
  orders(4, 'Orders', 'الطلبات'),
  users(5, 'Users', 'المستخدمين'),
  notifications(6, 'Notifications', 'الإشعارات'),
  settings(7, 'Settings', 'الإعدادات'),
  support(8, 'Support & Tickets', 'الدعم الفني');

  final int tabIndex;
  final String titleEn;
  final String titleAr;

  const NavigationTab(this.tabIndex, this.titleEn, this.titleAr);

  String title(String langCode) => langCode == 'ar' ? titleAr : titleEn;

  static NavigationTab fromIndex(int index) {
    return NavigationTab.values.firstWhere(
      (tab) => tab.tabIndex == index,
      orElse: () => NavigationTab.dashboard,
    );
  }
}
