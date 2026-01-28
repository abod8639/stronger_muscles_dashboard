
  import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/config/app_colors.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';

Widget buildDashboardTitle(ResponsiveLayout res) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'مرحباً بك مجدداً! 👋',
          style: TextStyle(
            fontSize: res.getTitleFontSize() + 2,
            fontWeight: FontWeight.w900,
            color: AppColorsExtended.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'إليك ملخص أداء عملك اليوم',
          style: TextStyle(
            fontSize: 14,
            color: AppColorsExtended.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

