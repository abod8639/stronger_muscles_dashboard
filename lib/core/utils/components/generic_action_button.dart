import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/glass_container.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';

enum ActionButtonStyle { simple, glass }

class GenericActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final ActionButtonStyle style;
  final bool isHovered;

  const GenericActionButton({
    super.key,
    required this.icon,
    required this.color,
    required this.onPressed,
    this.style = ActionButtonStyle.simple,
    this.isHovered = false,
  });

  @override
  Widget build(BuildContext context) {
    return style == ActionButtonStyle.simple
        ? _buildSimpleButton()
        : _buildGlassButton(context);
  }

  Widget _buildSimpleButton() {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 20, color: color),
        constraints: const BoxConstraints(minWidth: 38, minHeight: 38),
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildGlassButton(BuildContext context) {
    final responsive = context.responsive;

    return AnimatedScale(
      scale: isHovered ? 1.1 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: GlassContainer(
        onTap: onPressed,
        padding: EdgeInsets.all(responsive.isMobile ? 10 : 12),
        opacity: isHovered ? 0.2 : 0.1,
        blur: 10,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(isHovered ? 0.6 : 0.3),
          width: 1,
        ),
        child: Center(
          child: Icon(icon, size: responsive.isMobile ? 16 : 18, color: color),
        ),
      ),
    );
  }
}

/// Helper widget to build a column of action buttons (for products screen style)
class ActionButtonColumn extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isHovered;
  final Color editColor;
  final Color deleteColor;

  const ActionButtonColumn({
    super.key,
    required this.onEdit,
    required this.onDelete,
    required this.isHovered,
    this.editColor = const Color(0xFF00D9FF),
    this.deleteColor = const Color(0xFFFF6B9D),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isHovered ? 1 : 0.6,
      duration: const Duration(milliseconds: 300),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GenericActionButton(
            icon: Icons.edit_rounded,
            color: editColor,
            onPressed: onEdit,
            style: ActionButtonStyle.glass,
            isHovered: isHovered,
          ),
          const SizedBox(height: 12),
          GenericActionButton(
            icon: Icons.delete_outline_rounded,
            color: deleteColor,
            onPressed: onDelete,
            style: ActionButtonStyle.glass,
            isHovered: isHovered,
          ),
        ],
      ),
    );
  }
}
