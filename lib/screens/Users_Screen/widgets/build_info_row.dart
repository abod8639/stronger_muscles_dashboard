
import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';

Widget buildInfoRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: TextStyle(fontWeight: FontWeight.w500, color: isDark ? Colors.white : AppColors.textMuted)),
        ],
      ),
    );
  }

