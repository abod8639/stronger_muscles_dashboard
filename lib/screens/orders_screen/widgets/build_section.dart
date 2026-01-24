  import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget buildSection({required Widget child, EdgeInsets? padding}) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? Colors.white.withOpacity(0.05) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Get.isDarkMode ? Colors.white10 : Colors.grey.shade200),
      ),
      child: child,
    );
  }