import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/controllers/dashboard_controller.dart';
import 'package:stronger_muscles_dashboard/screens/dashboard_screen/widget/error_screen.dart';

Widget buildErrorState() {
  final controller = Get.find<DashboardController>();

  return ErrorScreen(
    title: 'فشل الاتصال',
    message: controller.errorMessage.value,
    onRetry: () => controller.retryConnection(),
    icon: Icons.cloud_off_outlined,
  );
}
