
  import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/screens/dashboard_screen/dashboard_screen.dart';
import 'package:stronger_muscles_dashboard/screens/dashboard_screen/widget/build_recent_orders.dart';

Widget buildBottomSection(ResponsiveLayout res) {
  return Column(
    children: [
      buildRecentOrders(res),
      SizedBox(height: res.itemSpacing * 2),
      buildCategoriesSection(res),
    ],
  );
}

