import 'package:flutter/material.dart';

Widget buildActionBtn({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 20, color: color),
        constraints: const BoxConstraints(
          minWidth: 38,
          minHeight: 38,
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }