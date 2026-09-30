import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/controllers/promo_form_controller.dart';

/// قسم حالة نشر وظهور الإعلان متوافق مع نمط Bento Grid
class PromoPublishingSection extends StatelessWidget {
  final PromoFormController controller;

  const PromoPublishingSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Obx(
      () => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: controller.isActive.value
                            ? Colors.green
                            : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      controller.isActive.value
                          ? 'الإعلان مفعّل ومنشور'
                          : 'مسودة متوقفة',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  controller.isActive.value
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
            value: controller.isActive.value,
            onChanged: (val) => controller.isActive.value = val,
          ),
        ],
      ),
    );
  }
}
