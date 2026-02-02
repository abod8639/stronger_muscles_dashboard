import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/controllers/orders_controller.dart';


Widget buildEmptyState(OrdersController controller) {
  final bool isFiltering = controller.searchQuery.value.isNotEmpty ||
      controller.selectedStatusId.value != 'all';

  return Center(
    child: AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: 1.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isFiltering ? Icons.search_off_rounded : Icons.shopping_cart_outlined,
              size: 80,
              color: AppColors.primary.withOpacity(0.2),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            isFiltering ? 'لا توجد نتائج تطابق بحثك' : 'قائمة الطلبات فارغة',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isFiltering
                ? 'جرب البحث بكلمات أخرى أو تغيير الفلتر'
                : 'ستظهر الطلبات الجديدة هنا بمجرد وصولها',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 14,
            ),
          ),
          if (isFiltering) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                controller.selectedStatusId.value = 'all';
                controller.onSearchChanged('');
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('إعادة ضبط الفلاتر'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary.withOpacity(0.1),
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: AppColors.primary.withOpacity(0.3)),
                ),
              ),
            ),
          ],
        ],
      ),
    ),
  );
}
