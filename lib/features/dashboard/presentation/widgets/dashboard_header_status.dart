import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/presentation/controllers/dashboard_controller.dart';

class DashboardHeaderStatus extends GetView<DashboardController> {
  const DashboardHeaderStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'لوحة التحكم',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => ConnectionStatusWidget(
          isConnected: controller.isConnected.value,
          lastUpdated: DateTime.now(), // Fixed time for simple display
        )),
      ],
    );
  }
}

class ConnectionStatusWidget extends StatelessWidget {
  final bool isConnected;
  final DateTime lastUpdated;

  const ConnectionStatusWidget({
    super.key,
    required this.isConnected,
    required this.lastUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isConnected ? Colors.green : Colors.red,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          isConnected ? 'متصل بالخادم' : 'غير متصل',
          style: TextStyle(
            color: isConnected ? Colors.green.withValues(alpha: 0.8) : Colors.red.withValues(alpha: 0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
