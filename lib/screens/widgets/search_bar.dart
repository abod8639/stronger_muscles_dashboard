
import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/components/glass_container.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';

class Search_Bar extends StatelessWidget {
  const Search_Bar({
    super.key,
    required this.padding,
    required this.isDark,
    required this.controller,
    required this.responsive,
    required this.hintText,
  });

  final EdgeInsets padding;
  final bool isDark;
  final controller;
  final ResponsiveLayout responsive;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: GlassContainer(
        child: TextField(
          onChanged: controller.onSearchChanged,
          cursorColor: AppColors.primary,
          style: TextStyle(
            color: isDark ? Colors.white : AppColors.textMuted,
            fontSize: responsive.getBodyFontSize(),
          ),
          decoration: InputDecoration(
            hintText: hintText,
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
