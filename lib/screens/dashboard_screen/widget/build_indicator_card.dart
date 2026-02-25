import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/screens/components/premium_indicator_card.dart';
import 'package:stronger_muscles_dashboard/config/app_colors.dart';
import 'package:stronger_muscles_dashboard/controllers/dashboard_controller.dart';
import 'package:stronger_muscles_dashboard/models/indicators_model.dart';
import 'package:stronger_muscles_dashboard/screens/dashboard_screen/dashboard_screen.dart';

Widget buildIndicatorCard(int index) {
  final controller = Get.find<DashboardController>();
  final List<IndicatorsModel> indicators = [
    IndicatorsModel(
      title: 'معلقة',
      subtitle: 'Pending Orders',
      value: controller.pendingOrders.value.toString(),
      color: AppColorsExtended.purpleDark,
      icon: Icons.hourglass_empty,
      trend: '${5 + index * 4}%',
      isUp: true,
      chartColor: AppColorsExtended.orangeAccent,
      chartSpots: generateChartSpots(
        5,
        controller.processingOrders.value.toDouble() * 40,
      ),

    ),
  //     final pendingOrders = 0.obs;
  // final processingOrders = 0.obs;
  // final shippedOrders = 0.obs;
  // final deliveredOrders = 0.obs;
  // final cancelledOrders = 0.obs;
    // IndicatorsModel(
    //   title: 'معالجة',
    //   subtitle: 'Processing Orders',
    //   value: controller.processingOrders.value.toString(),
    //   color: AppColorsExtended.purpleDark,
    //   icon: Icons.hourglass_bottom,
    //   trend: '${3 + index * 1}%',
    //   isUp: true,
    //   chartColor: AppColorsExtended.orangeDark,
    // ),
    // IndicatorsModel(
    //   title: 'مرسلة',
    //   subtitle: 'Shipped Orders',
    //   value: controller.shippedOrders.value.toString(),
    //   color: AppColorsExtended.purpleDark,
    //   icon: Icons.local_shipping,
    //   trend: '${8 + index}%',
    //   isUp: true,
    //   chartColor: AppColorsExtended.purpleDark,
    // ),
    IndicatorsModel(
      title: ' المسلمة',
      subtitle: 'Delivered Orders',
      value: controller.deliveredOrders.value.toString(),
      color: AppColorsExtended.purpleDark,
      icon: Icons.check_circle,
      trend: '${2 + index }%',
      isUp: true,
      chartColor: AppColorsExtended.greenAccent,
      chartSpots: generateChartSpots(
        20,
        controller.deliveredOrders.value.toDouble() + 10,
      ),
    ),
    IndicatorsModel(
      title: 'ملغاة',
      subtitle: 'Cancelled Orders',
      value: controller.cancelledOrders.value.toString(),
      color: AppColorsExtended.purpleDark,
      icon: Icons.cancel,
      trend: '$index%',
      isUp: false,
      chartColor: AppColorsExtended.redAccent,
      chartSpots: generateChartSpots(
        20,
        controller.cancelledOrders.value.toDouble() + 10,
      ),
    ),
    // IndicatorsModel(
    //   title: 'إجمالي',
    //   subtitle: 'Total Orders',
    //   value: controller.orders.length.toString(),
    //   color: AppColorsExtended.purpleDark,
    //   icon: Icons.dashboard,
    //   trend: '${15 + index * 3}%',
    //   isUp: true,
    //   chartColor: AppColorsExtended.cyanAccent,
    // ),
  ];

  if (index >= indicators.length) return const SizedBox();

  final indicator = indicators[index];
  return PremiumIndicatorCard(
    title: indicator.title,
    subtitle: indicator.subtitle,
    value: indicator.value,
    icon: indicator.icon,
    accentColor: indicator.color,
    trend: indicator.trend,
    trendUp: indicator.isUp,
    chartSpots: indicator.chartSpots,
    chartColor: indicator.chartColor,
  );
}
