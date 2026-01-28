import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/controllers/navigation_controller.dart';

Widget buildNavItem(
  bool isDrawer,
  NavigationController controller,
  int index,
  IconData icon,
  IconData activeIcon,
  String label,
) {
  return Builder(
    builder: (context) {
      return Obx(() {
        final isSelected = controller.selectedIndex.value == index;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: InkWell(
            onTap: () {
              controller.changeIndex(index);
              if (isDrawer) Get.back();
            },
            borderRadius: BorderRadius.circular(12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                border: isSelected
                    ? Border.all(
                        color: AppColors.primary.withOpacity(0.5),
                        width: 1,
                      )
                    : null,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.2),
                          blurRadius: 12,
                          spreadRadius: -2,
                        ),
                      ]
                    : [],
              ),
              child: Row(
                children: [
                  Icon(
                    isSelected ? activeIcon : icon,
                    color: isSelected ? AppColors.primary : Colors.white54,
                    size: 20,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    label,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white54,
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
    },
  );
}
