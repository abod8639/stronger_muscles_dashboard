import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/core/theme/responsive.dart';
import '../controllers/support_providers.dart';

/// Dumb presentation component displaying high-level support ticket statistics.
/// Uses selective Riverpod watching to prevent unnecessary widget rebuilds.
class SupportStatsHeader extends ConsumerWidget {
  const SupportStatsHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(supportControllerProvider.select((s) => s.stats));
    final responsive = context.responsive;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final isNarrow = responsive.screenWidth < 1100;

    final total = stats.total.toString();
    final open = stats.open.toString();
    final inProgress = stats.inProgress.toString();
    final urgent = stats.urgent.toString();
    final resolved = stats.resolved.toString();

    Widget content;
    if (responsive.isMobile) {
      content = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SizedBox(
              width: 140,
              child: _buildStatCard(
                context,
                title: 'إجمالي البلاغات',
                value: total,
                icon: Icons.confirmation_number_rounded,
                iconColor: colorScheme.primary,
                isDark: isDark,
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 140,
              child: _buildStatCard(
                context,
                title: 'بانتظار المعالجة',
                value: open,
                icon: Icons.mark_chat_unread_rounded,
                iconColor: colorScheme.secondary,
                isDark: isDark,
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 140,
              child: _buildStatCard(
                context,
                title: 'قيد المتابعة',
                value: inProgress,
                icon: Icons.sync_rounded,
                iconColor: colorScheme.tertiary,
                isDark: isDark,
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 140,
              child: _buildStatCard(
                context,
                title: 'شكاوى عاجلة',
                value: urgent,
                icon: Icons.warning_amber_rounded,
                iconColor: colorScheme.error,
                isDark: isDark,
                isAlert: stats.urgent > 0,
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 140,
              child: _buildStatCard(
                context,
                title: 'تم الحل',
                value: resolved,
                icon: Icons.check_circle_outline_rounded,
                iconColor: colorScheme.primary,
                isDark: isDark,
              ),
            ),
          ],
        ),
      );
    } else if (isNarrow) {
      content = Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  title: 'إجمالي البلاغات',
                  value: total,
                  icon: Icons.confirmation_number_rounded,
                  iconColor: colorScheme.primary,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatCard(
                  context,
                  title: 'بانتظار المعالجة',
                  value: open,
                  icon: Icons.mark_chat_unread_rounded,
                  iconColor: colorScheme.secondary,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatCard(
                  context,
                  title: 'قيد المتابعة',
                  value: inProgress,
                  icon: Icons.sync_rounded,
                  iconColor: colorScheme.tertiary,
                  isDark: isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  title: 'شكاوى عاجلة جداً',
                  value: urgent,
                  icon: Icons.warning_amber_rounded,
                  iconColor: colorScheme.error,
                  isDark: isDark,
                  isAlert: stats.urgent > 0,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatCard(
                  context,
                  title: 'تم حلها بنجاح',
                  value: resolved,
                  icon: Icons.check_circle_outline_rounded,
                  iconColor: colorScheme.primary,
                  isDark: isDark,
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      content = Row(
        children: [
          Expanded(
            child: _buildStatCard(
              context,
              title: 'إجمالي البلاغات',
              value: total,
              icon: Icons.confirmation_number_rounded,
              iconColor: colorScheme.primary,
              isDark: isDark,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildStatCard(
              context,
              title: 'بانتظار المعالجة',
              value: open,
              icon: Icons.mark_chat_unread_rounded,
              iconColor: colorScheme.secondary,
              isDark: isDark,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildStatCard(
              context,
              title: 'قيد المتابعة',
              value: inProgress,
              icon: Icons.sync_rounded,
              iconColor: colorScheme.tertiary,
              isDark: isDark,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildStatCard(
              context,
              title: 'شكاوى عاجلة جداً',
              value: urgent,
              icon: Icons.warning_amber_rounded,
              iconColor: colorScheme.error,
              isDark: isDark,
              isAlert: stats.urgent > 0,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildStatCard(
              context,
              title: 'تم حلها بنجاح',
              value: resolved,
              icon: Icons.check_circle_outline_rounded,
              iconColor: colorScheme.primary,
              isDark: isDark,
            ),
          ),
        ],
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: responsive.defaultPadding.left),
      child: content,
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    required bool isDark,
    bool isAlert = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isAlert
            ? colorScheme.errorContainer.withValues(alpha: isDark ? 0.3 : 0.5)
            : colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isAlert
              ? colorScheme.error.withValues(alpha: 0.6)
              : colorScheme.outlineVariant,
          width: isAlert ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: isDark ? 0.2 : 0.04),
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: isAlert ? colorScheme.error : colorScheme.onSurface,
                    fontSize: 16,
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
