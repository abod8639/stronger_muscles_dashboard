import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  final selectedIndex = 0.obs;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  void closeDrawer() {
    scaffoldKey.currentState?.closeDrawer();
  }
}

