import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/responsive.dart';
import '../controllers/users_providers.dart';

/// رأس إحصائيات المستخدمين بتصميم Neumorphism / Soft UI
class UsersStatsHeader extends ConsumerWidget {
  const UsersStatsHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final responsive = context.responsive;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final borderRadius = BorderRadius.circular(20);

    final totalUsers =
        ref.watch(usersNotifierProvider).valueOrNull?.totalUsers ?? 0;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.defaultPadding.left,
        vertical: 4,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
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
                  ? Colors.black.withValues(alpha: 0.55)
                  : const Color(0xFFA3B1C6).withValues(alpha: 0.42),
              offset: const Offset(4, 6),
              blurRadius: 14,
            ),
            BoxShadow(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.04)
                  : Colors.white.withValues(alpha: 0.95),
              offset: const Offset(-3, -3),
              blurRadius: 10,
            ),
          ],
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : Colors.white.withValues(alpha: 0.85),
            width: 1.0,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          Color.lerp(colorScheme.surfaceContainerHigh, Colors.white, 0.06)!,
                          Color.lerp(colorScheme.surfaceContainerHigh, Colors.black, 0.15)!,
                        ]
                      : [
                          Colors.white,
                          Color.lerp(colorScheme.surfaceContainerLow, Colors.black, 0.04)!,
                        ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withValues(alpha: 0.5)
                        : const Color(0xFFA3B1C6).withValues(alpha: 0.4),
                    offset: const Offset(2.5, 3),
                    blurRadius: 5,
                  ),
                  BoxShadow(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.white.withValues(alpha: 0.95),
                    offset: const Offset(-2, -2),
                    blurRadius: 5,
                  ),
                ],
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.white.withValues(alpha: 0.9),
                  width: 1.5,
                ),
              ),
              child: Icon(
                Icons.people_alt_rounded,
                color: colorScheme.primary,
                size: 26,
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'إجمالي المسجلين',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  totalUsers.toString(),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontSize: responsive.getTitleFontSize(),
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
