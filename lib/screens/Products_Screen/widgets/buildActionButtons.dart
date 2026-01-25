import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/components/glass_container.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';

Widget buildActionButtons({
  required Function() onEdit,
  required Function() onDelete,
  required bool isHovered,
}) {
  return Builder(
    builder: (context) {
      final ResponsiveLayout responsive = context.responsive;
      return AnimatedOpacity(
        opacity: isHovered ? 1 : 0.6,
        duration: const Duration(milliseconds: 300),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Edit Button (Neon Blue)
            _buildActionButton(
              onPressed: onEdit,
              icon: Icons.edit_rounded,
              color: AppColors.accent,
              isHovered: isHovered,
              responsive: responsive,
            ),
            SizedBox(height: 12),
            // Delete Button (Neon Red)
            _buildActionButton(
              onPressed: onDelete,
              icon: Icons.delete_outline_rounded,
              color: AppColors.error,
              isHovered: isHovered,
              responsive: responsive,
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildActionButton({
  required VoidCallback onPressed,
  required IconData icon,
  required Color color,
  required bool isHovered,
  required ResponsiveLayout responsive,
}) {
  return AnimatedScale(
    scale: isHovered ? 1.1 : 1.0,
    duration: const Duration(milliseconds: 300),
    child: GlassContainer(
      padding: EdgeInsets.all(responsive.isMobile ? 3 : 8),
      opacity: isHovered ? 0.2 : 0.1,
      blur: 10,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: color.withOpacity(isHovered ? 0.6 : 0.3),
        width: 1,
      ),
      child: Center(
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(icon, size:responsive.isMobile ? 16 : 18, color: color),
          padding:  EdgeInsets.all( responsive.isMobile ? 0 : 8),
          constraints: const BoxConstraints(),
          visualDensity: VisualDensity.compact,
        ),
      ),
    ),
  );
}
