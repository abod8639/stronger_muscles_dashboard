import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/utils/ui_feedback.dart';
import '../controllers/products_controller.dart';
import 'ai_autofill_dialog.dart';

/// A modern, prominent AI action button that triggers Gemini product auto-fill
/// and opens the interactive preview modal.
class AiAutofillButton extends StatelessWidget {
  final ProductsController controller;
  final String productName;

  const AiAutofillButton({
    super.key,
    required this.controller,
    required this.productName,
  });

  Future<void> _handleGenerate(BuildContext context) async {
    final query = productName.trim();
    if (query.isEmpty) {
      AppFeedback.showWarning('يرجى كتابة اسم المنتج أولاً لتشغيل المساعد الذكي');
      return;
    }

    final suggestion = await controller.fetchAiSuggestions(query);
    if (suggestion != null && context.mounted) {
      AiAutofillDialog.show(
        context: context,
        suggestion: suggestion,
        availableCategories: controller.categories,
        onApply: (updated, selectedSections, categoryId) {
          controller.applyAiSuggestions(
            updated,
            selectedFields: selectedSections,
            categoryIdToSet: categoryId,
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isGenerating = controller.isAiGenerating;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary,
            colorScheme.tertiary,
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: isGenerating ? null : () => _handleGenerate(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isGenerating) ...[
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'جاري استخراج المواصفات...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ] else ...[
                  const Icon(
                    Icons.auto_awesome_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'ملء ذكي بالذكاء الاصطناعي ✨',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
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

