import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:stronger_muscles_dashboard/screens/dashboard_screen/widget/connection_status.dart';

Widget buildHeaderStatus() {
  final controller = Get.find<DashboardController>();
  return ConnectionStatusBar(
    isConnected: controller.isConnected.value,
    errorMessage: controller.errorMessage.value,
    onRetry: () => controller.retryConnection(),
  );
}
