import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// بطاقة مؤشر وإحصائيات بتصميم Neumorphism / Soft UI
/// تدعم السمات الفاتحة والداكنة ديناميكياً مع ظلال ناعمة مزدوجة وتفاعل حركي ملموس.
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
  final VoidCallback? onTap;

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
    this.onTap,
  });

  @override
  State<PremiumIndicatorCard> createState() => _PremiumIndicatorCardState();
}

class _PremiumIndicatorCardState extends State<PremiumIndicatorCard> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final Color effectiveAccent = widget.chartColor ?? widget.accentColor;
    final hasChart = widget.chartSpots != null && widget.chartSpots!.isNotEmpty;

    // ألوان مؤشر الاتجاه (Trend)
    final Color trendColor = widget.trendUp
        ? (isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A))
        : (isDark ? const Color(0xFFF87171) : const Color(0xFFDC2626));

    final double currentScale = _isPressed
        ? 0.985
        : (_isHovered ? 1.015 : 1.0);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTapDown: widget.onTap != null ? (_) => setState(() => _isPressed = true) : null,
        onTapUp: widget.onTap != null
            ? (_) {
                setState(() => _isPressed = false);
                widget.onTap?.call();
              }
            : null,
        onTapCancel: widget.onTap != null ? () => setState(() => _isPressed = false) : null,
        child: AnimatedScale(
          scale: currentScale,
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        Color.lerp(colorScheme.surfaceContainer, Colors.white, _isHovered ? 0.05 : 0.03)!,
                        Color.lerp(colorScheme.surfaceContainer, Colors.black, _isHovered ? 0.05 : 0.09)!,
                      ]
                    : [
                        Color.lerp(colorScheme.surfaceContainer, Colors.white, _isHovered ? 0.75 : 0.65)!,
                        Color.lerp(colorScheme.surfaceContainer, Colors.black, _isHovered ? 0.01 : 0.035)!,
                      ],
              ),
              boxShadow: _isPressed
                  ? [
                      // في حالة الضغط، تتراجع الظلال لمحاكاة الانضغاط للداخل
                      BoxShadow(
                        color: isDark
                            ? Colors.black.withValues(alpha: 0.3)
                            : const Color(0xFFA3B1C6).withValues(alpha: 0.25),
                        offset: const Offset(2, 3),
                        blurRadius: 6,
                      ),
                    ]
                  : [
                      // الظل السفلي الغامق (Drop Shadow)
                      BoxShadow(
                        color: isDark
                            ? Colors.black.withValues(alpha: _isHovered ? 0.65 : 0.55)
                            : const Color(0xFFA3B1C6).withValues(alpha: _isHovered ? 0.55 : 0.42),
                        offset: _isHovered ? const Offset(7, 9) : const Offset(5, 7),
                        blurRadius: _isHovered ? 20 : 16,
                        spreadRadius: 0,
                      ),
                      // الظل العلوي الفاتح العاكس للضوء (Highlight Glow)
                      BoxShadow(
                        color: isDark
                            ? Colors.white.withValues(alpha: _isHovered ? 0.06 : 0.04)
                            : Colors.white.withValues(alpha: _isHovered ? 1.0 : 0.95),
                        offset: _isHovered ? const Offset(-5, -5) : const Offset(-4, -4),
                        blurRadius: _isHovered ? 16 : 12,
                        spreadRadius: 0,
                      ),
                      // وهج ناعم بلون العنصر عند التحويم
                      if (_isHovered)
                        BoxShadow(
                          color: effectiveAccent.withValues(alpha: isDark ? 0.12 : 0.15),
                          offset: const Offset(0, 4),
                          blurRadius: 18,
                          spreadRadius: -2,
                        ),
                    ],
              border: Border.all(
                color: isDark
                    ? (_isHovered
                        ? effectiveAccent.withValues(alpha: 0.35)
                        : Colors.white.withValues(alpha: 0.06))
                    : (_isHovered
                        ? effectiveAccent.withValues(alpha: 0.4)
                        : Colors.white.withValues(alpha: 0.85)),
                width: _isHovered ? 1.4 : 1.1,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(24),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // الرأس: الأيقونة المجسمة + شارة الاتجاه الناعمة
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildNeumorphicIconBadge(effectiveAccent, colorScheme, isDark),
                        _buildNeumorphicTrendBadge(trendColor, colorScheme, isDark),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // العنوان والوصف الفرعي
                    Text(
                      widget.title,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.4,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (widget.subtitle != null && widget.subtitle!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        widget.subtitle!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant.withValues(alpha: .7),
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],

                    const SizedBox(height: 6),

                    // القيمة الرئيسية
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.value,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: colorScheme.onSurface,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),

                    // الرسم البياني المصغر (Sparkline)
                    if (hasChart) ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 38,
                        child: LineChart(_buildChartData(effectiveAccent)),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// حاوية أيقونة مجسمة بأسلوب Soft UI
  Widget _buildNeumorphicIconBadge(
    Color accent,
    ColorScheme colorScheme,
    bool isDark,
  ) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  Color.lerp(colorScheme.surfaceContainerHigh, Colors.white, 0.04)!,
                  Color.lerp(colorScheme.surfaceContainer, Colors.black, 0.12)!,
                ]
              : [
                  Colors.white,
                  Color.lerp(colorScheme.surfaceContainer, Colors.black, 0.04)!,
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.5)
                : const Color(0xFFA3B1C6).withValues(alpha: 0.4),
            offset: const Offset(2.5, 3),
            blurRadius: 6,
          ),
          BoxShadow(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.white.withValues(alpha: 0.9),
            offset: const Offset(-2, -2),
            blurRadius: 5,
          ),
        ],
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.white.withValues(alpha: 0.8),
          width: 1.0,
        ),
      ),
      child: Center(
        child: Icon(
          widget.icon ?? Icons.analytics_rounded,
          color: accent,
          size: 20,
        ),
      ),
    );
  }

  /// شارة الاتجاه والنمو بنمط Neumorphic Pill
  Widget _buildNeumorphicTrendBadge(
    Color trendColor,
    ColorScheme colorScheme,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  Color.lerp(colorScheme.surfaceContainerHigh, trendColor, 0.12)!,
                  Color.lerp(colorScheme.surfaceContainer, trendColor, 0.06)!,
                ]
              : [
                  Color.lerp(Colors.white, trendColor, 0.08)!,
                  Color.lerp(colorScheme.surfaceContainer, trendColor, 0.12)!,
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.35)
                : const Color(0xFFA3B1C6).withValues(alpha: 0.3),
            offset: const Offset(1.5, 2),
            blurRadius: 4,
          ),
          BoxShadow(
            color: isDark
                ? Colors.white.withValues(alpha: 0.04)
                : Colors.white.withValues(alpha: 0.8),
            offset: const Offset(-1.5, -1.5),
            blurRadius: 3,
          ),
        ],
        border: Border.all(
          color: trendColor.withValues(alpha: isDark ? 0.3 : 0.35),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            widget.trendUp ? Icons.arrow_outward_rounded : Icons.south_east_rounded,
            color: trendColor,
            size: 13,
          ),
          const SizedBox(width: 4),
          Text(
            widget.trend,
            style: TextStyle(
              color: trendColor,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  /// إعدادات الرسم البياني المصغر بنمط Sparkline ناعم ومتوهج
  LineChartData _buildChartData(Color chartColor) {
    final spots = widget.chartSpots ?? [];
    double minY = 0.0;
    double maxY = 4.0;

    if (spots.isNotEmpty) {
      final yValues = spots.map((s) => s.y).toList();
      final maxVal = yValues.reduce(math.max);
      final minVal = yValues.reduce(math.min);
      minY = minVal < 0 ? minVal : 0.0;
      maxY = maxVal <= minY ? (minY + 4.0) : (maxVal * 1.25);
    }

    final maxX = spots.isEmpty
        ? 1.0
        : (spots.length <= 1 ? 1.0 : (spots.length - 1).toDouble());

    return LineChartData(
      minY: minY,
      maxY: maxY,
      minX: 0.0,
      maxX: maxX,
      gridData: const FlGridData(show: false),
      titlesData: const FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      lineTouchData: const LineTouchData(enabled: false),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: spots.length >= 2,
          preventCurveOverShooting: true,
          curveSmoothness: 0.35,
          color: chartColor,
          barWidth: 2.5,
          isStrokeCapRound: true,
          shadow: Shadow(
            color: chartColor.withValues(alpha: 0.35),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                chartColor.withValues(alpha: 0.28),
                chartColor.withValues(alpha: 0.0),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
