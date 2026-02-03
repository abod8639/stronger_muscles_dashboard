
// Reading file content
import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/controllers/orders_controller.dart';

Widget buildEmptyState(OrdersController controller) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.white.withOpacity(0.02),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.inbox_outlined,
              size: 80,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'لا توجد طلبات',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            controller.searchQuery.value.isNotEmpty
                ? 'لم يتم العثور على نتائج للبحث'
                : 'لا توجد طلبات حالياً',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
          if (controller.searchQuery.value.isNotEmpty) ...[
            const SizedBox(height: 24),
            TextButton.icon(
              onPressed: () => controller.onSearchChanged(''),
              icon: const Icon(Icons.clear_rounded),
              label: const Text('مسح البحث'),
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
          ],
        ],
      ),
    ),
  );
}
