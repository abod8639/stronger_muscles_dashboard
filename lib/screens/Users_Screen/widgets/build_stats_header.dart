
  import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';
import 'package:stronger_muscles_dashboard/controllers/users_controller.dart';

Widget buildStatsHeader( UsersController controller ) {
    return Builder(
      builder: (context) {
        return Container(
          padding: context.responsive.defaultPadding,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).dividerColor,
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.people_alt_rounded,
                  color: AppColors.primary,
                  size: 24,
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
        );
      }
    );
  }

