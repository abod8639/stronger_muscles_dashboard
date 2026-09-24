import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/controllers/promo_form_controller.dart';

/// قسم حالة نشر وظهور الإعلان
class PromoPublishingSection extends StatelessWidget {
  final PromoFormController controller;

  const PromoPublishingSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Obx(
      () => SwitchListTile.adaptive(
        title: Text(
          'تفعيل الإعلان فوراً',
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          controller.isActive.value
              ? 'الإعلان نشط وسيظهر للمستخدمين في التطبيق'
              : 'الإعلان مسودة ولن يظهر للعملاء',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        value: controller.isActive.value,
        onChanged: (val) => controller.isActive.value = val,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}
