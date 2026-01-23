
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stronger_muscles_dashboard/controllers/orders_controller.dart';

Widget buildEmptyState(OrdersController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text(
            controller.searchQuery.value.isEmpty && controller.selectedStatus.value == null
                ? 'لا توجد طلبات حالياً'
                : 'لا توجد نتائج تطابق بحثك',
            style: const TextStyle(color: Colors.grey, fontSize: 16),
          ),
          if (controller.searchQuery.value.isNotEmpty || controller.selectedStatus.value != null)
            TextButton(
              onPressed: () {
                controller.setSearchQuery('');
                controller.setFilterStatus(null);
              },
              child: const Text('مسح الفلاتر'),
            ),
        ],
      ),
    );
  }

