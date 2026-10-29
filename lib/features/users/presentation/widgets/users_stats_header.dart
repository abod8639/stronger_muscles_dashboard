import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/core/components/premium_indicator_card.dart';
import 'package:stronger_muscles_dashboard/core/components/responsive_stats_grid.dart';
import 'package:stronger_muscles_dashboard/core/theme/responsive.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';
import '../controllers/users_providers.dart';

/// إحصائيات المستخدمين: الإجمالي، النشطون، وغير النشطين
class UsersStatsHeader extends ConsumerWidget {
  const UsersStatsHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(usersNotifierProvider.select((s) => s.value));
    final colorScheme = Theme.of(context).colorScheme;

    return ResponsiveStatsGrid(
      padding: EdgeInsets.symmetric(
        horizontal: context.responsive.defaultPadding.left,
      ),
      cards: [
        PremiumIndicatorCard(
          title: 'إجمالي المسجلين',
          value: '${stats?.totalUsers ?? 0}',
          icon: Icons.people_alt_rounded,
          accentColor: colorScheme.primary,
        ),
        PremiumIndicatorCard(
          title: 'المستخدمون النشطون',
          value: '${stats?.activeUsers ?? 0}',
          icon: Icons.verified_user_rounded,
          accentColor: AppColors.success,
        ),
        PremiumIndicatorCard(
          title: 'غير النشطين',
          value: '${stats?.inactiveUsers ?? 0}',
          icon: Icons.person_off_rounded,
          accentColor: colorScheme.error,
        ),
      ],
    );
  }
}
