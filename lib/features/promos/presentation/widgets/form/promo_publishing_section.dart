import 'package:flutter/material.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/controllers/promo_form_controller.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/widgets/promo_status_pill.dart';

/// قسم حالة نشر وظهور الإعلان متوافق مع نمط Bento Grid
class PromoPublishingSection extends StatelessWidget {
  final PromoFormController controller;

  const PromoPublishingSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    PromoStatusPill(isActive: controller.isActive),
                    Text(
                      controller.isActive ? 'منشور في التطبيق' : 'مسودة',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  controller.isActive
                      ? 'يظهر لجميع العملاء في التطبيق فوراً'
                      : 'محفوظ كمسودة داخل لوحة التحكم فقط',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Switch.adaptive(
            value: controller.isActive,
            onChanged: (val) => controller.isActive = val,
          ),
        ],
      ),
    );
  }
}
