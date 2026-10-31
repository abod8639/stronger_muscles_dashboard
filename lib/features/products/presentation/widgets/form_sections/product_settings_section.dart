import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/core/theme/theme.dart';
import 'package:stronger_muscles_dashboard/features/products/presentation/controllers/products_controller.dart';
import 'package:stronger_muscles_dashboard/core/components/section_card.dart';

/// قسم إعدادات النشر والظهور للمنتج بتصميم Neumorphism / Soft UI
class ProductSettingsSection extends StatelessWidget {
  final ProductsController controller;

  const ProductSettingsSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) => SectionCard(
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
              value: controller.isActive,
              onChanged: (v) => controller.isActive = v,
            ),
            const SizedBox(height: 12),
            _buildSwitchCard(
              context: context,
              title: 'منتج مميز (Featured)',
              subtitle:
                  'يظهر المنتج في الأقسام والبانرات الرئيسية بالصفحة الأولى',
              icon: Icons.star_outline_rounded,
              value: controller.isFeatured,
              onChanged: (v) => controller.isFeatured = v,
            ),
            const SizedBox(height: 12),
            _buildSwitchCard(
              context: context,
              title: 'وصل حديثاً (New Arrival)',
              subtitle: 'تمييز المنتج كأحدث إضافة في المتجر مع شارة خاصة',
              icon: Icons.fiber_new_rounded,
              value: controller.newArrival,
              onChanged: (v) => controller.newArrival = v,
            ),
            const SizedBox(height: 12),
            _buildSwitchCard(
              context: context,
              title: 'الأكثر مبيعاً (Best Seller)',
              subtitle: 'إبراز المنتج ضمن قائمة الأكثر طلباً ومبيعاً',
              icon: Icons.local_fire_department_rounded,
              value: controller.bestSeller,
              onChanged: (v) => controller.bestSeller = v,
            ),
            const SizedBox(height: 12),
            _buildSwitchCard(
              context: context,
              title: 'خلفية بيضاء (White Background)',
              subtitle: 'عرض صورة المنتج بخلفية بيضاء ناصعة في واجهة العرض',
              icon: Icons.aspect_ratio_rounded,
              value: controller.isBackgroundWhite,
              onChanged: (v) => controller.isBackgroundWhite = v,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: AppDesignTokens.softSurface(
        colorScheme,
        isDark: isDark,
        borderRadius: BorderRadius.circular(14),
        compact: true,
        selected: value,
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        secondary: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: value
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
            color: value ? colorScheme.primary : colorScheme.onSurfaceVariant,
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
  }
}
