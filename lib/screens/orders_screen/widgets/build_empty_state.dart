import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/controllers/orders_controller.dart';

Widget buildEmptyState(OrdersController controller) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.shopping_bag_outlined,
          size: 80,
          color: Colors.grey.withOpacity(0.3),
        ),
        const SizedBox(height: 16),
        Text(
          controller.searchQuery.value.isEmpty &&
                  controller.selectedStatusId.value == 'all'
              ? 'لا توجد طلبات حالياً'
              : 'لا توجد نتائج تطابق بحثك',
          style: const TextStyle(color: Colors.grey, fontSize: 16),
        ),
        if (controller.searchQuery.value.isNotEmpty ||
            controller.selectedStatusId.value != 'all')
          TextButton(
            onPressed: () {
              controller.selectedStatusId.value = 'all';
              controller.searchQuery.value = '';
            },
            child: const Text('مسح الفلاتر'),
          ),
      ],
    ),
  );
}
