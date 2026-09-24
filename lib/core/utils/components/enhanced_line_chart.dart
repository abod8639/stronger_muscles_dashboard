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
  });

  @override
  Widget build(BuildContext context) {
    final effectiveMaxY = maxY <= 0 ? 4.0 : maxY;
    final effectiveInterval = horizontalInterval ??
        ((effectiveMaxY / 4) <= 0 ? 1.0 : (effectiveMaxY / 4));
    final maxXValue = spots.isEmpty
        ? 6.0
        : (spots.length <= 1 ? 1.0 : (spots.length - 1).toDouble());

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColorsExtended.borderColor, width: 1),
        boxShadow: AppColorsExtended.softShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          color: AppColorsExtended.cardBg,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title.isNotEmpty) ...[
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColorsExtended.textPrimary,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 16),
              ],
              SizedBox(
                height: 230,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: effectiveInterval,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: AppColorsExtended.borderColor.withValues(
                            alpha: 0.3,
                          ),
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
                                  style: const TextStyle(
                                    color: AppColorsExtended.textMuted,
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
                                style: const TextStyle(
                                  color: AppColorsExtended.textMuted,
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
                              style: const TextStyle(
                                color: AppColorsExtended.textMuted,
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
                            AppColorsExtended.cardBgLight,
                        // tooltipRoundedRadius: 8,
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
                              const TextStyle(
                                color: Colors.white,
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
                        color: lineColor,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: spots.length <= 15,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 4,
                              color: lineColor,
                              strokeWidth: 2,
                              strokeColor: AppColorsExtended.cardBg,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
