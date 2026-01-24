import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:stronger_muscles_dashboard/components/glass_container.dart';
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
      // AppColors.warning,
      AppColors.success,
      AppColors.warning,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    // final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlassContainer(
      opacity: 0.05,
      blur: 20,
      borderRadius: BorderRadius.circular(20),
      gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.02),
              ],
            ),
      border: Border.all(
        color: Colors.white.withOpacity(0.1),
        width: 1,
      ),
      child: Padding(
        padding: EdgeInsets.all(responsive.defaultPadding.left),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // العنوان
            Row(
              children: [
                Icon(Icons.bar_chart_rounded, color: AppColors.accent, size: 20),
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
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: widget.maxY,
                  backgroundColor: Colors.transparent,
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
                          rod.toY.toStringAsFixed(0),
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
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: widget.maxY > 0 ? widget.maxY / 5 : 1, // Prevent division by zero
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.white.withOpacity(0.05),
                        strokeWidth: 1,
                        dashArray: [5, 5],
                      );
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: widget.groups.map((group) {
                    return group.copyWith(
                      barRods: group.barRods.map((rod) {
                        return rod.copyWith(
                          width: 20,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: widget.maxY,
                            color: Colors.white.withOpacity(0.05), // Track background
                          ),
                        );
                      }).toList(),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
