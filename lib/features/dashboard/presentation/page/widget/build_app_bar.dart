import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/app_colors.dart';
import 'package:stronger_muscles_dashboard/controllers/dashboard_controller.dart';

PreferredSizeWidget buildAppBar() {
  final controller = Get.find<DashboardController>();
  return AppBar(
    title: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColorsExtended.purpleAccent,
                AppColorsExtended.cyanAccent,
              ],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.dashboard, size: 20),
        ),
        const SizedBox(width: 12),
        const Text(
          'لوحة التحكم',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
        ),
      ],
    ),
    backgroundColor: AppColorsExtended.cardBg,
    elevation: 0,
    centerTitle: false,
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColorsExtended.surfaceDark,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColorsExtended.borderColor,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.refresh,
                  color: AppColorsExtended.cyanAccent,
                  size: 18,
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => controller.fetchDashboardData(),
                  child: Text(
                    'تحديث',
                    style: TextStyle(
                      color: AppColorsExtended.cyanAccent,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}
