
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/controllers/products_controller.dart';

Widget buildSearchBar(
  BuildContext context,
  ProductsController controller,
  var responsive,
) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return Padding(
    padding: responsive.defaultPadding,
    child: Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade300,
        ),
      ),
      child: TextField(
        onChanged: controller.onSearchChanged,
        decoration: InputDecoration(
          hintText: 'البحث عن منتج بالاسم أو الماركة...',
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: Obx(
            () => controller.searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 20),
                    onPressed: () {
                      // تحتاج لإضافة دالة clearSearch في الكنترولر
                      controller.onSearchChanged('');
                    },
                  )
                : const SizedBox.shrink(),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    ),
  );
}

