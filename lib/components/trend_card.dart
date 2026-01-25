import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/config/theme.dart';

class TrendCard extends StatelessWidget {
  const TrendCard({
    super.key,
    required this.isTrendPositive,
    // required this.widget,
  });

  final bool isTrendPositive;
  // final StatCard widget;

  @override
  Widget build(BuildContext context) {
    final Color trendColor = isTrendPositive
        ? AppColors.success
        : AppColors.error;
    final IconData trendIcon = isTrendPositive
        ? Icons.trending_up
        : Icons.trending_down;
    final String trendText = isTrendPositive
        ? '+12% THIS WEEK'
        : '-8% THIS WEEK';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: trendColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: trendColor.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(trendIcon, color: trendColor, size: 12),
          const SizedBox(width: 4),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                trendText,
                style: TextStyle(
                  fontSize: 10,
                  color: trendColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
