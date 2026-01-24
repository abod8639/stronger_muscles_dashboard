import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/components/glass_container.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';

class CategoryItem extends StatelessWidget {
  final String name;
  final bool isSelected;
  final VoidCallback onTap;
  final ResponsiveLayout responsive;

  const CategoryItem({
    super.key,
    required this.name,
    required this.isSelected,
    required this.onTap,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: responsive.itemSpacing / 2),
      child: AnimatedScale(
        scale: isSelected ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 300),
        child: GlassContainer(
          opacity: isSelected ? 0.2 : 0.05,
          blur: isSelected ? 20 : 10,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.white.withOpacity(0.1),
            width: isSelected ? 1.5 : 1,
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isSelected
                ? [AppColors.primary.withOpacity(0.3), AppColors.primary.withOpacity(0.1)]
                : [Colors.white.withOpacity(0.05), Colors.white.withOpacity(0.01)],
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(15),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              constraints: const BoxConstraints(minWidth: 80),
              child: Center(
                child: Text(
                  name.toUpperCase(),
                  style: TextStyle(
                    color:  AppColors.textLight,
                    fontWeight: isSelected ? FontWeight.w900 : FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 1,
                    shadows: isSelected
                        ? [
                            Shadow(
                              color: AppColors.primary.withOpacity(0.5),
                              blurRadius: 10,
                            )
                          ]
                        : null,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}