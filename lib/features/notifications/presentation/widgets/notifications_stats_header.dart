import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/core/components/premium_indicator_card.dart';
import 'package:stronger_muscles_dashboard/core/components/responsive_stats_grid.dart';
import 'package:stronger_muscles_dashboard/core/theme/responsive.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';
import '../controllers/notifications_providers.dart';

/// Presentation Header widget displaying aggregated notification metrics.
/// Listens selectively via [notificationsStatsProvider] to avoid rebuilding on search queries.
class NotificationsStatsHeader extends ConsumerWidget {
  const NotificationsStatsHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(notificationsStatsProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return ResponsiveStatsGrid(
      padding: EdgeInsets.symmetric(
        horizontal: context.responsive.defaultPadding.left,
      ),
      cards: [
        PremiumIndicatorCard(
          title: 'إجمالي الإشعارات',
          value: stats.total.toString(),
          accentColor: colorScheme.primary,
          icon: Icons.notifications_active_rounded,
        ),
        PremiumIndicatorCard(
          title: 'أُرسلت اليوم',
          value: stats.today.toString(),
          accentColor: AppColors.warning,
          icon: Icons.today_rounded,
        ),
        PremiumIndicatorCard(
          title: 'إشعارات عامة',
          value: stats.broadcast.toString(),
          accentColor: AppColors.success,
          icon: Icons.campaign_rounded,
        ),
        PremiumIndicatorCard(
          title: 'إشعارات مخصصة',
          value: stats.targeted.toString(),
          accentColor: AppColors.info,
          icon: Icons.person_pin_rounded,
        ),
      ],
    );
  }
}
