
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/controllers/products_controller.dart';

class AvailabilitySwitch extends StatelessWidget {
  const AvailabilitySwitch({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductsController>();
    final responsive = context.responsive;
    return Obx(
      () => SwitchListTile(
        value: controller.isFeatured.value,
        onChanged: (value) {
          controller.isFeatured.value = value;
        },
        title: Text(
          "هل المنتج متاح",
          style: TextStyle(
            fontSize: responsive.getTitleFontSize() + 2,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
