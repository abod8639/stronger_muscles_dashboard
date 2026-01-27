import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../config/app_colors.dart';

/// مكون رسم بياني خطي محسّن
class EnhancedLineChartWidget extends StatelessWidget {
  final String title;
  final List<FlSpot> spots;
  final Color lineColor;
  final Color gradientColor;
  final String? yAxisLabel;
  final String? xAxisLabel;
  final double maxY;
  final int? touchTooltipIndex;

  const EnhancedLineChartWidget({
    Key? key,
    required this.title,
    required this.spots,
    required this.lineColor,
    required this.gradientColor,
    this.yAxisLabel,
    this.xAxisLabel,
    this.maxY = 100,
    this.touchTooltipIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColorsExtended.borderColor,
          width: 1,
        ),
        boxShadow: AppColorsExtended.softShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          color: AppColorsExtended.cardBg,
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColorsExtended.textPrimary,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 300,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: maxY / 4,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: AppColorsExtended.borderColor
                              .withValues(alpha: 0.3),
                          strokeWidth: 0.8,
                          dashArray: [5, 5],
                        );
                      },
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              '${value.toInt()}',
                              style: TextStyle(
                                color: AppColorsExtended.textMuted,
                                fontSize: 10,
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              '${value.toInt()}',
                              style: TextStyle(
                                color: AppColorsExtended.textMuted,
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.right,
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        color: lineColor,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
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
                    maxX: spots.isEmpty ? 10 : spots.length.toDouble() - 1,
                    maxY: maxY,
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
