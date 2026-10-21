import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  final selectedIndex = 0.obs;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  /// تغيير التبويب بأمان تام مع حصر المؤشر لتفادي RangeError
  void changeIndex(int index) {
    final safeIndex = index.clamp(0, 8);
    selectedIndex.value = safeIndex;
  }

  void openDrawer() {
    if (scaffoldKey.currentState != null && !scaffoldKey.currentState!.isDrawerOpen) {
      scaffoldKey.currentState?.openDrawer();
    }
  }

  void closeDrawer() {
    if (scaffoldKey.currentState != null && scaffoldKey.currentState!.isDrawerOpen) {
      scaffoldKey.currentState?.closeDrawer();
    }
  }

  bool get isDrawerOpen => scaffoldKey.currentState?.isDrawerOpen ?? false;
}
