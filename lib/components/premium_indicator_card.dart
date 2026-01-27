import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../config/app_colors.dart';

/// بطاقة مؤشر علوية احترافية مع رسم بياني صغير
class PremiumIndicatorCard extends StatefulWidget {
  final String title;
  final String value;
  final String? subtitle;
  final String trend;
  final bool trendUp;
  final List<FlSpot>? chartSpots;
  final Color accentColor;
  final IconData? icon;

  const PremiumIndicatorCard({
    Key? key,
    required this.title,
    required this.value,
    this.subtitle,
    required this.trend,
    required this.trendUp,
    this.chartSpots,
    required this.accentColor,
    this.icon,
  }) : super(key: key);

  @override
  State<PremiumIndicatorCard> createState() => _PremiumIndicatorCardState();
}

class _PremiumIndicatorCardState extends State<PremiumIndicatorCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onHoverEnter() {
    setState(() => _isHovered = true);
    _animationController.forward();
  }

  void _onHoverExit() {
    setState(() => _isHovered = false);
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHoverEnter(),
      onExit: (_) => _onHoverExit(),
      child: ScaleTransition(
        scale: Tween<double>(begin: 1.0, end: 1.03)
            .animate(_animationController),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.accentColor.withValues(alpha: 0.15),
                widget.accentColor.withValues(alpha: 0.02),
              ],
            ),
            border: Border.all(
              color: widget.accentColor
                  .withValues(alpha: _isHovered ? 0.5 : 0.2),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.accentColor
                    .withValues(alpha: _isHovered ? 0.3 : 0.1),
                blurRadius: _isHovered ? 35 : 20,
                offset: const Offset(0, 10),
                spreadRadius: _isHovered ? 3 : 1,
              ),
              BoxShadow(
                color: widget.accentColor
                    .withValues(alpha: _isHovered ? 0.15 : 0.05),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColorsExtended.textSecondary,
                          letterSpacing: 0.5,
                        ),
                      ),
                      if (widget.subtitle != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            widget.subtitle!,
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColorsExtended.textMuted,
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (widget.icon != null)
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: widget.accentColor
                            .withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: widget.accentColor
                              .withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        widget.icon,
                        color: widget.accentColor,
                        size: 22,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),

              // Value and Trend
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reward Rate',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColorsExtended.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.value,
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.w900,
                          color: widget.accentColor,
                          letterSpacing: -1.5,
                        ),
                      ),
                    ],
                  ),
                  // Trend
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: (widget.trendUp
                              ? AppColorsExtended.greenAccent
                              : AppColorsExtended.redAccent)
                          .withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: (widget.trendUp
                                ? AppColorsExtended.greenAccent
                                : AppColorsExtended.redAccent)
                            .withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          widget.trendUp
                              ? Icons.trending_up
                              : Icons.trending_down,
                          color: widget.trendUp
                              ? AppColorsExtended.greenAccent
                              : AppColorsExtended.redAccent,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          widget.trend,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: widget.trendUp
                                ? AppColorsExtended.greenAccent
                                : AppColorsExtended.redAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Mini Chart
              if (widget.chartSpots != null && widget.chartSpots!.isNotEmpty)
                SizedBox(
                  height: 60,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: widget.chartSpots!,
                          isCurved: true,
                          color: widget.accentColor,
                          barWidth: 2.5,
                          isStrokeCapRound: true,
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                widget.accentColor
                                    .withValues(alpha: 0.3),
                                widget.accentColor
                                    .withValues(alpha: 0.0),
                              ],
                            ),
                          ),
                        ),
                      ],
                      minX: 0,
                      maxX: widget.chartSpots!.length.toDouble() - 1,
                      minY: 0,
                      maxY: 100,
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
