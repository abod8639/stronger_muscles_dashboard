
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/controllers/orders_controller.dart';
import 'package:stronger_muscles_dashboard/models/order_model.dart';

Widget buildStatusTabs( OrdersController controller) {
    final statuses = [
      null, // All
      OrderStatus.pending,
      OrderStatus.processing,
      OrderStatus.shipped,
      OrderStatus.delivered,
      OrderStatus.cancelled,
    ];

    return Builder(
      builder: (context) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: context.responsive.defaultPadding.left),
          child: Obx(() => Row(
            children: statuses.map((status) {
              final isSelected = controller.selectedStatus.value == status;
              final label = status == null ? 'الكل' : controller.getStatusText(status);
              
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  label: Text(label),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) controller.setFilterStatus(status);
                  },
                  backgroundColor: Colors.transparent,
                  selectedColor: AppColors.primary.withOpacity(0.2),
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.primary : Colors.grey,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: isSelected ? AppColors.primary : Colors.grey.withOpacity(0.3),
                    ),
                  ),
                ),
              );
            }).toList(),
          )),
        );
      }
    );
  }
