import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/components/enhanced_error_widget.dart';
import 'package:stronger_muscles_dashboard/controllers/products_controller.dart';

Widget buildEmptyState(ProductsController controller) {
  return EnhancedErrorWidget(
    title: 'لا توجد نتائج',
    message:
        controller.searchQuery.value.isEmpty &&
            controller.selectedCategoryId.value == 'all'
        ? 'قائمة المنتجات فارغة حالياً'
        : 'لم نجد أي منتج يطابق بحثك: "${controller.searchQuery.value}"',
    icon: Icons.search_off_rounded,
    onRetry: () => controller.fetchData(),
  );
}
