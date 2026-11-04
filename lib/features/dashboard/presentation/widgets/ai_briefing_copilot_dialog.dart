import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles_dashboard/core/utils/ui_feedback.dart';
import '../../domain/entities/ai_executive_briefing_entity.dart';
import '../../domain/entities/dashboard_stats_entity.dart';
import '../controllers/dashboard_providers.dart';

class AiBriefingCopilotDialog extends ConsumerStatefulWidget {
  final AiExecutiveBriefingEntity briefing;
  final DashboardStatsEntity stats;

  const AiBriefingCopilotDialog({
    super.key,
    required this.briefing,
    required this.stats,
  });

  static Future<void> show({
    required BuildContext context,
    required AiExecutiveBriefingEntity briefing,
    required DashboardStatsEntity stats,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => AiBriefingCopilotDialog(
        briefing: briefing,
        stats: stats,
      ),
    );
  }

  @override
  ConsumerState<AiBriefingCopilotDialog> createState() =>
      _AiBriefingCopilotDialogState();
}

class _AiBriefingCopilotDialogState
    extends ConsumerState<AiBriefingCopilotDialog> {
  final TextEditingController _questionController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = false;
  String? _lastQuestion;
  String? _answer;
  String? _errorMessage;

  static const List<String> _suggestedPrompts = [
    'كيف نسرّع تأكيد ومعالجة الطلبات المعلقة؟',
    'ما هي أفضل خطة لتنشيط مبيعات المنتجات التي لم تُطلب؟',
    'ما سبب ارتفاع الإلغاء وكيف نخفض معدل التراجع؟',
    'ما هي أولوية التدخل العاجل للمخزون اليوم؟',
    'كيف يمكننا رفع متوسط قيمة سلة المشتريات (AOV)؟',
  ];

  @override
  void dispose() {
    _questionController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _askQuestion(String question) async {
    final cleanQuestion = question.trim();
    if (cleanQuestion.isEmpty) return;

    setState(() {
      _isLoading = true;
      _lastQuestion = cleanQuestion;
      _answer = null;
      _errorMessage = null;
    });

    final useCase = ref.read(askAiExecutiveCopilotUseCaseProvider);
    final result = await useCase(
      briefing: widget.briefing,
      stats: widget.stats,
      question: cleanQuestion,
    );

    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() {
          _isLoading = false;
          _errorMessage = failure.toMessage();
        });
      },
      (answer) {
        setState(() {
          _isLoading = false;
          _answer = answer;
        });
        // Scroll to answer smoothly
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680, maxHeight: 720),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.primary.withValues(alpha: 0.25),
                          colorScheme.tertiary.withValues(alpha: 0.2),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.auto_awesome_rounded,
                      color: colorScheme.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'المساعد التنفيذي الذكي (AI Copilot)',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'استشر Gemini مباشرة حول تفاصيل التقرير والأداء التشغيلي',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                    tooltip: 'إغلاق',
                  ),
                ],
              ),

              const SizedBox(height: 14),
              const Divider(height: 1),
              const SizedBox(height: 14),

              // Content Area (Scrollable)
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  children: [
                    // Suggestions section
                    Text(
                      'أسئلة مقترحة سريعة:',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final prompt in _suggestedPrompts)
                          ActionChip(
                            label: Text(prompt),
                            avatar: Icon(
                              Icons.psychology_outlined,
                              size: 15,
                              color: colorScheme.primary,
                            ),
                            labelStyle: TextStyle(
                              fontSize: 11.5,
                              color: colorScheme.onSurface,
                            ),
                            backgroundColor: colorScheme
                                .surfaceContainerHighest
                                .withValues(alpha: isDark ? 0.3 : 0.5),
                            side: BorderSide(
                              color: colorScheme.outlineVariant
                                  .withValues(alpha: 0.3),
                            ),
                            onPressed: _isLoading
                                ? null
                                : () {
                                    _questionController.text = prompt;
                                    _askQuestion(prompt);
                                  },
                          ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // Active Q&A block if exists
                    if (_lastQuestion != null) ...[
                      // Question Box
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer.withValues(
                            alpha: isDark ? 0.25 : 0.35,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: colorScheme.primary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.help_outline_rounded,
                              size: 18,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _lastQuestion!,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    if (_isLoading) ...[
                      Container(
                        padding: const EdgeInsets.all(20),
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            const SizedBox(
                              width: 28,
                              height: 28,
                              child: CircularProgressIndicator(strokeWidth: 2.5),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Gemini يحلل أرقام المتجر ومؤشرات الأداء للإجابة...',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else if (_errorMessage != null) ...[
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: colorScheme.errorContainer.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: colorScheme.error.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline_rounded,
                                color: colorScheme.error, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else if (_answer != null) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest.withValues(
                            alpha: isDark ? 0.3 : 0.45,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: colorScheme.outlineVariant
                                .withValues(alpha: 0.4),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.lightbulb_rounded,
                                  color: Colors.amber.shade700,
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'توصية وتحليل المساعد التنفيذي:',
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  icon: const Icon(Icons.copy_rounded, size: 16),
                                  tooltip: 'نسخ الإجابة',
                                  visualDensity: VisualDensity.compact,
                                  onPressed: () {
                                    Clipboard.setData(
                                      ClipboardData(text: _answer!),
                                    );
                                    AppFeedback.showSuccess(
                                      'تم نسخ الإجابة إلى الحافظة',
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            SelectableText(
                              _answer!,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                height: 1.6,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),

              // Input row
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _questionController,
                      enabled: !_isLoading,
                      textInputAction: TextInputAction.send,
                      onSubmitted: _askQuestion,
                      decoration: InputDecoration(
                        hintText: 'اكتب سؤالك التنفيذي هنا...',
                        hintStyle: TextStyle(
                          fontSize: 12.5,
                          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                        ),
                        isDense: true,
                        filled: true,
                        fillColor: colorScheme.surfaceContainerHighest
                            .withValues(alpha: isDark ? 0.3 : 0.4),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: colorScheme.primary,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  FilledButton.icon(
                    onPressed: _isLoading
                        ? null
                        : () => _askQuestion(_questionController.text),
                    icon: _isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.send_rounded, size: 18),
                    label: const Text('إرسال'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

