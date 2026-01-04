
  import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/controllers/dashboard_controller.dart';
import 'package:stronger_muscles_dashboard/screens/Dashboard_Screen/dashboard_screen.dart';

Widget buildDashboardScreenPeriodSelector( ) {
  final controller = Get.put(DashboardController());

    return Builder(
      builder: (context) {
    final responsive = context.responsive;
    final spacing = responsive.itemSpacing;
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.defaultPadding.left,
            vertical: responsive.defaultPadding.top / 2,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                PeriodButton(
                  label: 'هذا الأسبوع',
                  value: 'week',
                  isSelected: controller.selectedPeriod.value == 'week',
                  onTap: () => controller.changePeriod('week'),
                ),
                SizedBox(width: spacing),
                PeriodButton(
                  label: 'هذا الشهر',
                  value: 'month',
                  isSelected: controller.selectedPeriod.value == 'month',
                  onTap: () => controller.changePeriod('month'),
                ),
                SizedBox(width: spacing),
                PeriodButton(
                  label: 'هذا العام',
                  value: 'year',
                  isSelected: controller.selectedPeriod.value == 'year',
                  onTap: () => controller.changePeriod('year'),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
