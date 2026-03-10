import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/screens/components/glass_container.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import '../controllers/users_controller.dart';

Widget buildStatsHeader() {
  final controller = Get.find<UsersController>();
  return Builder(
    builder: (context) {
      final responsive = context.responsive;
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: responsive.defaultPadding.left,
        ),
        child: GlassContainer(
          padding: EdgeInsetsGeometry.all(0),
          width: double.infinity,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.people_alt_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'إجمالي المسجلين',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: context.responsive.getBodyFontSize(),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    controller.totalUsers.value.toString(),
                    style: TextStyle(
                      fontSize: context.responsive.getTitleFontSize(),
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
