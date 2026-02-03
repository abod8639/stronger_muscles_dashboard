
import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';

Widget buildInfoItem({
  required IconData icon,
  required String label,
  required String sublabel,
}) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 14, color: AppColors.primary.withOpacity(0.7)),
      const SizedBox(width: 6),
      Flexible(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              sublabel,
              style: TextStyle(
                fontSize: 9,
                color: Colors.white.withOpacity(0.4),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
