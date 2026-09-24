import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// بطاقة مؤشر وإحصائيات متوافقة بالكامل مع مواصفات وتصميم Material Design 3
/// تدعم السمات الفاتحة والداكنة ديناميكياً وتوفر تفاعلية وانتقالات بصرية سلسة.
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final Color effectiveAccent = widget.chartColor ?? widget.accentColor;
    final hasChart = widget.chartSpots != null && widget.chartSpots!.isNotEmpty;

    // ألوان مؤشر الاتجاه (Trend) وفق معايير Material 3
    final Color trendColor = widget.trendUp
        ? (isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A))
        : (isDark ? const Color(0xFFF87171) : const Color(0xFFDC2626));

    final Color trendBg = trendColor.withValues(alpha: isDark ? 0.16 : 0.10);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: AnimatedScale(
        scale: _isHovered ? 1.015 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: _isHovered
                ? colorScheme.surfaceContainer
                : colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: _isHovered
                  ? effectiveAccent.withValues(alpha: 0.45)
                  : colorScheme.outlineVariant.withValues(alpha: 0.45),
              width: _isHovered ? 1.4 : 1.0,
            ),
            boxShadow: [
              if (_isHovered)
                BoxShadow(
                  color: effectiveAccent.withValues(alpha: 0.12),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                )
              else
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: isDark ? 0.25 : 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                effectiveAccent.withValues(alpha: _isHovered ? 0.10 : 0.04),
                colorScheme.surfaceContainerLow.withValues(alpha: 0.0),
              ],
            ),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: BorderRadius.circular(24),
              hoverColor: Colors.transparent,
              splashColor: effectiveAccent.withValues(alpha: 0.08),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // الرأس: الأيقونة + شارة الاتجاه المنسقة بنمط M3 Badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildM3IconBadge(effectiveAccent),
                        _buildM3TrendBadge(trendColor, trendBg),
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

                    // القيمة الرئيسية (Adaptive Typography)
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

  /// حاوية أيقونة بتصميم Material 3 Tonal Container
  Widget _buildM3IconBadge(Color accent) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: accent.withValues(alpha: 0.20),
          width: 1,
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

  /// شارة الاتجاه والنمو بنمط M3 Capsule Chip
  Widget _buildM3TrendBadge(Color trendColor, Color trendBg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: trendBg,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: trendColor.withValues(alpha: 0.25),
          width: 1,
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

  /// إعدادات الرسم البياني المصغر بنمط M3 التفاعلي
  LineChartData _buildChartData(Color chartColor) {
    return LineChartData(
      gridData: const FlGridData(show: false),
      titlesData: const FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      lineTouchData: const LineTouchData(enabled: false),
      lineBarsData: [
        LineChartBarData(
          spots: widget.chartSpots ?? [],
          isCurved: true,
          curveSmoothness: 0.35,
          color: chartColor,
          barWidth: 2.5,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                chartColor.withValues(alpha: 0.25),
                chartColor.withValues(alpha: 0.0),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
