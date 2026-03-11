import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/horizontal_chips_selector.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/presentation/controllers/dashboard_controller.dart';

class DashboardPeriodSelector extends GetView<DashboardController> {
  const DashboardPeriodSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => HorizontalChipsSelector(
        items: controller.periodItems,
        selectedId: controller.selectPeriod.value,
        onSelect: (id) => controller.updatePeriod(id),
        labelKey: 'name',
        idKey: 'id',
        showAllOption: false,
        allLabel: 'الكل',
      ),
    );
  }
}
