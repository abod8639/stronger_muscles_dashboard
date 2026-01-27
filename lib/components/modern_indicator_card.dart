import 'package:flutter/material.dart';
import '../../config/app_colors.dart';

/// مكون بطاقة مؤشر حديثة وجذابة جداً
class ModernIndicatorCard extends StatefulWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData? icon;
  final Color accentColor;
  final LinearGradient? gradient;
  final VoidCallback? onTap;
  final bool showTrend;
  final bool trendUp;
  final String? trendValue;

  const ModernIndicatorCard({
    Key? key,
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    required this.accentColor,
    this.gradient,
    this.onTap,
    this.showTrend = false,
    this.trendUp = true,
    this.trendValue,
  }) : super(key: key);

  @override
  State<ModernIndicatorCard> createState() => _ModernIndicatorCardState();
}

class _ModernIndicatorCardState extends State<ModernIndicatorCard>
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
      child: GestureDetector(
        onTap: widget.onTap,
        child: ScaleTransition(
          scale: Tween<double>(begin: 1.0, end: 1.02)
              .animate(_animationController),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              // تدرج خلفية احترافي
              gradient: widget.gradient ??
                  LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      widget.accentColor.withValues(alpha: 0.12),
                      widget.accentColor.withValues(alpha: 0.03),
                    ],
                  ),
              // حدود ملونة
              border: Border.all(
                color: widget.accentColor
                    .withValues(alpha: _isHovered ? 0.4 : 0.15),
                width: 2,
              ),
              // ظل احترافي
              boxShadow: [
                BoxShadow(
                  color: widget.accentColor
                      .withValues(alpha: _isHovered ? 0.25 : 0.08),
                  blurRadius: _isHovered ? 25 : 15,
                  offset: const Offset(0, 8),
                  spreadRadius: _isHovered ? 2 : 0,
                ),
              ],
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Header مع الأيقونة
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColorsExtended.textSecondary,
                              letterSpacing: 0.8,
                            ),
                          ),
                          if (widget.subtitle != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                widget.subtitle!,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColorsExtended.textMuted,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (widget.icon != null)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: widget.accentColor
                              .withValues(alpha: _isHovered ? 0.25 : 0.12),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: widget.accentColor
                                .withValues(alpha: _isHovered ? 0.3 : 0.1),
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          widget.icon,
                          color: widget.accentColor,
                          size: 20,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: _isHovered ? 20 : 16),

                // القيمة الرئيسية
                Text(
                  widget.value,
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w900,
                    color: widget.accentColor,
                    letterSpacing: -1,
                  ),
                ),

                // مؤشر الاتجاه
                if (widget.showTrend) ...[
                  SizedBox(height: _isHovered ? 16 : 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          widget.trendValue ?? '0%',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: widget.trendUp
                                ? AppColorsExtended.greenAccent
                                : AppColorsExtended.redAccent,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'من أمس',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColorsExtended.textMuted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
