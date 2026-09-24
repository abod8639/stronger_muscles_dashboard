import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/build_modern_text_field.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/controllers/promo_form_controller.dart';

/// قسم النصوص والمحتوى ثنائي اللغة (العربية والإنجليزية)
class PromoLanguageSection extends StatelessWidget {
  final PromoFormController controller;

  const PromoLanguageSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: TabBar(
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              labelColor: colorScheme.onPrimary,
              unselectedLabelColor: colorScheme.onSurfaceVariant,
              labelStyle: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: theme.textTheme.labelLarge,
              tabs: const [
                Tab(
                  icon: Icon(Icons.language_rounded, size: 18),
                  text: 'اللغة العربية',
                ),
                Tab(
                  icon: Icon(Icons.translate_rounded, size: 18),
                  text: 'English',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 250,
            child: TabBarView(
              children: [
                _buildFieldGroup(
                  titleCtrl: controller.titleArController,
                  subtitleCtrl: controller.subtitleArController,
                  buttonCtrl: controller.buttonArController,
                  titleLabel: 'العنوان بالعربية',
                  subtitleLabel: 'العنوان الفرعي بالعربية',
                  buttonLabel: 'نص زر الإجراء (CTA)',
                ),
                _buildFieldGroup(
                  titleCtrl: controller.titleEnController,
                  subtitleCtrl: controller.subtitleEnController,
                  buttonCtrl: controller.buttonEnController,
                  titleLabel: 'Title in English',
                  subtitleLabel: 'Subtitle in English',
                  buttonLabel: 'Button Text (CTA)',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldGroup({
    required TextEditingController titleCtrl,
    required TextEditingController subtitleCtrl,
    required TextEditingController buttonCtrl,
    required String titleLabel,
    required String subtitleLabel,
    required String buttonLabel,
  }) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ModernTextField(
            icon: Icons.title_rounded,
            label: titleLabel,
            controller: titleCtrl,
          ),
          const SizedBox(height: 14),
          ModernTextField(
            icon: Icons.subtitles_rounded,
            label: subtitleLabel,
            controller: subtitleCtrl,
          ),
          const SizedBox(height: 14),
          ModernTextField(
            icon: Icons.smart_button_rounded,
            label: buttonLabel,
            controller: buttonCtrl,
          ),
        ],
      ),
    );
  }
}
