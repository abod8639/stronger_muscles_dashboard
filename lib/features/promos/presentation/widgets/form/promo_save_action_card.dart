import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/features/promos/presentation/controllers/promo_form_controller.dart';

/// بطاقة وزر حفظ ونشر الإعلان
class PromoSaveActionCard extends StatelessWidget {
  final PromoFormController controller;

  const PromoSaveActionCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isEditing = controller.isEditing;

    return Obx(
      () => SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: controller.isLoading.value ? null : () => controller.savePromo(),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          icon: controller.isLoading.value
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colorScheme.onPrimary,
                  ),
                )
              : Icon(
                  isEditing ? Icons.save_rounded : Icons.check_circle_rounded,
                  size: 20,
                ),
          label: Text(
            isEditing ? 'حفظ التعديلات' : 'نشر الإعلان في المتجر',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
