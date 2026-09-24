import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/core/utils/components/build_modern_text_field.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/controllers/promo_form_controller.dart';

/// قسم مظهر ولون خلفية الإعلان مع ألوان جاهزة مقترحة
class PromoAppearanceSection extends StatelessWidget {
  final PromoFormController controller;

  const PromoAppearanceSection({super.key, required this.controller});

  static const List<String> presetColors = [
    '#FFFFFF',
    '#18181B',
    '#0F172A',
    '#B91C1C',
    '#15803D',
    '#1D4ED8',
    '#7C3AED',
    '#C2410C',
    '#0E7490',
  ];

  Color _parseColor(String hex) {
    try {
      final clean = hex.replaceAll('#', '');
      if (clean.length == 6) {
        return Color(int.parse('FF$clean', radix: 16));
      }
    } catch (_) {}
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(() {
              final parsed = _parseColor(controller.backgroundColorHex.value);
              return Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: parsed,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.outlineVariant,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(width: 14),
            Expanded(
              child: ModernTextField(
                icon: Icons.color_lens_outlined,
                label: 'كود اللون (Hex #RRGGBB)',
                controller: controller.backgroundColorController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          'ألوان جاهزة مقترحة:',
          style: theme.textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: presetColors.map((hex) {
            final color = _parseColor(hex);

            return Obx(() {
              final isSelected = controller.backgroundColorHex.value.toUpperCase() ==
                  hex.toUpperCase();

              return InkWell(
                onTap: () => controller.setPresetColor(hex),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.outlineVariant,
                      width: isSelected ? 2.5 : 1.0,
                    ),
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check_rounded,
                          size: 16,
                          color: ThemeData.estimateBrightnessForColor(color) ==
                                  Brightness.dark
                              ? Colors.white
                              : Colors.black87,
                        )
                      : null,
                ),
              );
            });
          }).toList(),
        ),
      ],
    );
  }
}
