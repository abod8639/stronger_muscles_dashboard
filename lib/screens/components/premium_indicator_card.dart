import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:stronger_muscles_dashboard/screens/components/glass_container.dart';

class PremiumIndicatorCard extends StatefulWidget {
  final String title;
  final String value;
  final String? subtitle;
  final String trend;
  final bool trendUp;
  final List<FlSpot>? chartSpots;
  final Color accentColor;
  final IconData? icon;
  final Color? chartColor;

  const PremiumIndicatorCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    required this.trend,
    required this.trendUp,
    this.chartSpots,
    required this.accentColor,
    this.icon,
    this.chartColor,
  });

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
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _animationController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _animationController.reverse();
      },
      child: GlassContainer(
        opacity: _isHovered ? 0.12 : 0.07,
        padding: const EdgeInsets.all(0),
        blur: 20,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: _isHovered
              ? widget.accentColor.withOpacity(0.5)
              : Colors.white.withOpacity(0.1),
          width: 1.5,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            widget.accentColor.withOpacity(0.15),
            Colors.white.withOpacity(0.02),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Icon + Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [_buildIconHeader(), _buildTrendBadge()],
              ),
              const SizedBox(height: 20),
      
              // Title & Subtitle
              Text(
                widget.title.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Colors.white.withOpacity(0.5),
                  letterSpacing: 1.5,
                ),
              ),
              if (widget.subtitle != null)
                Text(
                  widget.subtitle!,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
      
              const SizedBox(height: 12),
      
              // Value with Gradient Mask
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    Colors.white,
                    (widget.chartColor ?? widget.accentColor).withOpacity(0.7),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ).createShader(bounds),
                child: Text(
                  widget.value,
                  style: const TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -1,
                  ),
                ),
              ),
      
              const Spacer(),
      
              // Mini Chart with Area Glow
              if (widget.chartSpots != null && widget.chartSpots!.isNotEmpty)
                SizedBox(height: 35, child: LineChart(_buildChartData())),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconHeader() {
    final Color iconColor = widget.chartColor ?? widget.accentColor;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.09),
        shape: BoxShape.circle,
        border: Border.all(color: iconColor.withOpacity(0.2)),
      ),
      child: Icon(
        widget.icon ?? Icons.analytics,
        color: iconColor,
        size: 20,
      ),
    );
  }

  Widget _buildTrendBadge() {
    final Color trendColor = widget.trendUp
        ? Colors.greenAccent
        : Colors.redAccent;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: trendColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: trendColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(
            widget.trendUp ? Icons.north_east : Icons.south_east,
            color: trendColor,
            size: 12,
          ),
          const SizedBox(width: 4),
          Text(
            widget.trend,
            style: TextStyle(
              color: trendColor,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  LineChartData _buildChartData() {
    final Color chartColor = widget.chartColor ?? widget.accentColor;
    return LineChartData(
      gridData: const FlGridData(show: false),
      titlesData: const FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: widget.chartSpots ?? [],
          isCurved: true,
          color: chartColor,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                chartColor.withOpacity(0.3),
                widget.accentColor.withOpacity(0.0),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

