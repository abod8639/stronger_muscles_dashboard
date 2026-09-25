import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/controllers/products_controller.dart';
import 'form_section_card.dart';

/// قسم إعدادات النشر والظهور للمنتج بتصميم Neumorphism / Soft UI
class ProductSettingsSection extends StatelessWidget {
  final ProductsController controller;

  const ProductSettingsSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return FormSectionCard(
      title: 'إعدادات النشر والعرض',
      subtitle: 'التحكم في ظهور المنتج وتفضيلاته بالمتجر',
      icon: Icons.toggle_on_outlined,
      child: Column(
        children: [
          _buildSwitchCard(
            context: context,
            title: 'تفعيل المنتج (Active)',
            subtitle: 'عند التفعيل يظهر المنتج لجميع المستخدمين في التطبيق',
            icon: Icons.check_circle_outline_rounded,
            rxValue: controller.isActive,
          ),
          const SizedBox(height: 12),
          _buildSwitchCard(
            context: context,
            title: 'منتج مميز (Featured)',
            subtitle: 'يظهر المنتج في الأقسام والبانرات الرئيسية بالصفحة الأولى',
            icon: Icons.star_outline_rounded,
            rxValue: controller.isFeatured,
          ),
          const SizedBox(height: 12),
          _buildSwitchCard(
            context: context,
            title: 'خلفية بيضاء (White Background)',
            subtitle: 'عرض صورة المنتج بخلفية بيضاء ناصعة في واجهة العرض',
            icon: Icons.aspect_ratio_rounded,
            rxValue: controller.isBackgroundWhite,
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required RxBool rxValue,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Obx(() {
      final isVal = rxValue.value;
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isVal
                ? (isDark
                    ? [
                        Color.lerp(colorScheme.primaryContainer, Colors.white,
                            0.02)!,
                        Color.lerp(colorScheme.surfaceContainer,
                            colorScheme.primary, 0.10)!,
                      ]
                    : [
                        Color.lerp(colorScheme.primaryContainer, Colors.white,
                            0.50)!,
                        Color.lerp(colorScheme.primaryContainer, Colors.black,
                            0.02)!,
                      ])
                : (isDark
                    ? [
                        Color.lerp(colorScheme.surfaceContainerHigh,
                            Colors.white, 0.02)!,
                        Color.lerp(colorScheme.surfaceContainerHigh,
                            Colors.black, 0.10)!,
                      ]
                    : [
                        Colors.white,
                        Color.lerp(colorScheme.surfaceContainerLow,
                            Colors.black, 0.03)!,
                      ]),
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.35)
                  : const Color(0xFFA3B1C6).withValues(alpha: 0.30),
              offset: const Offset(1.5, 2),
              blurRadius: 3,
            ),
            BoxShadow(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.02)
                  : Colors.white.withValues(alpha: 0.90),
              offset: const Offset(-1.5, -1.5),
              blurRadius: 2.5,
            ),
            if (isVal)
              BoxShadow(
                color: colorScheme.primary
                    .withValues(alpha: isDark ? 0.15 : 0.18),
                offset: const Offset(0, 2),
                blurRadius: 8,
              ),
          ],
          border: Border.all(
            color: isVal
                ? colorScheme.primary.withValues(alpha: isDark ? 0.6 : 0.7)
                : (isDark
                    ? Colors.white.withValues(alpha: 0.03)
                    : Colors.white.withValues(alpha: 0.85)),
            width: isVal ? 1.4 : 1.0,
          ),
        ),
        child: SwitchListTile(
          value: isVal,
          onChanged: (v) => rxValue.value = v,
          secondary: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isVal
                  ? colorScheme.primaryContainer
                  : (isDark
                      ? colorScheme.surfaceContainerHighest
                      : colorScheme.surfaceContainerLow),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.25)
                      : const Color(0xFFA3B1C6).withValues(alpha: 0.20),
                  offset: const Offset(1, 1),
                  blurRadius: 2,
                ),
              ],
            ),
            child: Icon(
              icon,
              color: isVal
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          subtitle: Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    });
  }
}
