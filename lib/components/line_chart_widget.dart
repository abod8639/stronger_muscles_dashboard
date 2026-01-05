import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../config/theme.dart';
import '../config/responsive.dart';

class LineChartWidget extends StatefulWidget {
  final String title;
  final List<FlSpot> spots;
  final List<String> bottomTitles;
  final String xAxisLabel;
  final String yAxisLabel;
  final Color gradientColor;
  final double maxY;

  const LineChartWidget({
    super.key,
    required this.title,
    required this.spots,
    required this.bottomTitles,
    this.xAxisLabel = '',
    this.yAxisLabel = '',
    this.gradientColor = AppColors.primary,
    this.maxY = 100,
  });

  @override
  State<LineChartWidget> createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              isDark ? const Color(0xFF2C2C2C) : Colors.white,
              isDark ? const Color(0xFF1E1E1E) : Colors.grey[50] ?? Colors.white,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.08),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        padding: EdgeInsets.all(responsive.defaultPadding.left),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // العنوان
            Text(
              widget.title,
              style: TextStyle(
                fontSize: responsive.getTitleFontSize(),
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            SizedBox(height: responsive.itemSpacing),

            // الرسم البياني
            SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: widget.maxY / 5,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        strokeWidth: 1,
                        dashArray: [5, 5],
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(),
                    topTitles: const AxisTitles(),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= widget.bottomTitles.length) {
                            return const SizedBox();
                          }
                          return Text(
                            widget.bottomTitles[index],
                            style: TextStyle(
                              color: AppColors.textLight,
                              fontWeight: FontWeight.w500,
                              fontSize: responsive.getBodyFontSize() - 2,
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
                              color: AppColors.textLight,
                              fontWeight: FontWeight.w500,
                              fontSize: responsive.getBodyFontSize() - 2,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  minX: 0,
                  maxX: (widget.spots.length - 1).toDouble(),
                  minY: 0,
                  maxY: widget.maxY,
                  lineBarsData: [
                    LineChartBarData(
                      spots: widget.spots,
                      isCurved: true,
                      gradient: LinearGradient(
                        colors: [
                          widget.gradientColor,
                          widget.gradientColor.withValues(alpha: 0.3),
                        ],
                      ),
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 5,
                            color: widget.gradientColor,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            widget.gradientColor.withValues(alpha: 0.3),
                            widget.gradientColor.withValues(alpha: 0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    enabled: true,
                    handleBuiltInTouches: true,
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (List<LineBarSpot> touchedSpots) {
                        return touchedSpots.map((LineBarSpot touchedSpot) {
                          return LineTooltipItem(
                            '${touchedSpot.y.toStringAsFixed(1)}',
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
