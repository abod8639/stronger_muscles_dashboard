import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/components/glass_container.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/controllers/products_controller.dart';

Widget buildSearchBar(
  BuildContext context,
  ProductsController controller,
  dynamic responsive,
) {
  return Padding(
    padding: responsive.defaultPadding,
    child: GlassContainer(
      opacity: 0.05,
      blur: 15,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.white.withOpacity(0.1)),
      child: TextField(
        onChanged: controller.onSearchChanged,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: 'البحث عن منتج بالاسم أو الماركة...',
          hintStyle: TextStyle(color: AppColors.textMuted.withOpacity(0.5)),
          prefixIcon: Icon(Icons.search_rounded, color: AppColors.primary.withOpacity(0.7)),
          suffixIcon: Obx(
            () => controller.searchQuery.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.close_rounded, size: 20, color: AppColors.error.withOpacity(0.7)),
                    onPressed: () => controller.onSearchChanged(''),
                  )
                : const SizedBox.shrink(),
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: AppColors.primary.withOpacity(0.5), width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        ),
      ),
    ),
  );
}

