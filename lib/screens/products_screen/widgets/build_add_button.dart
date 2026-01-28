import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/controllers/products_controller.dart';
import 'package:stronger_muscles_dashboard/screens/products_screen/widgets/ProductFormPage.dart';

Widget buildAddButton(
  BuildContext context,
  ProductsController controller,
  var responsive,
) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withOpacity(0.2),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: IconButton(
      onPressed: () =>
          Get.to(ProductFormPage()), //controller.showProductForm(context),
      icon: Icon(
        Icons.add_circle,
        size: responsive.iconSize + 4,
        color: AppColors.primary,
      ),
      tooltip: 'إضافة منتج جديد',
    ),
  );
}
