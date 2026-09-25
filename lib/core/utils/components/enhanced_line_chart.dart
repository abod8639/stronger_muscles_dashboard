import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../config/app_colors.dart';

/// مكون رسم بياني خطي محسّن
class EnhancedLineChartWidget extends StatelessWidget {
  final String title;
  final List<FlSpot> spots;
  final Color lineColor;
  final Color gradientColor;
  final String? yAxisLabel;
  final String? xAxisLabel;
  final double maxY;
  final double? horizontalInterval;
  final List<String>? bottomTitles;
  final double? bottomTitleInterval;
  final int? touchTooltipIndex;
  final bool isEmbedded;

  const EnhancedLineChartWidget({
    super.key,
    required this.title,
    required this.spots,
    required this.lineColor,
    required this.gradientColor,
    this.yAxisLabel,
    this.xAxisLabel,
    this.maxY = 100,
    this.horizontalInterval,
    this.bottomTitles,
    this.bottomTitleInterval,
    this.touchTooltipIndex,
    this.isEmbedded = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final effectiveMaxY = maxY <= 0 ? 4.0 : maxY;
    final effectiveInterval = horizontalInterval ??
        ((effectiveMaxY / 4) <= 0 ? 1.0 : (effectiveMaxY / 4));
    final maxXValue = spots.isEmpty
        ? 6.0
        : (spots.length <= 1 ? 1.0 : (spots.length - 1).toDouble());

    final chartWidget = SizedBox(
      height: 230,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: effectiveInterval,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.06),
                strokeWidth: 0.8,
                dashArray: [5, 5],
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                interval: bottomTitleInterval ?? 1.0,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (bottomTitles != null) {
                    if (index < 0 || index >= bottomTitles!.length) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        bottomTitles![index],
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.75),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      '$index',
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.75),
                        fontSize: 11,
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 36,
                interval: effectiveInterval,
                getTitlesWidget: (value, meta) {
                  if (value % 1 != 0 && value != 0) {
                    return const SizedBox.shrink();
                  }
                  return Text(
                    '${value.toInt()}',
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant.withValues(alpha: 0.75),
                      fontSize: 11,
                    ),
                    textAlign: TextAlign.right,
                  );
                },
              ),
            ),
          ),
          lineTouchData: LineTouchData(
            enabled: true,
            handleBuiltInTouches: true,
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (touchedSpot) =>
                  isDark ? colorScheme.surfaceContainerHighest : Colors.white,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((LineBarSpot touchedSpot) {
                  final index = touchedSpot.x.toInt();
                  final dateLabel = (bottomTitles != null &&
                          index >= 0 &&
                          index < bottomTitles!.length)
                      ? bottomTitles![index]
                      : '';
                  final count = touchedSpot.y.toInt();
                  return LineTooltipItem(
                    dateLabel.isNotEmpty
                        ? '$dateLabel\n$count طلب'
                        : '$count طلب',
                    TextStyle(
                      color: isDark ? Colors.white : colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      height: 1.3,
                    ),
                  );
                }).toList();
              },
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              preventCurveOverShooting: true,
              curveSmoothness: 0.35,
              color: lineColor,
              barWidth: 3,
              isStrokeCapRound: true,
              shadow: Shadow(
                color: lineColor.withValues(alpha: 0.4),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
              dotData: FlDotData(
                show: spots.length <= 15,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: lineColor,
                    strokeWidth: 2,
                    strokeColor: isDark
                        ? colorScheme.surfaceContainer
                        : Colors.white,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    gradientColor.withValues(alpha: 0.3),
                    gradientColor.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ],
          minX: 0,
          maxX: maxXValue,
          maxY: effectiveMaxY,
          minY: 0,
        ),
      ),
    );

    if (isEmbedded) {
      if (title.isNotEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(child: chartWidget),
          ],
        );
      }
      return chartWidget;
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: isDark ? AppColorsExtended.softShadow : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          color: colorScheme.surfaceContainer,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title.isNotEmpty) ...[
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 16),
              ],
              chartWidget,
            ],
          ),
        ),
      ),
    );
  }
}
