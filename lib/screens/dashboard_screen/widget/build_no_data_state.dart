
  import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/screens/dashboard_screen/widget/no_data_screen.dart';

Widget buildNoDataState(ResponsiveLayout res) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: res.defaultPadding.left),
    child: const NoDataScreen(
      title: 'لا توجد بيانات',
      message: 'لم نتمكن من جلب أي بيانات حالياً.',
    ),
  );
}

