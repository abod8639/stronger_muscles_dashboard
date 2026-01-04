
  import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/controllers/dashboard_controller.dart';

PreferredSizeWidget buildDashboardScreenAppBar(BuildContext context, bool isDark) {
    final controller = Get.put(DashboardController());

    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Text(
        'لوحة التحكم',
        style: TextStyle(
          color: isDark ? Colors.white : AppColors.textDark,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 16),
          child: Obx(
            () => Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: (controller.isConnected.value ? AppColors.success : AppColors.danger).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: controller.isConnected.value ? AppColors.success : AppColors.danger,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      controller.isConnected.value ? 'متصل' : 'غير متصل',
                      style: TextStyle(
                        color: controller.isConnected.value ? AppColors.success : AppColors.danger,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

