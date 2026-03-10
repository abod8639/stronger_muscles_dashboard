import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';

class MyRefreshIndicator extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;

  const MyRefreshIndicator({
    super.key,
    required this.onRefresh,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primary,
      backgroundColor: AppColors.surfaceDark.withValues(alpha: 0.9),

      edgeOffset: 20,
      displacement: 40,
      strokeWidth: 3,

      notificationPredicate: (notification) {
        return notification.depth == 0;
      },

      onRefresh: onRefresh,
      child: child,
    );
  }
}
