import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/components/glass_container.dart';
import '../controllers/users_controller.dart';
import '../../../../config/responsive.dart';
import '../../../../config/theme.dart';

class UsersStatsHeader extends GetView<UsersController> {
  const UsersStatsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    
    return Obx(() => Padding(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.defaultPadding.left,
      ),
      child: GlassContainer(
        padding: const EdgeInsets.all(0),
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
                    fontSize: responsive.getBodyFontSize(),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  controller.totalUsers.value.toString(),
                  style: TextStyle(
                    fontSize: responsive.getTitleFontSize(),
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
