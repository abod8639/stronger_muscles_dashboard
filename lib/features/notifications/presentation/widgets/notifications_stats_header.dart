import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/responsive.dart';
import '../controllers/notifications_providers.dart';

/// Presentation Header widget displaying aggregated notification metrics.
/// Listens selectively via [notificationsStatsProvider] to avoid rebuilding on search queries.
class NotificationsStatsHeader extends ConsumerWidget {
  const NotificationsStatsHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final responsive = context.responsive;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final isNarrow = responsive.screenWidth < 1000;

    final stats = ref.watch(notificationsStatsProvider);

    final total = stats.total.toString();
    final today = stats.today.toString();
    final broadcast = stats.broadcast.toString();
    final targeted = stats.targeted.toString();

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.defaultPadding.left,
        vertical: 4,
      ),
      child: isNarrow
          ? Column(
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
            )
          : Row(
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
            ),
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  Color.lerp(colorScheme.surfaceContainer, Colors.white, 0.04)!,
                  Color.lerp(colorScheme.surfaceContainer, Colors.black, 0.08)!,
                ]
              : [
                  Color.lerp(colorScheme.surface, Colors.white, 0.85)!,
                  Color.lerp(colorScheme.surface, const Color(0xFFA3B1C6), 0.08)!,
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : const Color(0xFFA3B1C6).withValues(alpha: 0.25),
            offset: const Offset(3, 4),
            blurRadius: 8,
          ),
          BoxShadow(
            color: isDark
                ? Colors.white.withValues(alpha: 0.02)
                : Colors.white.withValues(alpha: 0.9),
            offset: const Offset(-2, -2),
            blurRadius: 6,
          ),
        ],
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.white.withValues(alpha: 0.85),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: iconColor.withValues(alpha: 0.28)),
            ),
            child: Icon(icon, color: iconColor, size: 22),
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
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
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
