import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles_dashboard/features/categories/presentation/controllers/categories_controller.dart';

/// بطاقة وزر حفظ ونشر التصنيف بنمط Material Design 3
class CategorySaveActionCard extends StatelessWidget {
  final CategoriesController controller;
  final bool isEditing;
  final VoidCallback onSave;

  const CategorySaveActionCard({
    super.key,
    required this.controller,
    required this.isEditing,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Obx(() {
      final isLoading = controller.isLoading.value;

      return SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: isLoading ? null : onSave,
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          icon: isLoading
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
            isEditing ? 'حفظ التعديلات' : 'إنشاء وحفظ التصنيف',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onPrimary,
            ),
          ),
        ),
      );
    });
  }
}
