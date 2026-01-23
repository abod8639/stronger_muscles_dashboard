
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/controllers/orders_controller.dart';

Widget buildSearchBar( OrdersController controller) {
    
    return Builder(
      builder: (context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
        return Padding(
          padding: context.responsive.defaultPadding,
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade300),
            ),
            child: TextField(
              onChanged: controller.setSearchQuery,
              decoration: InputDecoration(
                hintText: 'البحث عن طلب برقم التعريف أو المبلغ...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: Obx(() => controller.searchQuery.isNotEmpty 
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      onPressed: () {
                        controller.setSearchQuery('');
                      },
                    ) 
                  : const SizedBox.shrink()),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
        );
      }
    );
  }
