
import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';

Widget buildProductFormSheetModernTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool isNumber = false,
    int maxLines = 1,
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
            cursorColor: AppColors.primary,
            style: TextStyle(
              color: isDark ? Colors.white : AppColors.textDark,
              fontSize: responsive.getBodyFontSize(),
            ),
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            maxLines: maxLines,
            decoration: InputDecoration(
              labelText: label,
              prefixIcon: Icon(
                icon,
                color: AppColors.primary.withValues(alpha: 0.7),
                size: responsive.iconSize,
              ),
              filled: true,
              fillColor: Colors.transparent,
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
              contentPadding: EdgeInsets.symmetric(
                horizontal: responsive.defaultPadding.left / 1.5,
                vertical: responsive.defaultPadding.top / 1.5,
              ),
            ),
          ),
        );
      }
    );
  }
