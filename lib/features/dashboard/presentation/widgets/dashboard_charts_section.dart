import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/core/components/enhanced_line_chart.dart';
import 'package:stronger_muscles_dashboard/core/components/section_card.dart';
import 'package:stronger_muscles_dashboard/core/components/section_header.dart';
import 'package:stronger_muscles_dashboard/core/components/soft_surface.dart';
import 'package:stronger_muscles_dashboard/core/theme/responsive.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';
import 'package:stronger_muscles_dashboard/features/dashboard/presentation/controllers/dashboard_providers.dart';

/// قسم الرسوم البيانية: منحنى اتجاه الطلبات للفترة المختارة
class DashboardChartsSection extends ConsumerWidget {
  const DashboardChartsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chartData = ref.watch(ordersChartDataProvider);
    const lineColor = AppColors.info;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(title: 'تحليل البيانات'),
        SectionCard(
          title: 'اتجاه الطلبات',
          subtitle: chartData.periodSubtitle,
          icon: Icons.trending_up_rounded,
          child: SoftSurface(
            depth: SoftDepth.inset,
            borderRadius: AppDesignTokens.radiusLarge,
            padding: const EdgeInsets.fromLTRB(14, 18, 14, 10),
            child: SizedBox(
              height: context.isMobile ? 240 : 290,
              child: EnhancedLineChartWidget(
                title: '',
                spots: chartData.spots,
                bottomTitles: chartData.bottomTitles,
                bottomTitleInterval: chartData.bottomTitleInterval,
                horizontalInterval: chartData.interval,
                lineColor: lineColor,
                gradientColor: lineColor,
                maxY: chartData.maxY,
                isEmbedded: true,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
