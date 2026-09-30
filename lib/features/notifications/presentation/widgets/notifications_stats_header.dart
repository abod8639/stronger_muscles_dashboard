import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/responsive.dart';
import '../controllers/notifications_controller.dart';

class NotificationsStatsHeader extends GetView<NotificationsController> {
  const NotificationsStatsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final isNarrow = responsive.screenWidth < 1000;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.defaultPadding.left,
        vertical: 4,
      ),
      child: Obx(() {
        final total = controller.totalCount.value.toString();
        final today = controller.todayCount.value.toString();
        final broadcast = controller.broadcastCount.value.toString();
        final targeted = controller.targetedCount.value.toString();

        if (isNarrow) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      context,
                      title: 'إجمالي الإشعارات',
                      value: total,
                      icon: Icons.notifications_active_rounded,
                      iconColor: colorScheme.primary,
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      title: 'أُرسلت اليوم',
                      value: today,
                      icon: Icons.today_rounded,
                      iconColor: Colors.amber,
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      context,
                      title: 'إشعارات عامة',
                      value: broadcast,
                      icon: Icons.campaign_rounded,
                      iconColor: Colors.teal,
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      title: 'إشعارات مخصصة',
                      value: targeted,
                      icon: Icons.person_pin_rounded,
                      iconColor: Colors.purple,
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                title: 'إجمالي الإشعارات',
                value: total,
                icon: Icons.notifications_active_rounded,
                iconColor: colorScheme.primary,
                isDark: isDark,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                context,
                title: 'أُرسلت اليوم',
                value: today,
                icon: Icons.today_rounded,
                iconColor: Colors.amber,
                isDark: isDark,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                context,
                title: 'إشعارات عامة',
                value: broadcast,
                icon: Icons.campaign_rounded,
                iconColor: Colors.teal,
                isDark: isDark,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                context,
                title: 'إشعارات مخصصة',
                value: targeted,
                icon: Icons.person_pin_rounded,
                iconColor: Colors.purple,
                isDark: isDark,
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    required bool isDark,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  Color.lerp(colorScheme.surfaceContainer, Colors.white, 0.03)!,
                  Color.lerp(colorScheme.surfaceContainer, Colors.black, 0.09)!,
                ]
              : [
                  Color.lerp(colorScheme.surfaceContainer, Colors.white, 0.70)!,
                  Color.lerp(colorScheme.surfaceContainer, Colors.black, 0.03)!,
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.5)
                : const Color(0xFFA3B1C6).withValues(alpha: 0.35),
            offset: const Offset(3, 4),
            blurRadius: 10,
          ),
          BoxShadow(
            color: isDark
                ? Colors.white.withValues(alpha: 0.03)
                : Colors.white.withValues(alpha: 0.9),
            offset: const Offset(-2, -2),
            blurRadius: 6,
          ),
        ],
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.white.withValues(alpha: 0.8),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconColor.withValues(alpha: 0.15),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
