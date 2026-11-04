import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:stronger_muscles_dashboard/core/theme/responsive.dart';
import '../../domain/entities/ai_executive_briefing_entity.dart';
import '../controllers/dashboard_providers.dart';
import 'stock_radar_details_modal.dart';

/// بطاقة التقرير التنفيذي اليومي ورادار المخزون الذكي مدعومة بـ Google Gemini AI
class AiExecutiveBriefingCard extends ConsumerStatefulWidget {
  const AiExecutiveBriefingCard({super.key});

  @override
  ConsumerState<AiExecutiveBriefingCard> createState() =>
      _AiExecutiveBriefingCardState();
}

class _AiExecutiveBriefingCardState
    extends ConsumerState<AiExecutiveBriefingCard> {
  bool _isExpanded = true;

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'الآن';
    if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
    if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';
    return DateFormat('yyyy/MM/dd - hh:mm a').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final isCompact = context.responsive.screenWidth < 750;

    final briefingAsync = ref.watch(aiExecutiveBriefingNotifierProvider);
    final stats = ref.watch(dashboardStatsNotifierProvider).value;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: isDark
            ? Color.lerp(colorScheme.surfaceContainer, Colors.black, 0.25)
            : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.primary.withValues(
            alpha: isDark ? 0.35 : 0.25,
          ),
          width: 1.2,
        ),
        boxShadow: isDark
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Accent Gradient Bar
            Container(
              height: 4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primary,
                    colorScheme.tertiary,
                    colorScheme.primary.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),

            // Card Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.primary,
                          colorScheme.tertiary,
                        ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.auto_awesome_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                'التقرير التنفيذي ورادار المخزون',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    colorScheme.primary.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Google Gemini AI',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        briefingAsync.maybeWhen(
                          data: (briefing) => briefing != null
                              ? Text(
                                  'آخر تحليل: ${_formatTime(briefing.generatedAt)} (${briefing.modelUsed})',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontSize: 11,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                )
                              : Text(
                                  'تحليلات استشرافية للمبيعات ورصد نفاد المخزون',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontSize: 11,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                          orElse: () => Text(
                            'تحليلات استشرافية للمبيعات ورصد نفاد المخزون',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 11,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Sentiment Pill
                  briefingAsync.maybeWhen(
                    data: (briefing) => briefing != null
                        ? Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: _buildSentimentPill(
                              briefing.sentiment,
                              colorScheme,
                            ),
                          )
                        : const SizedBox.shrink(),
                    orElse: () => const SizedBox.shrink(),
                  ),

                  // Refresh Button
                  IconButton(
                    icon: briefingAsync.isLoading
                        ? SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colorScheme.primary,
                            ),
                          )
                        : Icon(
                            Icons.refresh_rounded,
                            color: colorScheme.primary,
                            size: 20,
                          ),
                    tooltip: 'إعادة التحليل الآن بـ Gemini',
                    onPressed: briefingAsync.isLoading
                        ? null
                        : () => ref
                            .read(aiExecutiveBriefingNotifierProvider.notifier)
                            .refreshBriefing(force: true),
                  ),

                  // Collapse/Expand Button
                  IconButton(
                    icon: Icon(
                      _isExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    tooltip: _isExpanded ? 'طي البطاقة' : 'توسيع البطاقة',
                    onPressed: () =>
                        setState(() => _isExpanded = !_isExpanded),
                  ),
                ],
              ),
            ),

            // Card Body (Collapsible)
            if (_isExpanded)
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
                child: briefingAsync.when(
                  loading: () => _buildLoadingState(theme, colorScheme),
                  error: (err, _) =>
                      _buildErrorState(err.toString(), theme, colorScheme),
                  data: (briefing) {
                    if (briefing == null) {
                      return _buildInitialEmptyState(
                        theme,
                        colorScheme,
                        isCompact,
                      );
                    }
                    return _buildBriefingContent(
                      briefing,
                      theme,
                      colorScheme,
                      isDark,
                      isCompact,
                      stats?.products ?? const [],
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSentimentPill(String sentiment, ColorScheme colorScheme) {
    Color color;
    String label;
    IconData icon;

    switch (sentiment.toLowerCase()) {
      case 'positive':
        color = Colors.green.shade700;
        label = 'أداء إيجابي';
        icon = Icons.trending_up_rounded;
        break;
      case 'needs_attention':
        color = colorScheme.error;
        label = 'يتطلب الانتباه';
        icon = Icons.warning_amber_rounded;
        break;
      default:
        color = Colors.amber.shade800;
        label = 'أداء مستقر';
        icon = Icons.insights_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBriefingContent(
    AiExecutiveBriefingEntity briefing,
    ThemeData theme,
    ColorScheme colorScheme,
    bool isDark,
    bool isCompact,
    List<dynamic> allProducts,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 1),
        const SizedBox(height: 14),

        // 1. Executive Summary
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(
              alpha: isDark ? 0.35 : 0.5,
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.format_quote_rounded,
                color: colorScheme.primary,
                size: 22,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  briefing.summary,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.55,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // 2. Key Insights & Actionable Recommendations
        if (isCompact) ...[
          _buildInsightsSection(briefing.keyInsights, theme, colorScheme),
          const SizedBox(height: 12),
          _buildRecommendationsSection(
            briefing.actionableRecommendations,
            theme,
            colorScheme,
          ),
        ] else ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildInsightsSection(
                  briefing.keyInsights,
                  theme,
                  colorScheme,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildRecommendationsSection(
                  briefing.actionableRecommendations,
                  theme,
                  colorScheme,
                ),
              ),
            ],
          ),
        ],

        // 3. Stock Radar Section (if alerts exist)
        if (briefing.stockAlerts.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildStockRadarSection(
            briefing.stockAlerts,
            theme,
            colorScheme,
            isDark,
          ),
        ],
      ],
    );
  }

  Widget _buildInsightsSection(
    List<String> insights,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.lightbulb_outline_rounded,
                size: 16, color: colorScheme.primary),
            const SizedBox(width: 6),
            Text(
              'أهم الرؤى والمؤشرات:',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        for (final item in insights)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildRecommendationsSection(
    List<String> recommendations,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.task_alt_rounded,
                size: 16, color: Colors.teal.shade700),
            const SizedBox(width: 6),
            Text(
              'التوصيات التشغيلية المقترحة:',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.teal.shade700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        for (final item in recommendations)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.teal.shade700,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildStockRadarSection(
    List<StockRadarAlertEntity> alerts,
    ThemeData theme,
    ColorScheme colorScheme,
    bool isDark,
  ) {
    final criticalCount = alerts.where((a) => a.isOutOfStock || a.isCritical).length;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer.withValues(
          alpha: isDark ? 0.2 : 0.35,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colorScheme.error.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.radar_rounded, color: colorScheme.error, size: 18),
              const SizedBox(width: 8),
              Text(
                'رادار المخزون الذكي:',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.error,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: colorScheme.error,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '$criticalCount صنف حرج',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onError,
                  ),
                ),
              ),
              const Spacer(),
              TextButton.icon(
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  foregroundColor: colorScheme.error,
                ),
                onPressed: () {
                  final allProducts = ref
                          .read(dashboardStatsNotifierProvider)
                          .value
                          ?.products ??
                      const [];
                  StockRadarDetailsModal.show(
                    context: context,
                    alerts: alerts,
                    allProducts: allProducts,
                  );
                },
                icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                label: const Text('عرض التفاصيل'),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Top 2 alert highlights
          for (final alert in alerts.take(2))
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Icon(
                    alert.isOutOfStock
                        ? Icons.cancel_rounded
                        : Icons.warning_rounded,
                    size: 14,
                    color: alert.isOutOfStock
                        ? Colors.red.shade900
                        : colorScheme.error,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${alert.productName} (المتبقي: ${alert.currentStock}) - ${alert.suggestedAction}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 11.5,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(24),
      alignment: Alignment.center,
      child: Column(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'جاري تحليل مؤشرات المتجر واستشراف رادار المخزون بـ Gemini...',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(
    String message,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, color: colorScheme.error),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.error,
              ),
            ),
          ),
          TextButton(
            onPressed: () => ref
                .read(aiExecutiveBriefingNotifierProvider.notifier)
                .refreshBriefing(force: true),
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialEmptyState(
    ThemeData theme,
    ColorScheme colorScheme,
    bool isCompact,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(
            'احصل على تقرير تنفيذي متكامل لحالة المبيعات اليوم وتنبؤات رادار المخزون بضغطة زر واحدة',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => ref
                .read(aiExecutiveBriefingNotifierProvider.notifier)
                .refreshBriefing(force: true),
            icon: const Icon(Icons.auto_awesome_rounded, size: 18),
            label: const Text('توليد التقرير التنفيذي الآن ✨'),
          ),
        ],
      ),
    );
  }
}
