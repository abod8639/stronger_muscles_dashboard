
import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';

Widget buildCategoryFormSheetModernTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool enabled = true,
  }) {

    return Builder(
      builder: (context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final responsive = context.responsive;
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.08),
                blurRadius: 12,
                spreadRadius: 1,
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            enabled: enabled,
            cursorColor: AppColors.primary,
            style: TextStyle(
              color: isDark ? Colors.white : AppColors.textDark,
              fontSize: responsive.getBodyFontSize(),
            ),
            decoration: InputDecoration(
              labelText: label,
              prefixIcon: Icon(
                icon,
                color: AppColors.primary.withValues(alpha: 0.7),
                size: responsive.iconSize,
              ),
              filled: true,
              fillColor: !enabled ? (isDark ? Colors.white10 : Colors.grey.shade100) : Colors.transparent,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              labelStyle: TextStyle(
                color: isDark ? Colors.white70 : AppColors.primary.withValues(alpha: 0.6),
                fontSize: responsive.getBodyFontSize(),
              ),
            ),
          ),
        );
      }
    );
  }
