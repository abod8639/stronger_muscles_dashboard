import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:stronger_muscles_dashboard/screens/components/glass_container.dart';
import '../../config/theme.dart';
import '../../config/responsive.dart';

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

    return GlassContainer(
      opacity: 0.05,
      blur: 20,
      borderRadius: BorderRadius.circular(20),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.02)],
      ),
      border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      child: Padding(
        padding: EdgeInsets.all(responsive.defaultPadding.left),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // العنوان
            Row(
              children: [
                Icon(
                  Icons.show_chart_rounded,
                  color: AppColors.success,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  widget.title.toUpperCase(),
                  style: TextStyle(
                    fontSize: responsive.getTitleFontSize(),
                    fontWeight: FontWeight.bold,
                    color: AppColors.textLight,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
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
                        color: Colors.white.withOpacity(0.05),
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
                          if (index < 0 ||
                              index >= widget.bottomTitles.length) {
                            return const SizedBox();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              widget.bottomTitles[index],
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontWeight: FontWeight.w500,
                                fontSize: 10,
                              ),
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
                              color: AppColors.textMuted,
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: (widget.spots.length - 1).toDouble(),
                  minY: 0,
                  maxY: widget.maxY,
                  lineBarsData: [
                    LineChartBarData(
                      spots: widget.spots,
                      isCurved: true,
                      curveSmoothness: 0.4,
                      gradient: LinearGradient(
                        colors: [widget.gradientColor, AppColors.accent],
                      ),
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: AppColors.backgroundDark,
                            strokeWidth: 2,
                            strokeColor: widget.gradientColor,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            widget.gradientColor.withOpacity(0.3),
                            widget.gradientColor.withOpacity(0.0),
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
                            touchedSpot.y.toStringAsFixed(1),
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList();
                      },
                      getTooltipColor: (touchedSpot) =>
                          const Color(0xFF1E1E2C), // Updated tooltip color
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
