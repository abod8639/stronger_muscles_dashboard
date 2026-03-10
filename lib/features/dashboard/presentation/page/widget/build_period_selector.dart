import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/controllers/dashboard_controller.dart';
import 'package:stronger_muscles_dashboard/screens/components/horizontal_chips_selector.dart';

Widget buildPeriodSelector(ResponsiveLayout res) {
  final controller = Get.find<DashboardController>();

  return Obx(
    () => HorizontalChipsSelector(
      items: controller.periodItems,
      selectedId: controller.selectPeriod.value,
      onSelect: (id) => controller.selectPeriod.value = id,
      labelKey: 'name',
      idKey: 'id',
      showAllOption: false,
      allLabel: 'الكل',
    ),
  );
}
