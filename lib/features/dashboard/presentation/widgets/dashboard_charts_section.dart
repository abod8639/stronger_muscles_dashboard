import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/config/responsive.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/enhanced_line_chart.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/presentation/controllers/dashboard_controller.dart';

/// قسم الرسوم البيانية للوحة التحكم بتصميم Neumorphism / Soft UI
class DashboardChartsSection extends GetView<DashboardController> {
  const DashboardChartsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final res = context.responsive;
    final isSmallScreen = res.isMobile;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // عنوان القسم مع مؤشر كبسولي ناعم
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.4),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'تحليل البيانات',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
        if (isSmallScreen)
          _buildChartCard(context, res, isDark)
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildChartCard(context, res, isDark)),
            ],
          ),
      ],
    );
  }

  Widget _buildChartCard(BuildContext context, ResponsiveLayout res, bool isDark) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final accentCyan = isDark ? const Color(0xFF22D3EE) : const Color(0xFF0891B2);

    return Container(
      padding: EdgeInsets.all(res.isMobile ? 18 : 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  Color.lerp(colorScheme.surfaceContainer, Colors.white, 0.035)!,
                  Color.lerp(colorScheme.surfaceContainer, Colors.black, 0.08)!,
                ]
              : [
                  Color.lerp(colorScheme.surfaceContainer, Colors.white, 0.65)!,
                  Color.lerp(colorScheme.surfaceContainer, Colors.black, 0.03)!,
                ],
        ),
        boxShadow: [
          // الظل السفلي الغامق (Drop Shadow)
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.60)
                : const Color(0xFFA3B1C6).withValues(alpha: 0.45),
            offset: const Offset(7, 8),
            blurRadius: 20,
            spreadRadius: 0,
          ),
          // الظل العلوي الفاتح العاكس للضوء (Highlight Glow)
          BoxShadow(
            color: isDark
                ? Colors.white.withValues(alpha: 0.045)
                : Colors.white.withValues(alpha: 0.95),
            offset: const Offset(-5, -5),
            blurRadius: 16,
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.white.withValues(alpha: 0.8),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // رأس البطاقة: العنوان + النطاق الزمني + أيقونة مجسمة
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'اتجاه الطلبات',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Obx(
                      () => Text(
                        controller.ordersChartData.periodSubtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.75),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // أيقونة مجسمة بأسلوب Soft UI
              Container(
                width: 44,
                height: 44,
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
                    Icons.trending_up_rounded,
                    color: accentCyan,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),

          // فاصل محفور غائر (Debossed Neumorphic Groove)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 1,
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.45)
                      : const Color(0xFFA3B1C6).withValues(alpha: 0.35),
                ),
                Container(
                  height: 1,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.white.withValues(alpha: 0.85),
                ),
              ],
            ),
          ),

          // حوض الرسم البياني الداخلي الغائر (Recessed Chart Bed)
          Container(
            padding: const EdgeInsets.fromLTRB(14, 18, 14, 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        Color.lerp(colorScheme.surfaceContainer, Colors.black, 0.16)!,
                        Color.lerp(colorScheme.surfaceContainer, Colors.black, 0.08)!,
                      ]
                    : [
                        Color.lerp(colorScheme.surfaceContainer, Colors.black, 0.04)!,
                        Colors.white.withValues(alpha: 0.6),
                      ],
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.4)
                      : const Color(0xFFA3B1C6).withValues(alpha: 0.25),
                  offset: const Offset(2, 2),
                  blurRadius: 4,
                ),
                BoxShadow(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.03)
                      : Colors.white.withValues(alpha: 0.7),
                  offset: const Offset(-1.5, -1.5),
                  blurRadius: 3,
                ),
              ],
              border: Border.all(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.4)
                    : const Color(0xFFA3B1C6).withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: SizedBox(
              height: 290,
              child: Obx(() {
                final chartData = controller.ordersChartData;
                return EnhancedLineChartWidget(
                  title: '',
                  spots: chartData.spots,
                  bottomTitles: chartData.bottomTitles,
                  bottomTitleInterval: chartData.bottomTitleInterval,
                  horizontalInterval: chartData.interval,
                  lineColor: accentCyan,
                  gradientColor: accentCyan,
                  maxY: chartData.maxY,
                  isEmbedded: true,
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
