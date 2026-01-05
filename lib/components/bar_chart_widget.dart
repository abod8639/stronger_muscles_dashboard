import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../config/theme.dart';
import '../config/responsive.dart';

class BarChartWidget extends StatefulWidget {
  final String title;
  final List<BarChartGroupData> groups;
  final List<String> bottomTitles;
  final String xAxisLabel;
  final String yAxisLabel;
  final double maxY;

  const BarChartWidget({
    super.key,
    required this.title,
    required this.groups,
    required this.bottomTitles,
    this.xAxisLabel = '',
    this.yAxisLabel = '',
    this.maxY = 100,
  });

  @override
  State<BarChartWidget> createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends State<BarChartWidget> {
  late List<Color> barColors;

  @override
  void initState() {
    super.initState();
    barColors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.success,
      AppColors.warning,
    ];
  }

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
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: widget.maxY,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (
                        BarChartGroupData group,
                        int groupIndex,
                        BarChartRodData rod,
                        int rodIndex,
                      ) {
                        return BarTooltipItem(
                          '${rod.toY.toStringAsFixed(0)}',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(),
                    topTitles: const AxisTitles(),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
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
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: widget.groups,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
