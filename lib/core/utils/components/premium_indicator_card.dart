import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/theme/responsive.dart';

/// بطاقة مؤشر وإحصائيات بتصميم Neumorphism / Soft UI
/// متوافقة بالكامل مع شاشات الهواتف والحواسب وتدعم الاتجاهات (RTL/LTR) والسمات الفاتحة والداكنة
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
    final isMobile = context.isMobile;

    final Color effectiveAccent = widget.chartColor ?? widget.accentColor;
    final hasChart = widget.chartSpots != null && widget.chartSpots!.isNotEmpty;

    // ألوان مؤشر الاتجاه (Trend)
    final Color trendColor = widget.trendUp
        ? (isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A))
        : (isDark ? const Color(0xFFF87171) : const Color(0xFFDC2626));

    final double currentScale = _isPressed
        ? 0.985
        : (_isHovered ? 1.015 : 1.0);

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;
        final cardHeight = constraints.maxHeight;

        // تحديد ما إذا كانت البطاقة في حاوية مدمجة أو هاتف
        final isNarrow = cardWidth < 220;
        final isCompact = isMobile || isNarrow;
        final isVeryCompact = cardWidth < 165;

        final double hPadding = isVeryCompact ? 10.0 : (isCompact ? 12.0 : 16.0);
        final double vPadding = isVeryCompact ? 6.0 : (isCompact ? 8.0 : 12.0);
        final double borderRadiusValue = isCompact ? 16.0 : 20.0;

        final double iconBadgeSize = isVeryCompact ? 30.0 : (isCompact ? 32.0 : 38.0);
        final double iconSize = isVeryCompact ? 15.0 : (isCompact ? 16.0 : 19.0);

        final double trendHPad = isVeryCompact ? 5.5 : (isCompact ? 7.0 : 9.0);
        final double trendVPad = isVeryCompact ? 2.0 : (isCompact ? 2.5 : 3.5);
        final double trendFontSize = isVeryCompact ? 9.0 : (isCompact ? 10.0 : 11.0);
        final double trendIconSize = isVeryCompact ? 10.0 : (isCompact ? 11.0 : 12.0);

        final double titleFontSize = isVeryCompact ? 10.5 : (isCompact ? 11.5 : 13.0);
        final double valueFontSize = isVeryCompact ? 17.0 : (isCompact ? 19.0 : 23.0);
        final double chartHeight = isVeryCompact ? 20.0 : (isCompact ? 24.0 : 32.0);

        Widget content = Padding(
          padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: vPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. الرأس: الأيقونة المجسمة + شارة الاتجاه
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildNeumorphicIconBadge(
                    effectiveAccent,
                    colorScheme,
                    isDark,
                    size: iconBadgeSize,
                    iconSize: iconSize,
                  ),
                  Flexible(
                    child: _buildNeumorphicTrendBadge(
                      trendColor,
                      colorScheme,
                      isDark,
                      hPad: trendHPad,
                      vPad: trendVPad,
                      fontSize: trendFontSize,
                      iconSize: trendIconSize,
                    ),
                  ),
                ],
              ),

              SizedBox(height: isCompact ? 5 : 8),

              // 2. العنوان والوصف الفرعي
              Text(
                widget.title,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                  fontSize: titleFontSize,
                  letterSpacing: 0.3,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              if (widget.subtitle != null && widget.subtitle!.isNotEmpty && !isVeryCompact) ...[
                const SizedBox(height: 1),
                Text(
                  widget.subtitle!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: .7),
                    fontSize: isCompact ? 10 : 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              SizedBox(height: isCompact ? 2 : 4),

              // 3. القيمة الرئيسية (محاذاة البداية Directional لتدعم العربية والإنجليزية)
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  widget.value,
                  style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: colorScheme.onSurface,
                        fontSize: valueFontSize,
                        letterSpacing: -0.5,
                      ) ??
                      TextStyle(
                        fontWeight: FontWeight.w900,
                        color: colorScheme.onSurface,
                        fontSize: valueFontSize,
                      ),
                ),
              ),

              // 4. الرسم البياني المصغر (Sparkline)
              if (hasChart) ...[
                SizedBox(height: isCompact ? 4 : 8),
                SizedBox(
                  height: chartHeight,
                  child: LineChart(_buildChartData(effectiveAccent)),
                ),
              ],
            ],
          ),
        );

        // حماية البطاقة بشكل مطلق من أي Overflow في حال وجود أي قيود ارتفاع
        if (cardHeight.isFinite) {
          content = SizedBox(
            height: cardHeight,
            width: cardWidth,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.center,
              child: SizedBox(
                width: cardWidth,
                child: content,
              ),
            ),
          );
        }

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
                  borderRadius: BorderRadius.circular(borderRadiusValue),
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
                          BoxShadow(
                            color: isDark
                                ? Colors.black.withValues(alpha: 0.3)
                                : const Color(0xFFA3B1C6).withValues(alpha: 0.25),
                            offset: const Offset(2, 2.5),
                            blurRadius: 5,
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: isDark
                                ? Colors.black.withValues(alpha: _isHovered ? 0.65 : 0.55)
                                : const Color(0xFFA3B1C6).withValues(alpha: _isHovered ? 0.55 : 0.42),
                            offset: _isHovered ? const Offset(6, 8) : const Offset(4, 6),
                            blurRadius: _isHovered ? 18 : 14,
                            spreadRadius: 0,
                          ),
                          BoxShadow(
                            color: isDark
                                ? Colors.white.withValues(alpha: _isHovered ? 0.06 : 0.04)
                                : Colors.white.withValues(alpha: _isHovered ? 1.0 : 0.95),
                            offset: _isHovered ? const Offset(-4, -4) : const Offset(-3, -3),
                            blurRadius: _isHovered ? 14 : 10,
                            spreadRadius: 0,
                          ),
                          if (_isHovered)
                            BoxShadow(
                              color: effectiveAccent.withValues(alpha: isDark ? 0.12 : 0.15),
                              offset: const Offset(0, 4),
                              blurRadius: 16,
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
                    width: _isHovered ? 1.3 : 1.0,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(borderRadiusValue),
                  child: content,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// حاوية أيقونة مجسمة بأسلوب Soft UI متجاوبة
  Widget _buildNeumorphicIconBadge(
    Color accent,
    ColorScheme colorScheme,
    bool isDark, {
    required double size,
    required double iconSize,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.33),
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
            offset: const Offset(2, 2.5),
            blurRadius: 5,
          ),
          BoxShadow(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.white.withValues(alpha: 0.9),
            offset: const Offset(-1.5, -1.5),
            blurRadius: 4,
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
          size: iconSize,
        ),
      ),
    );
  }

  /// شارة الاتجاه والنمو بنمط Neumorphic Pill متجاوبة
  Widget _buildNeumorphicTrendBadge(
    Color trendColor,
    ColorScheme colorScheme,
    bool isDark, {
    required double hPad,
    required double vPad,
    required double fontSize,
    required double iconSize,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
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
            blurRadius: 3.5,
          ),
          BoxShadow(
            color: isDark
                ? Colors.white.withValues(alpha: 0.04)
                : Colors.white.withValues(alpha: 0.8),
            offset: const Offset(-1.5, -1.5),
            blurRadius: 2.5,
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
            size: iconSize,
          ),
          const SizedBox(width: 3),
          Text(
            widget.trend,
            style: TextStyle(
              color: trendColor,
              fontSize: fontSize,
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
          barWidth: 2.2,
          isStrokeCapRound: true,
          shadow: Shadow(
            color: chartColor.withValues(alpha: 0.35),
            blurRadius: 5,
            offset: const Offset(0, 1.5),
          ),
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
