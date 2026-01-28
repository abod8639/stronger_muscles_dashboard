import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:stronger_muscles_dashboard/screens/components/glass_container.dart';
import '../../config/theme.dart';
import '../../config/responsive.dart';

class PieChartItemData {
  final String label;
  final double value;
  final Color color;

  PieChartItemData({
    required this.label,
    required this.value,
    required this.color,
  });
}

class PieChartWidget extends StatefulWidget {
  final String title;
  final List<PieChartItemData> data;
  final bool showLegend;

  const PieChartWidget({
    super.key,
    required this.title,
    required this.data,
    this.showLegend = true,
  });

  @override
  State<PieChartWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    // final isDark = Theme.of(context).brightness == Brightness.dark;

    final totalValue = widget.data.fold<double>(
      0,
      (sum, item) => sum + item.value,
    );

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
                  Icons.pie_chart_rounded,
                  color: AppColors.primary,
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

            // الرسم البياني والبيانات
            Row(
              children: [
                // الرسم البياني
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 250,
                    child: PieChart(
                      PieChartData(
                        sections: List.generate(widget.data.length, (index) {
                          final data = widget.data[index];
                          final isTouched = index == touchedIndex;
                          final radius = isTouched ? 80.0 : 65.0;
                          final percentage = (data.value / totalValue) * 100;

                          return PieChartSectionData(
                            value: data.value,
                            title: '${percentage.toStringAsFixed(1)}%',
                            radius: radius,
                            titleStyle: TextStyle(
                              fontSize: isTouched ? 14 : 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(color: Colors.black45, blurRadius: 4),
                              ],
                            ),
                            color: data.color,
                            badgeWidget: isTouched
                                ? Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1E1E2C),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: data.color.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 8,
                                        ),
                                      ],
                                      border: Border.all(
                                        color: data.color,
                                        width: 2,
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      data.value.toStringAsFixed(0),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  )
                                : null,
                            badgePositionPercentageOffset: 0.98,
                          );
                        }),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: responsive.itemSpacing * 2),

                // وسيط الملخص
                if (widget.showLegend)
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(widget.data.length, (index) {
                        final data = widget.data[index];
                        final percentage = (data.value / totalValue) * 100;

                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: responsive.itemSpacing,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: data.color,
                                  boxShadow: [
                                    BoxShadow(
                                      color: data.color.withOpacity(0.6),
                                      blurRadius: 6,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: responsive.itemSpacing / 2),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data.label,
                                      style: TextStyle(
                                        fontSize:
                                            responsive.getBodyFontSize() - 1,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textLight,
                                      ),
                                    ),
                                    Text(
                                      '${data.value.toStringAsFixed(0)} (${percentage.toStringAsFixed(1)}%)',
                                      style: TextStyle(
                                        fontSize:
                                            responsive.getBodyFontSize() - 2,
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
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
