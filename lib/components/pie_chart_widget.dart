import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../config/theme.dart';
import '../config/responsive.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final totalValue = widget.data.fold<double>(0, (sum, item) => sum + item.value);

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
                                Shadow(
                                  color: Colors.black26,
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                            color: data.color,
                            badgeWidget: isTouched
                                ? Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: data.color.withValues(alpha: 0.4),
                                          spreadRadius: 2,
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.all(6),
                                    child: Text(
                                      data.value.toStringAsFixed(0),
                                      style: TextStyle(
                                        color: data.color,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
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
                          padding: EdgeInsets.only(bottom: responsive.itemSpacing),
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
                                      color: data.color.withValues(alpha: 0.3),
                                      blurRadius: 4,
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
                                        fontSize: responsive.getBodyFontSize() - 1,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textDark,
                                      ),
                                    ),
                                    Text(
                                      '${data.value.toStringAsFixed(0)} (${percentage.toStringAsFixed(1)}%)',
                                      style: TextStyle(
                                        fontSize: responsive.getBodyFontSize() - 2,
                                        color: AppColors.textLight,
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
