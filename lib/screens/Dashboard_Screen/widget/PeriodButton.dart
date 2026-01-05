
import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';

class PeriodButton extends StatelessWidget {
  final String label;
  final String value;
  final bool isSelected;
  final VoidCallback onTap;

  const PeriodButton({super.key, 
    required this.label,
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final responsive = context.responsive;
    final padding = responsive.defaultPadding;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: padding.left,
          vertical: padding.top / 2,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          border: isSelected
              ? null
              : Border.all(color: isDark ? Colors.grey.shade800 : AppColors.backgroundLight),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : (isDark ? Colors.grey.shade400 : AppColors.textDark),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
