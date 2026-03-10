import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/config/app_colors.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';

Widget buildSectionTitle(String title, ResponsiveLayout res) {
  return Padding(
    padding: EdgeInsets.only(bottom: res.itemSpacing),
    child: Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: AppColorsExtended.cyanAccent,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: res.getTitleFontSize(),
            fontWeight: FontWeight.bold,
            color: AppColorsExtended.textPrimary,
            letterSpacing: 0.5,
          ),
        ),
      ],
    ),
  );
}
