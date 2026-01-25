
import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/controllers/categories_controller.dart';

class Search_Bar extends StatelessWidget {
  const Search_Bar({
    super.key,
    required this.padding,
    required this.isDark,
    required this.controller,
    required this.responsive,
  });

  final EdgeInsets padding;
  final bool isDark;
  final CategoriesController controller;
  final ResponsiveLayout responsive;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: isDark ? 0.1 : 0.08),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: TextField(
          onChanged: controller.onSearchChanged,
          cursorColor: AppColors.primary,
          style: TextStyle(
            color: isDark ? Colors.white : AppColors.textMuted,
            fontSize: responsive.getBodyFontSize(),
          ),
          decoration: InputDecoration(
            hintText: 'ابحث عن تصنيف بالاسم أو الكود...',
            hintStyle: TextStyle(
              color: isDark ? Colors.white54 : Colors.grey.shade400,
              fontSize: responsive.getBodyFontSize(),
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: AppColors.primary.withValues(alpha: 0.7),
              size: responsive.iconSize,
            ),
            filled: true,
            fillColor: Colors.transparent,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: AppColors.primary.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: padding.left,
              vertical: padding.top / 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
