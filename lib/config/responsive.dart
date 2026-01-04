import 'package:flutter/material.dart';

/// فئة للتعامل مع التصميم المتجاوب
class ResponsiveLayout {
  final BuildContext context;

  ResponsiveLayout(this.context);

  // الحصول على عرض الشاشة
  double get screenWidth => MediaQuery.of(context).size.width;

  // الحصول على ارتفاع الشاشة
  double get screenHeight => MediaQuery.of(context).size.height;

  // التحقق من نوع الجهاز
  bool get isMobile => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 1200;
  bool get isDesktop => screenWidth >= 1200;

  // نوع الجهاز الكامل
  DeviceType get deviceType {
    if (isMobile) return DeviceType.mobile;
    if (isTablet) return DeviceType.tablet;
    return DeviceType.desktop;
  }

  // الحصول على عدد الأعمدة المناسب للشاشة
  int getGridColumns() {
    if (isMobile) return 2;
    if (isTablet) return 3;
    return 4;
  }

  // الحصول على الحشو (Padding) المناسب
  EdgeInsets get defaultPadding {
    if (isMobile) return const EdgeInsets.all(12);
    if (isTablet) return const EdgeInsets.all(16);
    return const EdgeInsets.all(24);
  }

  // الحصول على المسافة بين العناصر
  double get itemSpacing {
    if (isMobile) return 8;
    if (isTablet) return 12;
    return 16;
  }

  // الحصول على حجم الخط المناسب
  double getTitleFontSize() {
    if (isMobile) return 16;
    if (isTablet) return 18;
    return 20;
  }

  double getBodyFontSize() {
    if (isMobile) return 13;
    if (isTablet) return 14;
    return 15;
  }

  // الحصول على ارتفاع الكارد المناسب
  double getCardAspectRatio() {
    if (isMobile) return 1.0;
    if (isTablet) return 1.15;
    return 1.2;
  }

  // الحصول على عرض الكارد الأقصى
  double get maxCardWidth {
    if (isMobile) return double.infinity;
    if (isTablet) return 500;
    return 600;
  }

  // الحصول على عدد الأعمدة للإحصائيات
  int getStatsColumns() {
    if (isMobile) return 2;
    if (isTablet) return 4;
    return 4;
  }

  // الحصول على عدد الأعمدة للطلبات
  int getOrdersColumns() {
    if (isMobile) return 1;
    if (isTablet) return 2;
    return 3;
  }

  // الحصول على ارتفاع AppBar المناسب
  double get appBarHeight {
    if (isMobile) return 56;
    if (isTablet) return 64;
    return 72;
  }

  // الحصول على حجم الأيقونة المناسب
  double get iconSize {
    if (isMobile) return 20;
    if (isTablet) return 24;
    return 28;
  }

  // الحصول على حجم الأيقونة الكبيرة
  double get largeIconSize {
    if (isMobile) return 32;
    if (isTablet) return 40;
    return 48;
  }
}

enum DeviceType { mobile, tablet, desktop }

/// مساعد للحصول على خصائص الجهاز بسهولة
extension ResponsiveContext on BuildContext {
  ResponsiveLayout get responsive => ResponsiveLayout(this);

  bool get isMobile => responsive.isMobile;
  bool get isTablet => responsive.isTablet;
  bool get isDesktop => responsive.isDesktop;
  DeviceType get deviceType => responsive.deviceType;
}
